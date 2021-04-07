ExitProcess PROTO, dwExitCode:DWORD

MapToDisplay PROTO

GridMove PROTO
EXTERNDEF grid_array:DWORD, dh_pos:BYTE, dl_pos:BYTE, dir:BYTE, tile_count:DWORD, current_score:DWORD, current_max:DWORD, moveFlag:BYTE

OPTION PROC:PRIVATE