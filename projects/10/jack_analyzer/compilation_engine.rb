class CompilationEngine
  def initialize(tokenizer)
    @tokenizer = tokenizer
    @output_file = File.open(tokenizer.input_file_path.gsub('.jack', '.xml'), 'w')
    
    compile_class
    @output_file.close
  end

  def compile_class
    write_code('<class>')
    write_code("<keyword> #{@tokenizer.keyword} </keyword>")
    @tokenizer.advance
    write_code("<identifier> #{@tokenizer.identifier} </identifier>")
    @tokenizer.advance
    write_code("<symbol> #{@tokenizer.symbol} </symbol>")
    @tokenizer.advance

    while @tokenizer.token != "}"
      case @tokenizer.keyword
      when 'static', 'field'
        compile_class_var_dec
      when 'constructor', 'function', 'method'
        compile_subroutine
      end
    end

    write_code("<symbol> #{@tokenizer.symbol} </symbol>")
    write_code('</class>')
  end

  def compile_class_var_dec
    write_code('<classVarDec>')
    write_code("<keyword> #{@tokenizer.keyword} </keyword>")
    @tokenizer.advance
    write_code("<keyword> #{@tokenizer.keyword} </keyword>")
    @tokenizer.advance
    write_code("<identifier> #{@tokenizer.identifier} </identifier>")
    @tokenizer.advance
    write_code("<symbol> #{@tokenizer.symbol} </symbol>")
    @tokenizer.advance
    write_code('</classVarDec>')
  end

  def compile_subroutine
    write_code('<subroutineDec>')
    write_code("<keyword> #{@tokenizer.keyword} </keyword>")
    @tokenizer.advance
    write_code("<keyword> #{@tokenizer.keyword} </keyword>")
    @tokenizer.advance
    write_code("<identifier> #{@tokenizer.identifier} </identifier>")
    @tokenizer.advance
    write_code("<symbol> #{@tokenizer.symbol} </symbol>")
    @tokenizer.advance

    compile_parameter_list

    write_code("<symbol> #{@tokenizer.symbol} </symbol>")
    @tokenizer.advance
    write_code('<subroutineBody>')
  
    write_code("<symbol> #{@tokenizer.symbol} </symbol>")
    @tokenizer.advance
    write_code("<symbol> #{@tokenizer.symbol} </symbol>")
    @tokenizer.advance
    write_code('</subroutineBody>')
    write_code('</subroutineDec>')
  end

  def compile_parameter_list
    write_code('<parameterList>')
    write_code('</parameterList>')
  end

  def compile_var_dec
  end

  def compile_statements
  end

  def compile_do
  end

  def compile_let
  end

  def compile_while
  end

  def compile_return
  end

  def compile_if
  end

  def compile_expression
  end

  private

  def write_code(code)
    @output_file.write("#{code}\n")
  end

  def write_codes(codes)
    codes.each do |code|
      write_code(code)
    end
  end
end