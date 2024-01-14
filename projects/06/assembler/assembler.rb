require_relative './parser.rb'
require_relative './code.rb'

class Assembler
  def initialize
  end

  def execute 
    print "アセンブリファイルのパスを入力してください: "
    input_file_path = gets.chomp
    output_file_path = input_file_path.gsub(/\.asm$/, ".hack")
  
    parser = Parser.new(input_file_path)

    File.open(output_file_path, "w") do |hack_file|
      code = Code.new

      while parser.has_more_commands
        case parser.command_type
        when "A_COMMAND"
          hack_file.puts "#{parser.symbol.to_i.to_s(2).rjust(16, "0")}"
        when 'C_COMMAND'
          hack_file.puts "111#{code.comp(parser.comp)}#{code.dest(parser.dest)}#{code.jump(parser.jump)}"
        end

        parser.advance
      end
    end

    puts "Hackファイルへの出力が完了しました。"
  end

  private 

  def get_assembly_file(file_path)
    if File.extname(file_path) != ".asm"
      puts "エラー: 指定されたファイルはアセンブリファイルではありません。プログラムを中断します。"
      exit 1 
    end

    begin
      File.read(file_path)
    rescue Errno::ENOENT
      puts "エラー: 指定されたファイルが見つかりませんでした。プログラムを中断します。"
      exit 1 
    rescue => e
      puts "エラーが発生しました: #{e.message}プログラムを中断します。"
      exit 1 
    end
  end
end

Assembler.new.execute