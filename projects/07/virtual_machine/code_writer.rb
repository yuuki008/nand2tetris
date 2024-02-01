class CodeWriter
  REFERENCED_SEGMENTS = {
    "local" => "LCL",
    "argument" => "ARG",
    "this" => "THIS",
    "that" => "THAT",
  }.freeze

  STATIC_SEGMENTS = {
    "pointer" => 3,
    "temp" => 5,
  }.freeze

  def initialize
    @output_file = nil
    @label_count = 0
    @set_file_name = nil
  end

  def set_file_name(file_name)
    @set_file_name = File.basename(file_name, File.extname(file_name))
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
    case
    when REFERENCED_SEGMENTS.keys.include?(segment)
      write_push_from_referenced_segment(segment, index)
    when STATIC_SEGMENTS.keys.include?(segment)
      write_push_from_static_segment(segment, index)
    when segment == "static" 
      write_push_from_static(segment, index)
    when segment == "constant"
      write_push_from_constant_segment(segment, index)
    end
  end

  def write_push_from_referenced_segment(segment, index)
    commands = []
    commands << "@#{REFERENCED_SEGMENTS[segment]}"
    commands << "A=M"
    for i in 0..index.to_i - 1
      commands << "A=A+1"
    end
    commands << "D=M"
    commands << "@SP"
    commands << "A=M"
    commands << "M=D"
    commands << "@SP"
    commands << "M=M+1"

    write_commands(commands)
  end

  def write_push_from_static_segment(segment, index)
    commands = []
    commands << "@#{STATIC_SEGMENTS[segment]}"
    for i in 0..index.to_i - 1
      commands << "A=A+1"
    end
    commands << "D=M"
    commands << "@SP"
    commands << "A=M"
    commands << "M=D"
    commands << "@SP"
    commands << "M=M+1"

    write_commands(commands)
  end

  def write_push_from_static(segment, index)
    commands = []
    commands << "@#{@set_file_name}.#{index}"
    commands << "D=M"
    commands << "@SP"
    commands << "A=M"
    commands << "M=D"
    commands << "@SP"
    commands << "M=M+1"

    write_commands(commands)
  end

  def write_push_from_constant_segment(segment, index)
    commands = []
    commands << "@#{index}"
    commands << "D=A"
    commands << "@SP"
    commands << "A=M"
    commands << "M=D"
    commands << "@SP"
    commands << "M=M+1"

    write_commands(commands)
  end

  def write_pop(segment, index)
    case
    when REFERENCED_SEGMENTS.keys.include?(segment)
      write_pop_from_referenced_segment(segment, index)
    when STATIC_SEGMENTS.keys.include?(segment)
      write_pop_from_static_segment(segment, index)
    when segment == "static"
      write_pop_from_static(segment, index)
    when segment == "constant"
      write_pop_from_constant_segment(segment, index)
    end
  end

  def write_pop_from_referenced_segment(segment, index)
    commands = []
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=M"
    commands << "@#{REFERENCED_SEGMENTS[segment]}"
    commands << "A=M"
    for i in 0..index.to_i - 1
      commands << "A=A+1"
    end
    commands << "M=D"

    write_commands(commands)
  end

  def write_pop_from_static_segment(segment, index)
    commands = []
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=M"
    commands << "@#{STATIC_SEGMENTS[segment]}"
    for i in 0..index.to_i - 1
      commands << "A=A+1"
    end
    commands << "M=D"

    write_commands(commands)
  end

  def write_pop_from_static(segment, index)
    commands = []
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=M"
    commands << "@#{@set_file_name}.#{index}"
    commands << "M=D"

    write_commands(commands)
  end

  def write_pop_from_constant_segment(segment, index)
    commands = []
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=M"
    commands << "@#{index}"
    commands << "M=D"
    write_commands(commands)
  end

  def write_add
    commands = []
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=M"
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=D+M"
    commands << "@SP"
    commands << "A=M"
    commands << "M=D"
    commands << "@SP"
    commands << "M=M+1"
    write_commands(commands)
  end

  def write_sub
    commands = []
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=M"
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=M-D"
    commands << "@SP"
    commands << "A=M"
    commands << "M=D"
    commands << "@SP"
    commands << "M=M+1"
    write_commands(commands)
  end

  def write_neg
    commands = []
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "M=-M"
    commands << "@SP"
    commands << "M=M+1"
    write_commands(commands)
  end

  def write_eq
    commands = []
    true_label = new_label
    false_label = new_label

    @label_count += 1
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=M"
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=D-M"
    commands << "@#{true_label}"
    commands << "D;JEQ"
    commands << "D=0"
    commands << "@#{false_label}"
    commands << "0;JMP"
    commands << "(#{true_label})"
    commands << "D=-1"
    commands << "(#{false_label})"
    commands << "@SP"
    commands << "A=M"
    commands << "M=D"
    commands << "@SP"
    commands << "M=M+1"
    write_commands(commands)
  end

  def write_gt
    commands = []
    true_label = new_label
    false_label = new_label

    @label_count += 1
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=M"
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=D-M"
    commands << "@#{true_label}"
    commands << "D;JLT"
    commands << "D=0"
    commands << "@#{false_label}"
    commands << "0;JMP"
    commands << "(#{true_label})"
    commands << "D=-1"
    commands << "(#{false_label})"
    commands << "@SP"
    commands << "A=M"
    commands << "M=D"
    commands << "@SP"
    commands << "M=M+1"
    write_commands(commands)
  end

  def write_lt
    commands = []
    true_label = new_label
    false_label = new_label
    @label_count += 1
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=M"
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=D-M"
    commands << "@#{true_label}"
    commands << "D;JGT"
    commands << "D=0"
    commands << "@#{false_label}"
    commands << "0;JMP"
    commands << "(#{true_label})"
    commands << "D=-1"
    commands << "(#{false_label})"
    commands << "@SP"
    commands << "A=M"
    commands << "M=D"
    commands << "@SP"
    commands << "M=M+1"
    write_commands(commands)
  end

  def write_and
    commands = []
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=M"
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "M=D&M"
    commands << "@SP"
    commands << "M=M+1"
    write_commands(commands)
  end

  def write_or
    commands = []
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "D=M"
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "M=D|M"
    commands << "@SP"
    commands << "M=M+1"
    write_commands(commands)
  end

  def write_not
    commands = []
    commands << "@SP"
    commands << "M=M-1"
    commands << "A=M"
    commands << "M=!M"
    commands << "@SP"
    commands << "M=M+1"
    write_commands(commands)
  end

  def write_commands(commands)
    commands.each do |command|
      @output_file.puts(command)
    end
  end

  def new_label
    @label_count += 1
    "LABEL_#{@label_count}"
  end
end