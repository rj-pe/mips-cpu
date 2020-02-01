------------------------------------------------------------------------------------------------------------
--
-- EEC 483 Project
-- Implementation of MIPS
--
-- File name   : data_mem_64B.vhd
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

entity data_memory_64B is
    port (clock_dm		: in  std_logic;
          reset_dm		: in  std_logic;
          memory_in_dm	: in  std_logic_vector(31 downto 0);    
          memory_write_dm	: in  std_logic;
          memory_address_dm	: in  std_logic_vector(31 downto 0);
          memory_out_dm	: out std_logic_vector(31 downto 0));
end entity;


architecture rtl of data_memory_64B is

    type ram_type is array (32 to 47) of std_logic_vector(31 downto 0);
    signal RAM : ram_type := (
          32=> x"00000000",
          -- operand A and B
          33=>  x"80001010", --x"c0000ff0", -- ADDR 84
          34=>  x"c0000ff0", -- x"80001010",-- ADDR 88

          -- the following locations contains zero initially but will have the followings after the execution
          -- 35 or ADDR 8c: result of 000a 0ff0 "add" 0000 1010
          -- 36 or ADDR 90: result of 000a 0ff0 "sub" 0000 1010
          -- 37 or ADDR 94: result of 000a 0ff0 "and" 0000 1010
          -- 38 or ADDR 98: result of 000a 0ff0 "nor" 0000 1010
          -- 39 or ADDR 9c: result of 000a 0ff0 "slt" 0000 1010

          others => x"00000000");

begin

    -- Syncronous Write of RAM
    memory : process (clock_dm, reset_dm) 
    begin
          if (RISING_EDGE(CLOCK_dm)) then
                if (memory_write_dm = '1') then                      
                      RAM(to_integer(unsigned(memory_address_dm)/4)) <= memory_in_dm;    
							 -- this handles the synchronous write mode (write = 1)
                end if;
          end if;
    end process;

    -- Asyncronous Read of RAM
	 process (memory_address_dm) begin
         memory_out_dm <= RAM(to_integer(unsigned(memory_address_dm)/4));   
	      -- this handles the asynchronous read mode (doesn't check if read = 1) 
	 end process;
	 
end architecture;
