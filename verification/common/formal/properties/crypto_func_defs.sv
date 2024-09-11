function automatic SHA256SIG1();
  return instr_word[6:0] == 7'b0010011  && instr_word[14:12] == 3'b001  && instr_word[24:20] == 5'b00011  && instr_word[29:25] == 5'b01000  && instr_word[31:30] == 2'b00 ;
 endfunction

function automatic SHA512SIG1();
  return instr_word[6:0] == 7'b0010011  && instr_word[14:12] == 3'b001  && instr_word[24:20] == 5'b00111  && instr_word[29:25] == 5'b01000  && instr_word[31:30] == 2'b00 ;
 endfunction

function automatic AES64KS1I();
  return instr_word[6:0] == 7'b0010011  && instr_word[14:12] == 3'b001  && instr_word[24:24] == 1'b1  && instr_word[29:25] == 5'b11000 ;
 endfunction

function automatic AES32ESMI();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b10011 ;
 endfunction

function automatic SHA256SUM1();
  return instr_word[6:0] == 7'b0010011  && instr_word[14:12] == 3'b001  && instr_word[24:20] == 5'b00001  && instr_word[29:25] == 5'b01000  && instr_word[31:30] == 2'b00 ;
 endfunction

function automatic SHA512SIG1L();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b01011  && instr_word[31:30] == 2'b01 ;
 endfunction

function automatic SHA512SUM1();
  return instr_word[6:0] == 7'b0010011  && instr_word[14:12] == 3'b001  && instr_word[24:20] == 5'b00101  && instr_word[29:25] == 5'b01000  && instr_word[31:30] == 2'b00 ;
 endfunction

function automatic SM4ED();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b11000 ;
 endfunction

function automatic AES64IM();
  return instr_word[6:0] == 7'b0010011  && instr_word[14:12] == 3'b001  && instr_word[24:20] == 5'b00000  && instr_word[29:25] == 5'b11000  && instr_word[31:30] == 2'b00 ;
 endfunction

function automatic SM4KS();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b11010 ;
 endfunction

function automatic AES64ESM();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b11011  && instr_word[31:30] == 2'b00 ;
 endfunction

function automatic SHA512SUM0();
  return instr_word[6:0] == 7'b0010011  && instr_word[14:12] == 3'b001  && instr_word[24:20] == 5'b00100  && instr_word[29:25] == 5'b01000  && instr_word[31:30] == 2'b00 ;
 endfunction

function automatic SHA512SUM0R();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b01000  && instr_word[31:30] == 2'b01 ;
 endfunction

function automatic SHA512SUM1R();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b01001  && instr_word[31:30] == 2'b01 ;
 endfunction

function automatic SHA512SIG0();
  return instr_word[6:0] == 7'b0010011  && instr_word[14:12] == 3'b001  && instr_word[24:20] == 5'b00110  && instr_word[29:25] == 5'b01000  && instr_word[31:30] == 2'b00 ;
 endfunction

function automatic AES32ESI();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b10001 ;
 endfunction

function automatic AES32DSMI();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b10111 ;
 endfunction

function automatic AES32DSI();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b10101 ;
 endfunction

function automatic SHA512SIG1H();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b01111  && instr_word[31:30] == 2'b01 ;
 endfunction

function automatic SHA512SIG0L();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b01010  && instr_word[31:30] == 2'b01 ;
 endfunction

function automatic AES64DS();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b11101  && instr_word[31:30] == 2'b00 ;
 endfunction

function automatic SHA256SIG0();
  return instr_word[6:0] == 7'b0010011  && instr_word[14:12] == 3'b001  && instr_word[24:20] == 5'b00010  && instr_word[29:25] == 5'b01000  && instr_word[31:30] == 2'b00 ;
 endfunction

function automatic SM3P0();
  return instr_word[6:0] == 7'b0010011  && instr_word[14:12] == 3'b001  && instr_word[24:20] == 5'b01000  && instr_word[29:25] == 5'b01000  && instr_word[31:30] == 2'b00 ;
 endfunction

function automatic SHA512SIG0H();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b01110  && instr_word[31:30] == 2'b01 ;
 endfunction

function automatic AES64KS2();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b11111  && instr_word[31:30] == 2'b01 ;
 endfunction

function automatic AES64ES();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b11001  && instr_word[31:30] == 2'b00 ;
 endfunction

function automatic SM3P1();
  return instr_word[6:0] == 7'b0010011  && instr_word[14:12] == 3'b001  && instr_word[24:20] == 5'b01001  && instr_word[29:25] == 5'b01000  && instr_word[31:30] == 2'b00 ;
 endfunction

function automatic AES64DSM();
  return instr_word[6:0] == 7'b0110011  && instr_word[14:12] == 3'b000  && instr_word[29:25] == 5'b11111  && instr_word[31:30] == 2'b00 ;
 endfunction

function automatic SHA256SUM0();
  return instr_word[6:0] == 7'b0010011  && instr_word[14:12] == 3'b001  && instr_word[24:20] == 5'b00000  && instr_word[29:25] == 5'b01000  && instr_word[31:30] == 2'b00 ;
 endfunction

