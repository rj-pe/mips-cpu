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
    constant ROM : rom_type := 
        (0 => x"00000020", -- ADDR 0 -- add $0, $0, $0 (dummy)
				
        -- two operands
        1 => x"8ca20000",	-- ADDR 4 --	[lw	$2 	0($5)]		
        2 => x"8ca30004", -- ADDR 8 --	[lw	$3 	4($5)]			

        -- set of ALU operations  
        3 => x"00435020",	-- ADDR c --	[add	$10 	$2 	$3]
        4 => x"00435822",	-- ADDR 10 --	[sub	$11 	$2 	$3]
        5 => x"00626022",	-- ADDR 14 --	[sub	$12 	$3 	$2]
        6 => x"0062682a",	-- ADDR 18 --	[slt	$13 	$3 	$2]
        7 => x"0043702a",	-- ADDR 1c --	[slt	$14 	$2 	$3]
        
        -- save results to data memory [88-a0]        
        8 => x"acca0000",	-- ADDR 20 --	[sw	$10 	0($6)]			
        9 => x"accb0004",	-- ADDR 24 --	[sw	$11 	4($6)]			
        10 => x"accc0008",	-- ADDR 28 --	[sw	$12 	8($6)]			
        11 => x"accd000c",	-- ADDR 2c --	[sw	$13 	12($6)]			
        12 => x"acce0010",	-- ADDR 30 --	[sw	$14 	16($6)]			

        -- confirm the operations        
        13 => x"8cc10000",	-- ADDR 34 --	[lw	$1 	0($6)]			
        14 => x"8cc10004",	-- ADDR 38 --	[lw	$1 	4($6)]			
        15 => x"8cc10008",	-- ADDR 3c --	[lw	$1 	8($6)]
        16 => x"8cc1000c",	-- ADDR 40 --	[lw	$1 	12($6)]
        17 => x"8cc10010",	-- ADDR 44 --	[lw	$1 	16($6)]
        
        others => x"00000000"); 
		  
begin
	
    -- Asyncronous Read of ROM
	 process (pc_im)
	 begin
    instruction_im <= ROM(to_integer(unsigned(pc_im))/4);
	 end process;

end architecture;