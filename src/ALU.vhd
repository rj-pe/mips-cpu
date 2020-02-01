------------------------------------------------------------------------------------------------------------
--
-- EEC 483 Project
-- Implementation of MIPS
-- File name   : ALU.vhd
--
------------------------------------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;

entity ALU is
    port(
	 		ALUctl_alu : in std_logic_vector(3 downto 0);  	-- control
			A_alu : in std_logic;  	 								-- A input
			B_alu : in std_logic;  	 								-- B input
			carryin_alu,less_alu : in std_logic;		-- arithmetic carry in 
			ALUout_alu : out std_logic;  						-- result
			carryout_alu : out std_logic);					-- arithmetic carry out
end ALU ;

architecture behavioural of ALU is
    signal Operation: std_logic_vector(1 downto 0);
    signal Ainvert, Binvert, a_in, b_in, result, set: std_logic;
begin

    -- code to produce two output signals ALUout_alu & carryout_alu
    -- based on four inpout signals ALUclt_alu, A_alu, B_alu, carryin_alu, and less_alu
    ALUout_alu <= A_alu and B_alu;            -- just a placeholder

    -- 
    -- assignment example in VHDL: "Operation <= ALUctl_alu(1 downto 0);"
    -- simple if-else example in VHDL: "with Ainvert select a_in <= A_alu when '0',  not A_alu when others;"
    
end behavioural;


