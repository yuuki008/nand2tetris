class Code
  def dest(dest)
    case dest
    when "M"
      "001"
    when "D"
      "010"
    when "MD"
      "011"
    when "A"
      "100"
    when "AM"
      "101"
    when "AD"
      "110"
    when "AMD"
      "111"
    else
      "000"
    end
  end

  def comp(comp)
    case comp
    when "0"
      "0101010"
    when "1"
      "0111111"
    when "-1"
      "0111010"
    when "D"
      "0001100"
    when "A"
      "0110000"
    when "!D"
      "0001101"
    when "!A"
      "0110001"
    when "-D"
      "0001111"
    when "-A"
      "0110011"
    when "D+1"
      "0011111"
    when "A+1"
      "0110111"
    when "D-1"
      "0001110"
    when "A-1"
      "0110010"
    when "D+A"
      "0000010"
    when "D-A"
      "0010011"
    when "A-D"
      "0000111"
    when "D&A"
      "0000000"
    when "D|A"
      "0010101"
    when "M"
      "1110000"
    when "!M"
      "1110001"
    when "-M"
      "1110011"
    when "M+1"
      "1110111"
    when "M-1"
      "1110010"
    when "D+M"
      "1000010"
    when "D-M"
      "1010011"
    when "M-D"
      "1000111"
    when "D&M"
      "1000000"
    when "D|M"
      "1010101"
    else
      "0000000"
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