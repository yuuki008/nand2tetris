class VmWriter
  SEGMENTS = {
    "CONST" => "constant",
    "ARG" => "argument",
    "LOCAL" => "local",
    "STATIC" => "static",
    "THIS" => "this",
    "THAT" => "that",
    "POINTER" => "pointer",
    "TEMP" => "temp"
  }
  def initialize(output_file_path)
    @output_file = File.open(output_file_path, 'w')
    @label_count = 0
  end

  def write_push(segment, index)
    raise "Expected segment to be one of #{SEGMENTS.keys.join(', ')} but go \"#{segment}\"" unless SEGMENTS.keys.include?(segment)
    @output_file.puts("push #{SEGMENTS[segment]} #{index}")
  end

  def write_pop(segment, index)
    raise "Expected segment to be one of #{SEGMENTS.keys.join(', ')} but go \"#{segment}\"" unless SEGMENTS.keys.include?(segment)
    @output_file.puts("pop #{SEGMENTS[segment]} #{index}")
  end

  def write_arithmetic(op)
    case op
    when 'ADD'
      @output_file.puts("add")
    when 'SUB'
      @output_file.puts("sub")
    when 'NEG'
      @output_file.puts("neg")
    when "EQ"
      @output_file.puts("eq")
    when "GT"
      @output_file.puts("gt")
    when "LT"
      @output_file.puts("lt")
    when "AND"
      @output_file.puts("and")
    when "OR"
      @output_file.puts("or")
    when "NOT"
      @output_file.puts("not")
    end
  end

  def write_label(label)
    @label_count += 1
    @output_file.puts("label #{label}")
  end

  def write_goto(label)
    @output_file.puts("goto #{label}")
  end

  def write_if(label)
    @output_file.puts("if-goto #{label}")
  end

  def write_call(name, n_args)
    @output_file.puts("call #{name} #{n_args}")
  end

  def write_function(name, n_locals)
    @output_file.puts("function #{name} #{n_locals}")
  end

  def write_return
    @output_file.puts("return")
  end

  def close
    @output_file.close
  end
end