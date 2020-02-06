--------------------------------------------------------------------------------
--
-- EEC 483 Project
-- Implementation of MIPS
-- File name   : ALU.vhd
--
--------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;

entity ALU is
    port(
      ALUctl_alu   : in std_logic_vector(3 downto 0);   -- control
      A_alu        : in std_logic;                      -- A input
      B_alu        : in std_logic;                      -- B input
      carryin_alu  : in std_logic;                      -- arithmetic carry in
      less_alu     : in std_logic;                      -- less input
      ALUout_alu   : out std_logic;                     -- result
      carryout_alu : out std_logic);                    -- arithmetic carry out
end ALU ;

architecture behavioural of ALU is
    signal Operation: std_logic_vector(1 downto 0);
    signal Ainvert, Binvert, a_in, b_in, result, set: std_logic;
begin
    -- code to produce two output signals ALUout_alu & carryout_alu
    -- based on four input signals:
    -- ALUclt_alu, A_alu, B_alu, carryin_alu, and less_alu
   --assigning control signal to respective signals
   Ainvert    <= ALUctl_alu(3);
   Binvert    <= ALUctl_alu(2);
   Operation  <= ALUctl_alu(1 downto 0);
   -- A inverting multiplexer
    with Ainvert select 
      a_in    <= 
                A_alu when '0',
                not A_alu when others;
   -- B inverting multiplexer             
   with Binvert select 
      b_in    <= 
                B_alu when '0',
                not B_alu when others;
   -- final multiplexer
   with Operation select 
      result  <= 
                a_in and b_in when "00",                 -- And operation
                a_in or b_in when "01",                  -- Or operation
                a_in xor b_in xor carryin_alu when "10", -- Add/Sub opertaion
                less_alu when others;                    -- slt operation
        
   Aluout_alu   <= result;
   carryout_alu <= (a_in and b_in) or 
                   (b_in and carryin_alu) or 
                   (a_in and carryin_alu);

end behavioural;
