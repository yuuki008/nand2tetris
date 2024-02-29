require_relative './symbol_table'

class CompilationEngine
  UNARY_OP = %w(- ~)
  OP = %w(+ - * / & | < > =)
  TYPE = %w(int char boolean)
  SUBROUTINE = %w(constructor function method)
  CLASS_VAR = %w(static field)
  KEYWORD_CONSTANT = %w(true false null this)
  STATEMENTS = %w(let if while do return)

  def initialize(tokenizer)
    @tokenizer = tokenizer
    @symbol_table = SymbolTable.new
    @output_file = File.open(tokenizer.input_file_path.gsub('.jack', '.xml'), 'w')
    
    compile_class
    @output_file.close
  end

  # ('static' | 'field') type varName (',' varName)* ';'
  def compile_class_var_dec
    write_code('<classVarDec>')
    compile_keyword('static', 'field')
    compile_type
    compile_identifer

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
    compile_class_name
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
    compile_type
    compile_identifer

    while token?(',')
      compile_symbol(',')
      compile_identifer
    end

    compile_symbol(';')
    write_code('</varDec>')
  end

  # ('constructor' | 'function' | 'method') ('void' | type) subroutineName '(' parameterList ')' subroutineBody
  def compile_subroutine_dec
    write_code('<subroutineDec>')
    compile_keyword(*SUBROUTINE)
    compile_return_type
    compile_subroutine_name
    compile_symbol("(")

    compile_parameter_list

    compile_symbol(')')
    compile_subroutine_body
    write_code('</subroutineDec>')
  end

  # '{' varDec* statements '}
  def compile_subroutine_body
    write_code('<subroutineBody>')
    compile_symbol('{')

    while token?([*STATEMENTS, 'var'])
      if token?('var')
        compile_var_dec
      else
        compile_statements
      end
    end

    compile_symbol('}')
    write_code('</subroutineBody>')
  end

  # ((type varName) (',' type varName)* )?
  def compile_parameter_list
    write_code('<parameterList>')

    if token?(TYPE)
      compile_type
      compile_var_name

      while token?(',')
        compile_symbol(',')
        compile_type
        compile_var_name
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
    when 'let'
      compile_let_statement
    when 'if'
      compile_if_statement
    when 'while'
      compile_while_statement
    when 'do'
      compile_do_statement
    when 'return'
      compile_return_statement
    end
  end

  # 'let' varName ('[' expression ']')? '=' expression ';'
  def compile_let_statement
    write_code('<letStatement>')
    compile_keyword("let")
    compile_var_name

    if token?("[")
      compile_symbol("[")
      compile_expression
      compile_symbol("]")
    end

    compile_symbol("=")
    compile_expression
    compile_symbol(";")
    write_code('</letStatement>')
  end

  # 'do' subroutineCall ';'
  def compile_do_statement
    write_code('<doStatement>')
    compile_keyword('do')
    compile_subroutine_call
    compile_symbol(';')
    write_code('</doStatement>')
  end

  # 'while' '(' expression ')' '{' statements '}'
  def compile_while_statement
    write_code('<whileStatement>')
    compile_keyword('while')
    compile_symbol('(')
    compile_expression
    compile_symbol(')')
    compile_symbol('{')
    compile_statements
    compile_symbol('}')
    write_code('</whileStatement>')
  end

  # 'return' expression? ';'
  def compile_return_statement
    write_code('<returnStatement>')
    compile_keyword('return')
    compile_expression unless token?(';')
    compile_symbol(';')
    write_code('</returnStatement>')
  end

  # 'if' '(' expression ')' '{' statements '}' ( 'else' '{' statements '}' )?
  def compile_if_statement
    write_code('<ifStatement>')
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
      compile_op
      compile_term
    end

    write_code('</expression>')
  end

  # integerConstant | stringConstant | keywordConstant | varName | varName '[' expression ']' | subroutineCall | '(' expression ')' | unaryOp term
  def compile_term
    write_code('<term>')
    
    if @tokenizer.token_type == "INT_CONST"
      compile_integer_constant
    elsif @tokenizer.token_type == "STRING_CONST"
      compile_string_constant
    elsif token?(KEYWORD_CONSTANT)
      compile_keyword(*KEYWORD_CONSTANT)
    elsif @tokenizer.token_type == "IDENTIFIER" && (next_token?('.') || next_token?('('))
      compile_subroutine_call
    elsif @tokenizer.token_type == "IDENTIFIER" && next_token?("[")
      compile_var_name
      compile_symbol('[')
      compile_expression
      compile_symbol(']')
    elsif token?('(')
      compile_symbol('(')
      compile_expression
      compile_symbol(')')
    elsif token?(UNARY_OP)
      compile_unary_op
      compile_term
    else @tokenizer.token_type == "IDENTIFIER"
      compile_var_name
    end

    write_code('</term>')
  end

  # subroutineName '(' expressionList ')' | (className | varName) '.' subroutineName '(' expressionList ')'
  def compile_subroutine_call
    if next_token?('(') 
      compile_subroutine_name
      compile_symbol('(')
      compile_expression_list
      compile_symbol(')')
    else
      compile_class_name
      compile_symbol('.')
      compile_subroutine_name
      compile_symbol('(')
      compile_expression_list
      compile_symbol(')')
    end
  end

  # (expression (',' expression)* )?
  def compile_expression_list
    write_code('<expressionList>')

    unless token?(')')
      compile_expression
      while token?(',')
        compile_symbol(',')
        compile_expression
      end
    end

    write_code('</expressionList>')
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
  def compile_var_name
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