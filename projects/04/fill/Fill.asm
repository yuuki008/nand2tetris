// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen
// by writing 'black' in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen by writing
// 'white' in every pixel;
// the screen should remain fully clear as long as no key is pressed.

//// Replace this comment with your code.

// キーボード監視
    @24576
    D=A
    @keyboard_start
    M=D

(KEYBOARD_EVENT_HANDLER)
    @keyboard_start
    D=M

    @BLACK_SCREEN
    D;JNE

    @KEYBOARD_EVENT_HANDLER
    0;JMP
(KEYBOARD_END)

// スクリーン制御
    @24576
    D=A
    @screen_end
    M=D

    @16384
    D=A
    @screen_start
    M=D

    @i
    M=0

(BLACK_SCREEN)
    @i
    D=M
    @screen-end
    D=D-M
    @screen_start
    D=D-M
    @BLACK_SCREEN_END
    D;JEQ

    @screen_start
    D=M
    @i
    A=D+M
    M=-1

    @i
    M=M+1

    @BLACK_SCREEN
    0;JMP

(BLACK_SCREEN_END)
    @BLACK_SCREEN_END
    0;JMP