require_relative './parser.rb'
require_relative './code.rb'
require_relative './symbol_table.rb'

class Assembler
  def initialize
  end

  def first_path(symbol_table, file_path)
    parser = Parser.new(file_path)

    pc = 0
    while parser.has_more_commands

      if parser.command_type === "L_COMMAND"
        symbol_table.add_entry(parser.symbol, pc)
      end

      pc += 1
      parser.advance
    end
  end

  def second_path(symbol_table, file_path)
    parser = Parser.new(file_path)

    while parser.has_more_commands
      if parser.command_type === "A_COMMAND" && !parser.symbol.match?(/\A\d+\z/)
        if !symbol_table.contains?(parser.symbol)
          symbol_table.add_entry(parser.symbol, symbol_table.next_address)
        end
      end

      parser.advance
    end
  end

  def execute 
    print "アセンブリファイルのパスを入力してください: "
    input_file_path = gets.chomp
    output_file_path = input_file_path.gsub(/\.asm$/, ".hack")

    symbol_table = SymbolTable.new

    first_path(symbol_table, input_file_path)
    second_path(symbol_table, input_file_path)

    puts symbol_table.table.inspect

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