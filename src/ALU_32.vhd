------------------------------------------------------------------------------------------------------------
--
-- EEC 483 Project
-- Implementation of MIPS
-- File name   : ALU_32.vhd
--
------------------------------------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;

entity ALU_32 is
    port(
        A_alu32 : in std_logic_vector(31 downto 0);  		  -- A input
        B_alu32 : in std_logic_vector(31 downto 0);  		  -- B input
        ALUctl_alu32 : in std_logic_vector(3 downto 0);    -- control
        ALUout_alu32 : out std_logic_vector(31 downto 0);  -- result
        overflow_alu32: out std_logic;  						  -- check if ALU overflowed
        Zero_alu32 : out std_logic);  							  -- check if ALUout is zero
end ALU_32 ;

architecture behavioural of ALU_32 is
    signal slt, set: std_logic;
    signal Operation: std_logic_vector(1 downto 0);
    signal ALU_Output: std_logic_vector(31 downto 0);
    signal c_in: std_logic_vector(31 downto 0);
    signal c_out: std_logic_vector(31 downto 0);
    
------ Component Declarations ------
component ALU
    port(
		ALUctl_alu : in std_logic_vector(3 downto 0);  	-- control
		A_alu : in std_logic;  	 								-- A input
		B_alu : in std_logic;  	 								-- B input
		carryin_alu: in std_logic;							-- arithmetic carry in 
		less_alu: in std_logic;
		ALUout_alu : out std_logic;							-- result
		carryout_alu: out std_logic);						-- arithmetic carry out
end component ;

begin

    --carry inout to the first 1-bit ALU
    with ALUctl_alu32(2) select
          c_in(0) <= '0' when '0',  
					'1' when others; 

------ Component Instantiations ------
    ALU_0 : ALU
        port map ( A_alu       => A_alu32(0),
                   B_alu       => B_alu32(0),
                   ALUctl_alu  => ALUctl_alu32,
                   ALUout_alu  =>ALU_Output(0),
                   carryout_alu=>c_out(0),		--c_out0 will become the carry-in of the next 1-bit ALU
                   carryin_alu => c_in(0),
                   --less_alu    => '0'
						 less_alu    => set);       -- NEED TO REVISE

    alubits: for i in 1 to 31 generate
        ALU_i : ALU
        port map ( A_alu       	=> A_alu32(i),
                   B_alu       	=> B_alu32(i),
                   ALUctl_alu  	=> ALUctl_alu32,
                   ALUout_alu	 	=> ALU_Output(i),
                   carryout_alu	=> c_out(i),		--c_outi will become the carry-in of the next 1-bit ALU 
                   carryin_alu	=> c_in(i),
                   less_alu 		=> '0');      -- NEED TO REVISE 
        c_in(i) <= c_out(i-1);
   end generate alubits;


   Zero_alu32 <= '1' when ALU_Output = x"00000000" else '0';
   set <= A_alu32(31) xor (not B_alu32(31)) xor c_in(31) ;    --slt                       -- NEED TO REVISE
   ALUout_alu32 <= ALU_Output;
	 overflow_alu32 <= '0';                     -- NEED TO REVISE
	
end behavioural;



