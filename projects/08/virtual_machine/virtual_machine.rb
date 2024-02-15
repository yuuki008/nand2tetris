require_relative './parser.rb'
require_relative './code_writer.rb'

class VirtualMachine
  def execute
    # print "VMファイルのパスを入力してください:"
    # file_path = gets.chomp
    path = "../FunctionCalls/StaticsTest"
  

    if path.end_with?(".vm")
      code_writer = CodeWriter.new(path.gsub(".vm", ".asm"))
      translate(path, code_writer)
    else
      dir = path.end_with?("/") ? path[..-2] : path
      output_path = "#{dir}/#{File.basename(dir)}.asm"
      code_writer = CodeWriter.new(output_path)

      if Dir.entries(dir).any? { |file| File.basename(file) == "Sys.vm" }
        code_writer.write_init
      end

      Dir.foreach(dir) do |file|
        next unless File.extname(file) == ".vm"

        translate("#{dir}/#{file}", code_writer)
      end
    end

    puts "Asmファイルへの出力が完了しました。"
  end

  def translate(file_path, code_writer)
    code_writer.set_file_name(file_path)
    parser = Parser.new(file_path)
    
    while parser.has_more_commands
      code_writer.write_comment("#{parser.command_type}, #{parser.arg1}, #{parser.arg2}")
      case parser.command_type
      when "C_ARITHMETIC"
        code_writer.write_arithmetic(parser.arg1)
      when "C_PUSH", "C_POP"
        code_writer.write_push_pop(parser.command_type, parser.arg1, parser.arg2)
      when "C_LABEL"
        code_writer.write_label(parser.arg1)
      when "C_GOTO"
        code_writer.write_goto(parser.arg1)
      when "C_IF"
        code_writer.write_if(parser.arg1)
      when "C_FUNCTION"
        code_writer.write_function(parser.arg1, parser.arg2)
      when "C_RETURN"
        code_writer.write_return
      when "C_CALL"
        code_writer.write_call(parser.arg1, parser.arg2)
      end

      parser.advance
    end
  end
end

VirtualMachine.new.execute