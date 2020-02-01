------------------------------------------------------------------------------------------------------------
--
-- EEC 483 Project
-- Implementation of MIPS
--
-- File name   : inst_mem_128B.vhd
--
-- Note(s)     : Address      Description
--              ----------------------------------
--              x"00"       Instruction Memory (ROM)    
--               :            (128B) 
--               : 
--              x"7F"                          
--              ----------------------------------
--              x"80"       Data Memory (RAM)
--               :            (64B)
--              x"BF"           
--              ----------------------------------               
--              x"C0"            IO 
--               :            (64 ports)
--              x"FF"           
--              ----------------------------------
--
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity inst_memory_128B is
  -- we use generics to create mnemoics for our instruction set.  This allows us to program in "assembly code"
    port (clock_im    : in  std_logic;
          reset_im    : in  std_logic;
          pc_im  : in  std_logic_vector(31 downto 0);
          instruction_im : out std_logic_vector(31 downto 0));
end entity;

architecture rtl of inst_memory_128B is

  type rom_type is array (0 to 31) of std_logic_vector(31 downto 0);
  constant ROM : rom_type := (
			  0 => x"00430820", -- ADDR 0  -- [add $1 $2 $3  => R(op:0(add) rs:2(2) rt:3(3) rd:1(1) sh:0 func:32)] 
				1 => x"00e83022", -- ADDR 4  -- [sub $6 $7 $8  => R(op:0(sub) rs:7(7) rt:8(8) rd:6(6) sh:0 func:34)] 
				2 => x"018d5824", -- ADDR 8  -- [and $11 $12 $13  => R(op:0(and) rs:12(12) rt:13(13) rd:11(11) sh:0 func:36)] 
				3 => x"02328025", -- ADDR 12 (or 0xC)  -- [or $16 $17 $18  => R(op:0(or) rs:17(17) rt:18(18) rd:16(16) sh:0 func:37)] 
				4 => x"033ac02a", -- ADDR 16 (or 0x10) -- [slt $24 $25 $26  => R(op:0(slt) rs:25(25) rt:26(26) rd:24(24) sh:0 func:42)] 
				others => x"00000000"); 
                              
   begin
	
    -- Asyncronous Read of ROM
    instruction_im <= ROM(to_integer(unsigned(pc_im))/4);
	 
end architecture;
