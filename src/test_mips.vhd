------------------------------------------------------------------------------------------------------------
--
-- EEC 483 Project
-- Implementation of MIPS
--
-- File name   : test_mips.vhd
--
------------------------------------------------------------------------------------------------------------
library IEEE;                    
use IEEE.STD_LOGIC_1164.ALL;    
use IEEE.STD_LOGIC_ARITH.ALL;    
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 

entity test_mips is
    port (
          CLOCK_50: in std_logic;                   -- 50MHz clock in the DE10_Lite board
          KEY: in std_logic_vector (1 downto 0);    -- keys or buttons (KEY(0)- KEY(1))
          SW: in std_logic_vector (9 downto 0);     -- switches (SW(9) 0 SW(0))
          LEDR: out std_logic_vector (9 downto 0);   -- led's 
          HEX0: out std_logic_vector (6 downto 0);   -- 7-segment display, digit 0
          HEX1: out std_logic_vector (6 downto 0);   -- 7-segment display, digit 1
          HEX2: out std_logic_vector (6 downto 0);   -- 7-segment display, digit 2
          HEX3: out std_logic_vector (6 downto 0);   -- 7-segment display, digit 3
          HEX4: out std_logic_vector (6 downto 0);   -- 7-segment display, digit 3
          HEX5: out std_logic_vector (6 downto 0));  -- 7-segment display, digit 5
end test_mips;

architecture test_mips_arch of test_mips is
        
------ Component Declarations ------

    component microcomputer
    port   ( clock_micro         : in   std_logic;
          reset_micro     : in  std_logic;
       key_micro       : in std_logic_vector (1 downto 0);
          sw_micro        : in std_logic_vector (9 downto 0);
          -- SW(0)=0: display pc on 7-segment display
          -- SW(0)=1: display memory in (ALU Output) on 7-segment display
          ledr_micro      : out std_logic_vector (9 downto 0);
          hex0_micro      : out std_logic_vector (6 downto 0);
          hex1_micro      : out std_logic_vector (6 downto 0);
          hex2_micro      : out std_logic_vector (6 downto 0);
          hex3_micro      : out std_logic_vector (6 downto 0);
          hex4_micro      : out std_logic_vector (6 downto 0);
          hex5_micro      : out std_logic_vector (6 downto 0)
          -- ledr(7:0) & hex5~0 shows 32-bit data
          -- where ledr(7:0) shows the most significant 2 bytes
          );
    end component;

------ Signal Declarations ------
 
    signal  reset         : std_logic;
    signal  clk     : std_logic;
    signal  sw0     : std_logic;
    signal clk_divide_count1  : std_logic_vector(31 downto 0) := (others => '0');   
    signal slow_clk1      : std_logic := '0'; 

   signal counter_out: std_logic_vector(31 downto 0) := (others => '0');  
    signal flipflops: std_logic_vector(1 downto 0) := (others => '0');
    signal counter_set: std_logic := '0'; 
    constant counter_size: Integer := 16;
   
begin

    reset <= NOT KEY(1);   -- KEY(1) is reset

--*****************************************CLOCK***********************
--*********************************************************************
--option 1: key(0) as the clock (need a deboncing circuit)
--option 2: slow clock (10Hz)
--option 3: 50MHz clock


--option 1: key(0) as the clock (need a deboncing circuit)
------ reset (clock) key debouncing
  clk <= NOT KEY(0);      -- KEY(0) as the clock (because 50MHz is too fast)
                            -- But it does not work okay; need debouncing circuit
counter_set <= flipflops(0) xor flipflops(1);
process(CLOCK_50)
begin
  if (CLOCK_50'event and CLOCK_50 = '1') then
    flipflops(0) <= NOT KEY(0);
    flipflops(1) <= flipflops(0);
    if (counter_set = '1') then
      counter_out <= (OTHERS => '0');
    elsif (counter_out(counter_size) = '0') then
      counter_out <= counter_out +1;
    else
      --clk <= flipflops(1);
    end if;
  end if;
end process;
------ reset (clock) key debouncing


--option 2: slow clock (10Hz)
--clk <= slow_clk1;       -- 10Hz clock in the DE10_Lite board
------ Slow clock begin ------
process(CLOCK_50)
begin
  if rising_edge(CLOCK_50) then
    if (slow_clk1 = '0') then
      if (clk_divide_count1 >= 5000000) then  --50MHz clock counting to 5 million, therefore slow clock will have period of 0.1s [(1/(50*10^6))*(5*10^6) = 0.1]
        clk_divide_count1 <= (others => '0'); --Reset clock divider
        slow_clk1 <= '1';       --Pulse slow_clk for 0.1 s
      else
        clk_divide_count1 <= clk_divide_count1 + 1 ;  --Increment clk_divide_count, NB this is not the output counter
        --slow_clk1 <= '0';
      end if;
    end if;

    if (slow_clk1 = '1') then
      if (clk_divide_count1 >= 5000000) then    --50MHz clock counting to 5 million, therefore slow clock will have period of 0.1s [(1/(50*10^6))*(5*10^6) = 0.1]
        clk_divide_count1 <= (others => '0'); --Reset clock divider
        slow_clk1 <= '0';       --Pulse slow_clk for 0.1s
      else
        clk_divide_count1 <= clk_divide_count1 + 1 ;  --Increment clk_divide_count, NB this is not the output counter
        --slow_clk1 <= '1';
      end if;
    end if;
  end if;
end process;
------ Slow clock end ------

--option 3: 50MHz clock
    --clk <= CLOCK_50;        -- 50MHz clock in the DE10_Lite board

--*********************************************************************
--*********************************************************************
   
    DUT1 : microcomputer
    port map  (clock_micro=>clk,
          reset_micro=>reset, key_micro=>KEY, sw_micro=>SW, ledr_micro=>LEDr,
          hex0_micro=>HEX0, hex1_micro=>HEX1, hex2_micro=>HEX2, hex3_micro=>HEX3, hex4_micro=>HEX4, hex5_micro=>HEX5); 

end architecture test_mips_arch;
