class VmWriter
  def initialize(output_file_path)
    @output_file = File.open(output_file_path, 'w')
  end

  def write_push(segment, index)
    @output_file.puts("push #{segment} #{index}")
  end

  def write_pop(segment, index)
    @output_file.puts("pop #{segment} #{index}")
  end

  def write_arithmetic(command)
    @output_file.puts(command)
  end

  def write_label(label)
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