@256
D=A
@SP
M=D
@_RETURN_LABEL_1
D=A
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
@0
D=A
@5
D=D+A
@SP
D=M-D
@ARG
M=D
@SP
D=M
@LCL
M=D
@Sys.init
0;JMP
(_RETURN_LABEL_1)
// C_FUNCTION, Sys.init, 0
(Sys.init)
D=0
// C_PUSH, constant, 4000
@4000
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_POP, pointer, 0
@SP
M=M-1
A=M
D=M
@3
M=D
// C_PUSH, constant, 5000
@5000
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_POP, pointer, 1
@SP
M=M-1
A=M
D=M
@3
A=A+1
M=D
// C_CALL, Sys.main, 0
@_RETURN_LABEL_2
D=A
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
@0
D=A
@5
D=D+A
@SP
D=M-D
@ARG
M=D
@SP
D=M
@LCL
M=D
@Sys.main
0;JMP
(_RETURN_LABEL_2)
// C_POP, temp, 1
@SP
M=M-1
A=M
D=M
@5
A=A+1
M=D
// C_LABEL, LOOP, 
(LOOP)
// C_GOTO, LOOP, 
@LOOP
0;JMP
// C_FUNCTION, Sys.main, 5
(Sys.main)
D=0
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M
M=D
@SP
M=M+1
// C_PUSH, constant, 4001
@4001
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_POP, pointer, 0
@SP
M=M-1
A=M
D=M
@3
M=D
// C_PUSH, constant, 5001
@5001
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_POP, pointer, 1
@SP
M=M-1
A=M
D=M
@3
A=A+1
M=D
// C_PUSH, constant, 200
@200
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_POP, local, 1
@SP
M=M-1
A=M
D=M
@LCL
A=M
A=A+1
M=D
// C_PUSH, constant, 40
@40
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_POP, local, 2
@SP
M=M-1
A=M
D=M
@LCL
A=M
A=A+1
A=A+1
M=D
// C_PUSH, constant, 6
@6
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_POP, local, 3
@SP
M=M-1
A=M
D=M
@LCL
A=M
A=A+1
A=A+1
A=A+1
M=D
// C_PUSH, constant, 123
@123
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_CALL, Sys.add12, 1
@_RETURN_LABEL_3
D=A
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
@1
D=A
@5
D=D+A
@SP
D=M-D
@ARG
M=D
@SP
D=M
@LCL
M=D
@Sys.add12
0;JMP
(_RETURN_LABEL_3)
// C_POP, temp, 0
@SP
M=M-1
A=M
D=M
@5
M=D
// C_PUSH, local, 0
@LCL
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
// C_PUSH, local, 1
@LCL
A=M
A=A+1
D=M
@SP
A=M
M=D
@SP
M=M+1
// C_PUSH, local, 2
@LCL
A=M
A=A+1
A=A+1
D=M
@SP
A=M
M=D
@SP
M=M+1
// C_PUSH, local, 3
@LCL
A=M
A=A+1
A=A+1
A=A+1
D=M
@SP
A=M
M=D
@SP
M=M+1
// C_PUSH, local, 4
@LCL
A=M
A=A+1
A=A+1
A=A+1
A=A+1
D=M
@SP
A=M
M=D
@SP
M=M+1
// C_ARITHMETIC, add, 
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
// C_ARITHMETIC, add, 
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
// C_ARITHMETIC, add, 
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
// C_ARITHMETIC, add, 
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
// C_RETURN, return, 
@LCL
D=M
@R13
M=D
@5
A=D-A
D=M
@R14
M=D
@SP
AM=M-1
D=M
@ARG
A=M
M=D
@ARG
D=M+1
@SP
M=D
@R13
D=M-1
AM=D
D=M
@THAT
M=D
@R13
D=M-1
AM=D
D=M
@THIS
M=D
@R13
D=M-1
AM=D
D=M
@ARG
M=D
@R13
D=M-1
AM=D
D=M
@LCL
M=D
@R14
A=M
0;JMP
// C_FUNCTION, Sys.add12, 0
(Sys.add12)
D=0
// C_PUSH, constant, 4002
@4002
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_POP, pointer, 0
@SP
M=M-1
A=M
D=M
@3
M=D
// C_PUSH, constant, 5002
@5002
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_POP, pointer, 1
@SP
M=M-1
A=M
D=M
@3
A=A+1
M=D
// C_PUSH, argument, 0
@ARG
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
// C_PUSH, constant, 12
@12
D=A
@SP
A=M
M=D
@SP
M=M+1
// C_ARITHMETIC, add, 
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
// C_RETURN, return, 
@LCL
D=M
@R13
M=D
@5
A=D-A
D=M
@R14
M=D
@SP
AM=M-1
D=M
@ARG
A=M
M=D
@ARG
D=M+1
@SP
M=D
@R13
D=M-1
AM=D
D=M
@THAT
M=D
@R13
D=M-1
AM=D
D=M
@THIS
M=D
@R13
D=M-1
AM=D
D=M
@ARG
M=D
@R13
D=M-1
AM=D
D=M
@LCL
M=D
@R14
A=M
0;JMP
