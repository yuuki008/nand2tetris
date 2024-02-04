// C_PUSH,argument, 1
@ARG
A=M
A=A+1
D=M
@SP
A=M
M=D
@SP
M=M+1
// C_POP,pointer, 1
@SP
M=M-1
A=M
D=M
@3
A=A+1
M=D
// C_PUSH,constant, 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_POP,that, 0
@SP
M=M-1
A=M
D=M
@THAT
A=M
M=D
// C_PUSH,constant, 1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_POP,that, 1
@SP
M=M-1
A=M
D=M
@THAT
A=M
A=A+1
M=D
// C_PUSH,argument, 0
@ARG
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
// C_PUSH,constant, 2
@2
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_ARITHMETIC,sub, 
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
D=M-D
@SP
A=M
M=D
@SP
M=M+1
// C_POP,argument, 0
@SP
M=M-1
A=M
D=M
@ARG
A=M
M=D
// C_LABEL,LOOP, 
(LOOP)
// C_PUSH,argument, 0
@ARG
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
// C_IF,COMPUTE_ELEMENT, 
@SP
M=M-1
A=M
D=M
@COMPUTE_ELEMENT
D;JNE
// C_GOTO,END, 
@END
0;JMP
// C_LABEL,COMPUTE_ELEMENT, 
(COMPUTE_ELEMENT)
// C_PUSH,that, 0
@THAT
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
// C_PUSH,that, 1
@THAT
A=M
A=A+1
D=M
@SP
A=M
M=D
@SP
M=M+1
// C_ARITHMETIC,add, 
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
D=D+M
@SP
A=M
M=D
@SP
M=M+1
// C_POP,that, 2
@SP
M=M-1
A=M
D=M
@THAT
A=M
A=A+1
A=A+1
M=D
// C_PUSH,pointer, 1
@3
A=A+1
D=M
@SP
A=M
M=D
@SP
M=M+1
// C_PUSH,constant, 1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_ARITHMETIC,add, 
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
D=D+M
@SP
A=M
M=D
@SP
M=M+1
// C_POP,pointer, 1
@SP
M=M-1
A=M
D=M
@3
A=A+1
M=D
// C_PUSH,argument, 0
@ARG
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
// C_PUSH,constant, 1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_ARITHMETIC,sub, 
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
D=M-D
@SP
A=M
M=D
@SP
M=M+1
// C_POP,argument, 0
@SP
M=M-1
A=M
D=M
@ARG
A=M
M=D
// C_GOTO,LOOP, 
@LOOP
0;JMP
// C_LABEL,END, 
(END)
