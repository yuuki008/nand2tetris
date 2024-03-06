require_relative './symbol_table'
require_relative './vm_writer'
require 'debug'

class CompilationEngine
  OP = %w(+ - * / & | < > =)
  OP_COMMAND = {
    "+" => "ADD",
    "-" => "SUB",
    "*" => "CALL Math.multiply 2",
    "/" => "CALL Math.divide 2",
    "&" => "AND",
    "|" => "OR",
    "<" => "LT",
    ">" => "GT",
    "=" => "EQ"
  }
  UNARY_OP = %w(- ~)
  UNARY_OP_COMMAND = {
    "-" => "NEG",
    "~" => "NOT"
  }
  KIND_SEGMENT = {
    "ARG" => "ARG",
    "VAR" => "LOCAL",
    "STATIC" => "STATIC",
    "FIELD" => "THIS",
  }
  TYPE = %w(int char boolean)
  SUBROUTINE = %w(constructor function method)
  CLASS_VAR = %w(static field)
  KEYWORD_CONSTANT = %w(true false null this)
  STATEMENTS = %w(let if while do return)

  def initialize(tokenizer)
    @tokenizer = tokenizer
    @symbol_table = SymbolTable.new
    @vm_writer = VmWriter.new(tokenizer.input_file_path.gsub('.jack', '.vm'))
    @output_file = File.open(tokenizer.input_file_path.gsub('.jack', '.xml'), 'w')
    @label_id = 1
    compile_class
    @output_file.close
  end

  # ('static' | 'field') type varName (',' varName)* ';'
  def compile_class_var_dec
    write_code('<classVarDec>')
    keyword = compile_keyword('static', 'field')
    type = compile_type
    compile_var_name(declaration: true, type: type, kind: keyword)

    while token?(',')
      compile_symbol(',')
      compile_identifer
    end

    compile_symbol(';')
    write_code('</classVarDec>')
  end

  # 'class' className '{' classVarDec* subroutineDec* '}'
  def compile_class
    write_code('<class>')
    compile_keyword('class')
    @class_name = compile_class_name
    compile_symbol('{')

    compile_class_var_dec while next_class_var_dec?
    compile_subroutine_dec while next_subroutine?

    compile_symbol('}')
    write_code('</class>')
  end

  def next_class_var_dec?
    token?(CLASS_VAR)
  end

  def next_subroutine?
    token?(SUBROUTINE)
  end

  # 'var' type varName (',' varName)* ';'
  def compile_var_dec
    write_code('<varDec>')
    compile_keyword('var')
    type = compile_type
    compile_var_name(declaration: true, type: type, kind: "VAR")
    
    var_count = 1
    while token?(',')
      compile_symbol(',')
      compile_var_name(declaration: true, type: type, kind: "VAR")
      var_count += 1
    end

    compile_symbol(';')
    write_code('</varDec>')
    var_count
  end

  # ('constructor' | 'function' | 'method') ('void' | type) subroutineName '(' parameterList ')' subroutineBody
  def compile_subroutine_dec
    @symbol_table.start_subroutine
    write_code('<subroutineDec>')
    compile_keyword(*SUBROUTINE)
    compile_return_type
    function_name = compile_subroutine_name
    compile_symbol("(")

    compile_parameter_list

    compile_symbol(')')

    compile_subroutine_body(function_name)
    write_code('</subroutineDec>')
  end

  # '{' varDec* statements '}
  def compile_subroutine_body(function_name)
    write_code('<subroutineBody>')
    compile_symbol('{')

    var_count = 0
    while token?('var')
      var_count += compile_var_dec
    end

    # 関数定義
    @vm_writer.write_function("#{@class_name}.#{function_name}", var_count)

    compile_statements

    compile_symbol('}')
    write_code('</subroutineBody>')
  end

  # ((type varName) (',' type varName)* )?
  def compile_parameter_list
    write_code('<parameterList>')

    if token?(TYPE)
      type = compile_type
      compile_var_name(declaration: true, type: type, kind:'ARG')

      while token?(',')
        compile_symbol(',')
        compile_type
        compile_var_name(declaration: true, type: type, kind: 'ARG')
      end
    end

    write_code('</parameterList>')
  end

  # statement*
  def compile_statements
    write_code('<statements>')

    while token?(%w(let if while do return))
      compile_statement
    end

    write_code('</statements>')
  end

  # letStatement | ifStatement | whileStatement | doStatement | returnStatement
  def compile_statement
    case @tokenizer.keyword
    when 'LET'
      compile_let_statement
    when 'IF'
      compile_if_statement
    when 'WHILE'
      compile_while_statement
    when 'DO'
      compile_do_statement
    when 'RETURN'
      compile_return_statement
    end
  end

  # 'let' varName ('[' expression ']')? '=' expression ';'
  def compile_let_statement
    write_code('<letStatement>')
    compile_keyword("let")
    identifer = compile_var_name(declaration: false, type: nil, kind: nil)
    
    if token?("[")
      compile_symbol("[")
      compile_expression
      compile_symbol("]")
    end
    
    compile_symbol("=")
    compile_expression
    compile_symbol(";")
    index = @symbol_table.index_of(identifer)
    kind = @symbol_table.kind_of(identifer)
    @vm_writer.write_pop(KIND_SEGMENT[kind], index)
    write_code('</letStatement>')
  end

  # 'do' subroutineCall ';'
  def compile_do_statement
    write_code('<doStatement>')
    compile_keyword('do')
    compile_subroutine_call
    compile_symbol(';')
    write_code('</doStatement>')

    @vm_writer.write_pop('TEMP', 0)
  end

  # 'while' '(' expression ')' '{' statements '}'
  def compile_while_statement
    while_true_label = "LABEL_#{@label_id}" 
    @label_id += 1
    while_false_label = "LABEL_#{@label_id}"
    @label_id += 1
    @vm_writer.write_label(while_true_label)
    
    write_code('<whileStatement>')
    compile_keyword('while')
    compile_symbol('(')
    compile_expression
    compile_symbol(')')

    @vm_writer.write_arithmetic('NOT')
    @vm_writer.write_if(while_false_label)

    compile_symbol('{')
    compile_statements
    compile_symbol('}')
    write_code('</whileStatement>')
    @vm_writer.write_label(while_false_label)
  end

  # 'return' expression? ';'
  def compile_return_statement
    write_code('<returnStatement>')
    compile_keyword('return')
    if token?(';')
      @vm_writer.write_push('CONST', 0)
    else
      compile_expression
    end

    @vm_writer.write_return
    compile_symbol(';')
    write_code('</returnStatement>')
  end

  # 'if' '(' expression ')' '{' statements '}' ( 'else' '{' statements '}' )?
  def compile_if_statement
    compile_keyword('if')
    compile_symbol('(')
    compile_expression
    compile_symbol(')')
    compile_symbol('{')
    compile_statements
    compile_symbol('}')

    if token?('else')
      compile_keyword('else')
      compile_symbol('{')
      compile_statements
      compile_symbol('}')
    end

    write_code('</ifStatement>')
  end

  # term (op term)*
  def compile_expression
    write_code('<expression>')

    compile_term

    while token?(OP)
      op = compile_op
      compile_term
      @vm_writer.write_arithmetic(OP_COMMAND[op])
    end

    write_code('</expression>')
  end

  # integerConstant | stringConstant | keywordConstant | varName | varName '[' expression ']' | subroutineCall | '(' expression ')' | unaryOp term
  def compile_term
    write_code('<term>')
    
    if @tokenizer.token_type == "INT_CONST"
      int_val = compile_integer_constant
      @vm_writer.write_push('CONST', int_val)
    elsif @tokenizer.token_type == "STRING_CONST"
      compile_string_constant
    elsif token?(KEYWORD_CONSTANT)
      compile_keyword_constant
    elsif @tokenizer.token_type == "IDENTIFIER" && (next_token?('.') || next_token?('('))
      compile_subroutine_call
    elsif @tokenizer.token_type == "IDENTIFIER" && next_token?("[")
      compile_var_name(declaration: false, type: nil, kind: nil)
      compile_symbol('[')
      compile_expression
      compile_symbol(']')
    elsif token?('(')
      compile_symbol('(')
      compile_expression
      compile_symbol(')')
    elsif token?(UNARY_OP)
      op = compile_unary_op
      compile_term
      @vm_writer.write_arithmetic(UNARY_OP_COMMAND[op])
    else @tokenizer.token_type == "IDENTIFIER"
      identifer = compile_var_name(declaration: false, type: nil, kind: nil)

      index = @symbol_table.index_of(identifer)
      kind = @symbol_table.kind_of(identifer)
      @vm_writer.write_push(KIND_SEGMENT[kind], index)
    end

    write_code('</term>')
  end

  def compile_keyword_constant
    keyword_constant = compile_keyword(*KEYWORD_CONSTANT)
    @vm_writer.write_push('CONST', 0)
    case keyword_constant
    when 'TRUE'
      @vm_writer.write_arithmetic('NOT')
    when 'FALSE', 'NULL'
    end
  end

  # subroutineName '(' expressionList ')' | (className | varName) '.' subroutineName '(' expressionList ')'
  def compile_subroutine_call
    subroutine_name = ""
    n_args = 0
    if next_token?('(') 
      subroutine_name = compile_subroutine_name
      compile_symbol('(')
      n_args = compile_expression_list
      compile_symbol(')')
    else
      class_name = compile_class_name
      compile_symbol('.')
      subroutine_name = "#{class_name}.#{compile_subroutine_name}"
      compile_symbol('(')
      n_args = compile_expression_list
      compile_symbol(')')
    end

    # 関数呼び出し
    @vm_writer.write_call(subroutine_name, n_args)
  end

  # (expression (',' expression)* )?
  def compile_expression_list
    write_code('<expressionList>')

    n_args = 0
    unless token?(')')
      compile_expression
      n_args += 1
      while token?(',')
        compile_symbol(',')
        compile_expression
        n_args += 1
      end
    end

    write_code('</expressionList>')
    n_args
  end

  # '+' | '-' | '*' | '/' | '&' | '|' | '<' | '>' | '='
  def compile_op
    compile_symbol(*OP)
  end

  # '-' | '~'
  def compile_unary_op
    compile_symbol('-', '~')
  end

  private

  # identifier
  def compile_class_name
    write_code("<IdentifierInfo> category: class </IdentifierInfo>")
    compile_identifer
  end

  # identifier
  def compile_subroutine_name
    write_code("<IdentifierInfo> category: subroutine </IdentifierInfo>")
    compile_identifer
  end

  # identifier
  def compile_var_name(declaration: false, type: nil, kind: nil)
    if declaration
      @symbol_table.define(@tokenizer.identifier, type, kind)
    end

    kind = @symbol_table.kind_of(@tokenizer.identifier)
    index = @symbol_table.index_of(@tokenizer.identifier)
    write_code("<IdentifierInfo> declaration: #{declaration ? "True" : "False"}, kind: #{kind}, index:  #{index} </IdentifierInfo>")
    compile_identifer
  end

  def compile_return_type
    if token?(%w(void))
      compile_keyword('void')
    else
      compile_type
    end
  end

  # 'int' | 'char' | 'boolean' | className
  def compile_type
    if token?(TYPE)
      compile_keyword(*TYPE)
    else
      compile_identifer
    end
  end

  # 終端記号
  def compile_keyword(*tokens)
    unless tokens.include?(@tokenizer.token)
      raise "Expected keyword: \"#{tokens.join(', ')}\" but got \"#{@tokenizer.token}\""
    end

    keyword = @tokenizer.keyword
    write_code("<keyword> #{keyword} </keyword>")
    @tokenizer.advance

    keyword
  end

  def compile_symbol(*tokens)
    unless tokens.include?(@tokenizer.token)
      raise "Expected symbol: \"#{tokens.join(', ')}\" but got \"#{@tokenizer.token}\""
    end

    escape_symbol = @tokenizer.escape_symbol
    write_code("<symbol> #{escape_symbol} </symbol>")
    @tokenizer.advance

    escape_symbol
  end

  def compile_identifer

    identifer = @tokenizer.identifier
    write_code("<identifier> #{identifer} </identifier>")
    @tokenizer.advance

    identifer
  end

  def compile_integer_constant
    int_val = @tokenizer.int_val
    write_code("<integerConstant> #{int_val} </integerConstant>")
    @tokenizer.advance

    int_val
  end

  def compile_string_constant
    escape_string_val = @tokenizer.escape_string_val
    write_code("<stringConstant> #{escape_string_val} </stringConstant>")
    @tokenizer.advance

    escape_string_val
  end

  def write_code(code)
    @output_file.write("#{code}\n")
  end

  def write_codes(codes)
    codes.each do |code|
      write_code(code)
    end
  end

  def token?(tokens)
    tokens.include?(@tokenizer.token)
  end

  def next_token?(tokens)
    tokens.include?(@tokenizer.next_token)
  end

  def next_next_token?(tokens)
    tokens.include?(@tokenizer.next_next_token)
  end
end