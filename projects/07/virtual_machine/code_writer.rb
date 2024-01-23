class CodeWriter
  def initialize
    @argument = []
    @local = []
    @static = []
    @constant = []
    @this = []
    @that = []
    @pointer = []
    @temp = []
  end

  def set_file_name(file_name)
    output_file_path = file_name.gsub(/\.vm$/, ".asm")
    @output_file = File.open(output_file_path, "w")
  end

  def write_arithmetic(command)
    write_add
    # case command
    # when "add"
    #   write_add
    # when "sub"
    #   write_sub
    # when "neg"
    #   write_neg
    # when "eq"
    #   write_eq
    # when "gt"
    #   write_gt
    # when "lt"
    #   write_lt
    # when "and"
    #   write_and
    # when "or"
    #   write_or
    # when "not"
    #   write_not
    # end
  end

  def write_push_pop(command, segment, index) 
    @output_file.puts "@#{index}"
    @output_file.puts "D=A"
    @output_file.puts "@SP"
    @output_file.puts "A=M"
    @output_file.puts "M=D"
    @output_file.puts "@SP"
    @output_file.puts "M=M+1"
  end

  private 

  def write_add
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "D=M"
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "M=D+M"
    @output_file.puts "@SP"
    @output_file.puts "M=M+1"
  end
end