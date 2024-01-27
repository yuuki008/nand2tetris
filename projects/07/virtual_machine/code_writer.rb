class CodeWriter
  def initialize
    @output_file = nil
    @label_count = 0
  end

  def set_file_name(file_name)
    output_file_path = file_name.gsub(/\.vm$/, ".asm")
    @output_file = File.open(output_file_path, "w")
  end

  def write_arithmetic(command)
    case command
    when "add"
      write_add
    when "sub"
      write_sub
    when "neg"
      write_neg
    when "eq"
      write_eq
    when "gt"
      write_gt
    when "lt"
      write_lt
    when "and"
      write_and
    when "or"
      write_or
    when "not"
      write_not
    end
  end

  def write_push_pop(command, segment, index) 
    case command
    when "C_PUSH"
      write_push(segment, index)
    when "C_POP"
      write_pop(segment, index)
    end
  end

  private 

  def write_push(segment, index)
    @output_file.puts "@#{index}"
    @output_file.puts "D=A"
    @output_file.puts "@SP"
    @output_file.puts "A=M"
    @output_file.puts "M=D"
    @output_file.puts "@SP"
    @output_file.puts "M=M+1"
  end

  def write_pop(segment, index)
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "D=M"
    @output_file.puts "@#{index}"
    @output_file.puts "M=D"
    @output_file.puts "@SP"
    @output_file.puts "M=M+1"
  end

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

  def write_sub
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "D=-M"
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "M=D+M"
    @output_file.puts "@SP"
    @output_file.puts "M=M+1"
  end

  def write_neg
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "M=-M"
    @output_file.puts "@SP"
    @output_file.puts "M=M+1"
  end

  def write_eq
    @label_count += 1
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "D=M"
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "D=D-M"
    @output_file.puts "@EQ_TRUE_#{@label_count}"
    @output_file.puts "D;JEQ"
    @output_file.puts "D=0"
    @output_file.puts "@EQ_END_#{@label_count}"
    @output_file.puts "0;JMP"
    @output_file.puts "(EQ_TRUE_#{@label_count})"
    @output_file.puts "D=-1"
    @output_file.puts "(EQ_END_#{@label_count})"
    @output_file.puts "@SP"
    @output_file.puts "A=M"
    @output_file.puts "M=D"
    @output_file.puts "@SP"
    @output_file.puts "M=M+1"
  end

  def write_gt
    @label_count += 1
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "D=M"
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "D=D-M"
    @output_file.puts "@LT_TRUE_#{@label_count}"
    @output_file.puts "D;JLT"
    @output_file.puts "D=0"
    @output_file.puts "@LT_END_#{@label_count}"
    @output_file.puts "0;JMP"
    @output_file.puts "(LT_TRUE_#{@label_count})"
    @output_file.puts "D=-1"
    @output_file.puts "(LT_END_#{@label_count})"
    @output_file.puts "@SP"
    @output_file.puts "A=M"
    @output_file.puts "M=D"
    @output_file.puts "@SP"
    @output_file.puts "M=M+1"
  end

  def write_lt
    @label_count += 1
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "D=M"
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "D=D-M"
    @output_file.puts "@LT_TRUE_#{@label_count}"
    @output_file.puts "D;JGT"
    @output_file.puts "D=0"
    @output_file.puts "@LT_END_#{@label_count}"
    @output_file.puts "0;JMP"
    @output_file.puts "(LT_TRUE_#{@label_count})"
    @output_file.puts "D=-1"
    @output_file.puts "(LT_END_#{@label_count})"
    @output_file.puts "@SP"
    @output_file.puts "A=M"
    @output_file.puts "M=D"
    @output_file.puts "@SP"
    @output_file.puts "M=M+1"
  end

  def write_and
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "D=M"
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "M=D&M"
    @output_file.puts "@SP"
    @output_file.puts "M=M+1"
  end

  def write_or
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "D=M"
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "M=D|M"
    @output_file.puts "@SP"
    @output_file.puts "M=M+1"
  end

  def write_not
    @output_file.puts "@SP"
    @output_file.puts "M=M-1"
    @output_file.puts "A=M"
    @output_file.puts "M=!M"
    @output_file.puts "@SP"
    @output_file.puts "M=M+1"
  end
end