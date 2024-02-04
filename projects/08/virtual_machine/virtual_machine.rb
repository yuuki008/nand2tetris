require_relative './parser.rb'
require_relative './code_writer.rb'

class VirtualMachine
  def initialize(file_path)
    @file_path = file_path
    @code_writer = CodeWriter.new
    @code_writer.set_file_name(file_path)
  end

  def translate
    parser = Parser.new(@file_path)
    
    while parser.has_more_commands
      @code_writer.write_divider_comment("#{parser.command_type},#{parser.arg1}, #{parser.arg2}")
      case parser.command_type
      when "C_ARITHMETIC"
        @code_writer.write_arithmetic(parser.arg1)
      when "C_PUSH", "C_POP"
        @code_writer.write_push_pop(parser.command_type, parser.arg1, parser.arg2)
      when "C_LABEL"
        @code_writer.write_label(parser.arg1)
      when "C_GOTO"
        @code_writer.write_goto(parser.arg1)
      when "C_IF"
        @code_writer.write_if(parser.arg1)
      end


      parser.advance
    end

    puts "Asmファイルへの出力が完了しました。"
  end
end

# print "VMファイルのパスを入力してください:"
# file_path = gets.chomp
file_path = "../ProgramFlow/FibonacciSeries/FibonacciSeries.vm"
VirtualMachine.new(file_path).translate