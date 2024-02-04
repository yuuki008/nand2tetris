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

  def write_init
    write_commands([
      "@256",
      "D=A",
      "@SP",
      "M=D"
    ])
    write_call("Sys.init", 0)
  end

  def write_label(label_name)
    write_commands([
      "(#{label_name})"
    ])
  end

  def write_goto(label_name)
    write_commands([
      "@#{label_name}",
      "0;JMP"
    ])
  end

  def write_if(label_name)
    write_pop_to_a_register
    write_commands([
      'D=M',
      "@#{label_name}",
      'D;JNE'
    ])
  end

  def write_call(function_name, num_args)

  end

  def write_return

  end

  def write_function
    
  end

  def write_arithmetic(command)
    case command
    when 'add', 'sub', 'and', 'or'
      write_binary_operation(command)
    when "neg", 'not'
      write_unary_operation(command)
    when "eq", "gt", "lt"
      write_comp_operation(command)
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

  def write_divider_comment(text)
    write_command("// #{text}")
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

  def write_binary_operation(command)
    write_pop_to_a_register
    write_command('D=M')
    write_pop_to_a_register

    case command
    when "add"
      write_command('D=D+M')
    when 'sub'
      write_command('D=M-D')
    when 'and'
      write_command('D=D&M')
    when 'or'
      write_command('D=D|M')
    end
    write_push_from_d_register
  end

  def write_unary_operation(command)
    write_commands([
      '@SP',
      'A=M-1',
    ])

    case command
    when "neg"
      write_command('M=-M')
    when "not"
      write_command('M=!M')
    end
  end

  def write_comp_operation(command)
    write_pop_to_a_register
    write_command('D=M')
    write_pop_to_a_register
    l1 = new_label
    l2 = new_label

    case command
    when "eq"
      com_type = "JEQ"
    when "gt"
      comp_type = "JGT"
    when "lt"
      comp_type = "JLT"
    end

    write_commands([
      "D=M-D",
      "@#{l1}",
      "D;#{comp_type}",
      "D=0",
      "@#{l2}",
      "0;JMP",
      "(#{l1})",
      "D=-1",
      "(#{l2})",
    ])
    write_push_from_d_register
  end

  def write_pop_to_a_register
    write_commands([
      '@SP',
      'M=M-1',
      'A=M'
    ])
  end

  def write_push_from_d_register
    write_commands([
      '@SP',
      'A=M',
      'M=D',
      '@SP',
      'M=M+1'
    ])
  end

  def write_command(command)
    @output_file.puts(command)
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