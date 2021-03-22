ExitProcess PROTO, dwExitCode:DWORD

UpdateGrid PROTO    ; Allows for more control over stack parameters
EXTERNDEF grid_array:DWORD, tile_count:DWORD, dh_pos:BYTE , dl_pos:BYTE

OPTION PROC:PRIVATE ; Make it so only project files can use this module