------------------------------------------------------------------------------------------------------------
--
-- EEC 483 Project
-- Implementation of MIPS
--
-- File name   : microcomputer.vhd
--              
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.all;

  
entity microcomputer is
    port (clock_micro    : in   std_logic;
          reset_micro     : in   std_logic;
	        key_micro       : in std_logic_vector (1 downto 0);
          sw_micro        : in std_logic_vector (9 downto 0);
 			    -- SW(0)=0: display pc on 7-segment display
	        -- SW(0)=1: display data memory in (ALU Output) on 7-segment display
          ledr_micro      : out std_logic_vector (9 downto 0);
          hex0_micro      : out std_logic_vector (6 downto 0);
          hex1_micro      : out std_logic_vector (6 downto 0);
          hex2_micro      : out std_logic_vector (6 downto 0);
          hex3_micro      : out std_logic_vector (6 downto 0);
          hex4_micro      : out std_logic_vector (6 downto 0);
  			 hex5_micro		  : out std_logic_vector (6 downto 0));
  			  -- ledr(9:2) & hex5~0 shows 32-bit data
  			  -- where ledr(9:2) shows the most significant 2 bytes
end entity;

architecture rtl of microcomputer is

------ Component Declarations ------
    component mips
    port (clock_mips    			 : in  std_logic;
          reset_mips     			 : in  std_logic;
          memory_in_mips       : out std_logic_vector (31 downto 0);	-- data to write into memory (sw)
          memory_out_mips      : in  std_logic_vector (31 downto 0);  -- data being read from memory (lw)
          memory_address_mips  : out std_logic_vector (31 downto 0);	-- memory address to read/write
          pc_mips              : out std_logic_vector (31 downto 0);	-- instruction address to fetch
          instruction_mips     : in std_logic_vector (31 downto 0);   -- instruction data to execute in the next cycle
          overflow_mips			   : out std_logic;   -- overflow flag
			    invalid_mips			   : out std_logic;   -- invalid opcode flag
			    memory_write_mips    : out std_logic);                      -- control signal for data memory read/write
    end component;

    component inst_memory_128B
    port (clock_im        : in  std_logic;
          reset_im        : in  std_logic;
          pc_im           : in  std_logic_vector (31 downto 0);	  -- instruction address to fetch
          instruction_im  : out std_logic_vector (31 downto 0));    -- instruction data to execute in the next cycle       
    end component;
	 
    component data_memory_64B
    port (clock_dm          : in  std_logic;
          reset_dm          : in  std_logic;
          memory_address_dm : in  std_logic_vector (31 downto 0);	  -- memory address to read/write
          memory_write_dm   : in  std_logic;                        -- control signal for data memory read/write
          memory_in_dm      : in  std_logic_vector (31 downto 0);	  -- data to write into memory (sw)
          memory_out_dm     : out std_logic_vector (31 downto 0));  -- data being read from memory (lw)
    end component;


 -- Signal Declaration
 
    signal memory_in         : STD_LOGIC_VECTOR (31 downto 0);      -- data to write into memory (sw)
    signal memory_out        : STD_LOGIC_VECTOR (31 downto 0);      -- data being read from memory (lw)
    signal memory_address    : STD_LOGIC_VECTOR (31 downto 0);      -- memory address to read/write
    signal memory_write      : STD_LOGIC;                           -- control signal for data memory read/write
    signal instruction       : STD_LOGIC_VECTOR (31 downto 0);      -- instruction data to execute in the next cycle 
    signal pc                : STD_LOGIC_VECTOR (31 downto 0);      -- instruction address to fetch
	  signal overflow		  	   : STD_LOGIC;
	  signal invalid		  	   : STD_LOGIC;
	 
    signal plusone           : STD_LOGIC_VECTOR (3 downto 0);	-- this is for 7-segment display
    signal plusone1          : STD_LOGIC_VECTOR (3 downto 0);	-- this is for 7-segment display
    signal plusone2          : STD_LOGIC_VECTOR (3 downto 0);	-- this is for 7-segment display
    signal plusone3          : STD_LOGIC_VECTOR (3 downto 0);	-- this is for 7-segment display
	  signal plusone4          : STD_LOGIC_VECTOR (3 downto 0);	-- this is for 7-segment display
    signal plusone5          : STD_LOGIC_VECTOR (3 downto 0);	-- this is for 7-segment display
    signal plusone6          : STD_LOGIC_VECTOR (3 downto 0);	-- this is for 7-segment display
    signal plusone7          : STD_LOGIC_VECTOR (3 downto 0);	-- this is for 7-segment display
	 signal sw0      : STD_LOGIC; 
	 
begin

------ Component Instantiations ------
    CPU_1 : mips
    port map (clock_mips=>clock_micro, reset_mips=>reset_micro,
				  memory_in_mips         => memory_in,
				  memory_out_mips        => memory_out,
				  memory_address_mips    => memory_address,
				  pc_mips                => pc,
				  overflow_mips			     => overflow,
				  invalid_mips			 	   => invalid,
				  instruction_mips       => instruction,
				  memory_write_mips      => memory_write);    

    MEMORY_1 : inst_memory_128B
    port map (clock_im=>clock_micro, reset_im=>reset_micro,        
				  pc_im                  => pc,
				  instruction_im         => instruction);

    MEMORY_2 : data_memory_64B
    port map (clock_dm=>clock_micro, reset_dm=>reset_micro,
				  memory_address_dm     => memory_address,
				  memory_write_dm       => memory_write,
				  memory_in_dm          => memory_in,
				  memory_out_dm         => memory_out);

    sw0 <= sw_micro(0);

    process (sw0, pc, memory_in) 
    begin
       if (sw0='1') then                   -- SW(0)=1: display pc on ledr(9:2) & hex5~0
             plusone  <= pc(3 downto 0);
             plusone1 <= pc(7 downto 4);
             plusone2 <= pc(11 downto 8);
             plusone3 <= pc(15 downto 12);
				     plusone4 <= pc(19 downto 16);
				     plusone5 <= pc(23 downto 20);
				     plusone6 <= pc(27 downto 24);
				     plusone7 <= pc(31 downto 28);
       else                     -- SW(0)=0: display data memory input (ALU Output) on ledr(9:2) & hex5~0
             plusone  <= memory_in(3 downto 0);
             plusone1 <= memory_in(7 downto 4);
             plusone2 <= memory_in(11 downto 8);
             plusone3 <= memory_in(15 downto 12);
				     plusone4 <= memory_in(19 downto 16);
				     plusone5 <= memory_in(23 downto 20);
				     plusone6 <= memory_in(27 downto 24);
				     plusone7 <= memory_in(31 downto 28);
       end if;
    end process;
	 
    h0: hex port map(plusone, o => hex0_micro);      -- display on ledr(7:0) & hex5~0
    h1: hex port map(plusone1, o => hex1_micro);
    h2: hex port map(plusone2, o => hex2_micro);
    h3: hex port map(plusone3, o => hex3_micro); 
    h4: hex port map(plusone4, o => hex4_micro);    
    h5: hex port map(plusone5, o => hex5_micro);    
    ledr_micro(9) <= plusone7(3);   
    ledr_micro(8) <= plusone7(2);  
    ledr_micro(7) <= plusone7(1);  
    ledr_micro(6) <= plusone7(0);
    ledr_micro(5) <= plusone6(3);   
    ledr_micro(4) <= plusone6(2);  
    ledr_micro(3) <= plusone6(1);  
    ledr_micro(2) <= plusone6(0);
	 
    ledr_micro(1) <= overflow;  
    ledr_micro(0) <= invalid;	 
          
end architecture;
