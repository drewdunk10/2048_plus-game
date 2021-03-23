ExitProcess PROTO, dwExitCode:DWORD

UserPrompt PROTO    ; Allows for more control over stack parameters
EXTERNDEF dir:BYTE  ; external definition (dir defined in main module)

OPTION PROC:PRIVATE ; Make it so only project files can use this module

