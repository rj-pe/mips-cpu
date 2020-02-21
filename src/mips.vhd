------------------------------------------------------------------------------------------------------------
--
-- EEC 483 Project
-- Implementation of MIPS
-- File name   : mips.vhd
-- Description : Instantiates program and data memory, a 32-bit ALU. Feeds the
--               ALU with two 32-bit operands and ALUctl.
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
  
entity mips is
    port (
        clock_mips           : in  std_logic;
        reset_mips           : in  std_logic;
        memory_in_mips       : out std_logic_vector (31 downto 0);  -- data to write into memory (sw)
        memory_out_mips      : in  std_logic_vector (31 downto 0);  -- data being read from memory (lw)
        memory_address_mips  : out std_logic_vector (31 downto 0);  -- memory address to read/write
        pc_mips              : out std_logic_vector (31 downto 0);  -- instruction address to fetch
        instruction_mips     : in std_logic_vector (31 downto 0);   -- instruction data to execute in next cycle
        overflow_mips        : out std_logic;  -- flag for overflow
        memory_write_mips    : out std_logic); -- control signal fOR data memORy read/write
end entity;

architecture rtl of mips is

------ Signal Declaration ------
signal XY      : std_logic_vector (31 downto 0); -- instruction address to fetch
signal A, B    : std_logic_vector (31 downto 0); -- ALU input values
signal ALUOut  : std_logic_vector (31 downto 0); -- ALU output value
signal ALUctl  : std_logic_vector (3 downto 0);  -- ALU output value
signal overflow : std_logic;  -- overflow flag
signal Zero    : std_logic;   -- 1 bit signals fOR ALU arithmetic operations

------ Project 2 Signals ------
signal RegDst, RegWrite, MemWrite, ALUSrc, MemtoReg : std_logic;
signal ALUOp : std_logic_vector(1 downto 0);
signal opcode: std_logic_vector(5 downto 0);
signal func: std_logic_vector(5 downto 0);
signal RegDst_Output: std_logic_vector(4 downto 0);
signal ALUSrc_Output, MemtoReg_Output: std_logic_vector(31 downto 0);
signal answer: std_logic_vector(31 downto 0);
-- These values change based on what's in the register.
signal Data_A, Data_B: std_logic_vector(31 downto 0);


-- Project 2 Register File (see Appendix A) --
type register_type is array(0 to 31) of std_logic_vector(31 downto 0);
signal Register : register_type := 
    (
        0      => x"00000000",
        4      => x"00000004",
        5      => x"00000084",
        6      => x"0000008C",
        7      => x"00000001",
        others => x"00000000",
    );

------ Component Declarations ------
component ALU_32
    port(
        A_alu32        : in std_logic_vector(31 downto 0);  -- A input
        B_alu32        : in std_logic_vector(31 downto 0);  -- B input
        ALUctl_alu32   : in std_logic_vector(3 downto 0);   -- control
        ALUout_alu32   : out std_logic_vector(31 downto 0); -- result
        overflow_alu32 : out std_logic; -- overflow result
        Zero_alu32     : out std_logic); -- check if ALUout is zero
end component;

begin

------ Component Instantiations ------
ALU_32_1 : ALU_32
    port map (
        A_alu32        => A,
        B_alu32        => B,
        ALUctl_alu32   => ALUctl,
        ALUout_alu32   => ALUout,
        overflow_alu32 => overflow,
        Zero_alu32     => Zero);

--- Project 2 Register R/W (see Appendix A & B) --
--- synchronous write to registers
process(CLOCK_mips)
begin
    if(RISING_EDGE(clock_mips)) then
        if(RegWrite = '1') then
            Registers(to_integer(unsigned(RegDst_Output))) <= MemtoReg_Output;
        end if;
    end if;
end process;

-- Asynchronous read from registers --
-- Read register 1.
Data_A <= Registers((to_integer(unsigned(instruction_mips(25 downto 21)))));
-- Read register 2.
Data_B <= Registers((to_integer(unsigned(instruction_mips(20 downto 16)))));

------ Project 2 Signal Mapping (Step 1) ------      
opcode <= instruction_mips(31 downto 26);
func   <= instruction_mips(5 downto 0);

-- Boolean expressions for control circuit signals --
RegDst   <= not opcode(5);
ALUSrc   <= opcode(5);
MemtoReg <= opcode(5);
RegWrite <= not ( opcode(4) or opcode(3) or opcode(2) ) and 
            not ( opcode(2) xor opcode(1) xor opcode(0) );
MemWrite <= opcode(3) and opcode(0);
ALUOp(1) <= not ( opcode(2) and opcode(1) );
ALUOp(0) <= opcode(2) and not opcode(1);

------ Project 2 Signal Mapping (Step 2) ------

ALUctl(3) <=   ALUOp(1) and func(2) and func(1) and func(0);
ALUctl(2) <=   ALUOp(1) and func(1);
ALUctl(1) <=   not ALUOp(1) or not func(2);
ALUctl(0) <=   ALUOp(1) and
             ( func(3) and func(1) or func(2) and func(0) ) and
             ( func(3) xor func(2) xor func(1) xor func(0) );

------ Project 2 Signal Mapping (Step 3) ------
--process(...)
--begin
--...
--end process;

------ Project 2 Signal Mapping (Step 4) ------
--...
--memory_address_mips <=
--memory_in_mips      <= 
--memory_write_mips   <=

------ Housekeeping (PC, A, B) ---------------------  
-- Project 2 does not use fixed operands

A <= Data_A;
B <= ALUSrc_Output;

-- ??? Don't see the following line in the updated proj2 code.
overflow_mips <= overflow; 

pc_mips <= XY;

process (CLOCK_mips, reset_mips) 
begin
    if(reset_mips = '1') then
       XY <= x"00000000";
    elsif(RISING_EDGE(CLOCK_mips)) then
       XY <= XY + 4;
    else
        XY <= XY;
    end if;
end process;

end architecture;
