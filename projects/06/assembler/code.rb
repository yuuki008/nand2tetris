class Code
  def dest(dest)
    dest_binary = "000"

    if dest == "M"
      dest_binary = "001"
    elsif dest == "D"
      dest_binary = "010"
    elsif dest == "MD"
      dest_binary = "011"
    elsif dest == "A"
      dest_binary = "100"
    elsif dest == "AM"
      dest_binary = "101"
    elsif dest == "AD"
      dest_binary = "110"
    elsif dest == "AMD"
      dest_binary = "111"
    end
  end

  def comp(comp)
    comp_binary = "0000000"

    if comp == "0"
      comp_binary = "0101010"
    elsif comp == "1"
      comp_binary = "0111111"
    elsif comp == "-1"
      comp_binary = "0111010"
    elsif comp == "D"
      comp_binary = "0001100"
    elsif comp == "A"
      comp_binary = "0110000"
    elsif comp == "!D"
      comp_binary = "0001101"
    elsif comp == "!A"
      comp_binary = "0110001"
    elsif comp == "-D"
      comp_binary = "0001111"
    elsif comp == "-A"
      comp_binary = "0110011"
    elsif comp == "D+1"
      comp_binary = "0011111"
    elsif comp == "A+1"
      comp_binary = "0110111"
    elsif comp == "D-1"
      comp_binary = "0001110"
    elsif comp == "A-1"
      comp_binary = "0110010"
    elsif comp == "D+A"
      comp_binary = "0000010"
    elsif comp == "D-A"
      comp_binary = "0010011"
    elsif comp == "A-D"
      comp_binary = "0000111"
    elsif comp == "D&A"
      comp_binary = "0000000"
    elsif comp == "D|A"
      comp_binary = "0010101"
    elsif comp == "M"
      comp_binary = "1110000"
    elsif comp == "!M"
      comp_binary = "1110001"
    elsif comp == "-M"
      comp_binary = "1110011"
    elsif comp == "M+1"
      comp_binary = "1110111"
    elsif comp == "M-1"
      comp_binary = "1110010"
    elsif comp == "D+M"
      comp_binary = "1000010"
    elsif comp == "D-M"
      comp_binary = "1010011"
    elsif comp == "M-D"
      comp_binary = "1000111"
    elsif comp == "D&M"
      comp_binary = "1000000"
    elsif comp == "D|M"
      comp_binary = "101010"
    end
  end

  def jump(jump)
    case jump
    when "JGT"
      '001'
    when "JEQ"
      '010'
    when "JGE"
      '011'
    when 'JLT'
      '100'
    when 'JNE'
      '101'
    when 'JLE'
      '110'
    when 'JMP'
      '111'
    else
      '000'
    end
  end
end