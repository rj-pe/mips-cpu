------------------------------------------------------------------------------------------------------------
--
-- EEC 483 Project
-- Implementation of MIPS
-- File name   : mips.vhd
--
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
  
entity mips is
    pORt (clock_mips	       : in  std_logic;
          reset_mips           : in  std_logic;
          memORy_in_mips       : out std_logic_vectOR (31 downto 0);   -- data to write into memORy (sw)
          memORy_out_mips      : in  std_logic_vectOR (31 downto 0);   -- data being read from memORy (lw)
          memORy_address_mips  : out std_logic_vectOR (31 downto 0);   -- memORy address to read/write
          pc_mips              : out std_logic_vectOR (31 downto 0);   -- instruction address to fetch
          instruction_mips     : in std_logic_vectOR (31 downto 0);    -- instruction data to execute in the next cycle
          overflow_mips		   : out std_logic;                        -- flag fOR overflow
          invalid_mips		   : out std_logic;                        -- flag fOR invalid opcode
		  memORy_write_mips    : out std_logic);                       -- control signal fOR data memORy read/write
end entity;

architecture rtl of mips is

------ Signal Declaration ------
   signal XY		  : std_logic_vectOR (31 downto 0);                -- instruction address to fetch
   signal A, B    : std_logic_vectOR (31 downto 0);                    -- ALU input values
   signal ALUOut	: std_logic_vectOR (31 downto 0);                  -- ALU output value
   signal ALUctl	: std_logic_vectOR (3 downto 0);                   -- ALU output value
   signal overflow : std_logic;                                      -- overflow flag
   signal invalid : std_logic;                                       -- invalid flag
   signal Zero    : std_logic;                                       -- 1 bit signals fOR ALU arithmetic operations

------ Project 1 Signals (your code) ------
--	signal ?????

------ Component Declarations ------
component ALU_32
	pORt(
		A_alu32      : in std_logic_vectOR(31 downto 0);  -- A input
		B_alu32      : in std_logic_vectOR(31 downto 0);  -- B input
		ALUctl_alu32 : in std_logic_vectOR(3 downto 0);  	-- control
		ALUout_alu32 : out std_logic_vectOR(31 downto 0); -- result
		overflow_alu32: out std_logic; -- overflow result
		Zero_alu32   : out std_logic);  								  -- check if ALUout is zero
end component ;

begin

------ Component Instantiations ------
   ALU_32_1 : ALU_32
      pORt map ( A_alu32       => A,
                 B_alu32       => B,
                 ALUctl_alu32  => ALUctl,
				         ALUout_alu32  =>ALUout,
					       overflow_alu32=>overflow,
					       Zero_alu32    =>Zero);

------ Project 1 Signal Mapping (your code) ------		  
	ALUctl <= "0010";

------ Housekeeping (PC, A, B) ---------------------	
    A <= x"000A0FF0";
	  B <= x"00001010";
	  
    memory_in_mips <= ALUOut;
    
    invalid_mips <= invalid;
    overflow_mips <= overflow;
	  
	  pc_mips <= XY;

    process (CLOCK_mips, reset_mips) 
    begin
          if(reset_mips = '1') then
             XY <= x"00000000";
          elsif(RISING_EDGE(CLOCK_mips)) then
					   XY <= XY + 4;
          end if;
     end process;


end architecture;



