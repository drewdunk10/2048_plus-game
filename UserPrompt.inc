.386 ; Specifies that 32-bit instructions will be used (and compiled that way).
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
DumpRegs PROTO

UserPrompt PROTO    ; Allows for more control over stack parameters
EXTERNDEF dir:BYTE ; external definition (dir defined in main module)

OPTION PROC:PRIVATE ; Make it so only project files can use this module

