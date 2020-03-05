Project 2 Report
````````````````

------------
Question 1:
------------

*****************************************************************

Describe Boolean expressions for each of the 7 control signals 
in Step 1. (1 point)

Include the section of VHDL code (mips.vhd) for the 7 control
signals. (1 point)

*****************************************************************

Response:
~~~~~~~~~

The code which implements the seven control signals in step one is below.

.. code:: vhdl

  ------ Project 2 Signal Mapping (Step 1) ------      
  opcode <= instruction_mips(31 downto 26);
  func   <= instruction_mips(5 downto 0);

  -- Boolean expressions for control circuit signals --
  RegDst   <= not opcode(5);
  ALUSrc   <= opcode(5);
  MemtoReg <= opcode(5);
  RegWrite <= (((not opcode(2)) and (not opcode(1))) or (opcode(5) and (not opcode(3))));
  MemWrite <= opcode(3);
  ALUOp(1) <= ((not opcode(5)) and (not opcode(2)));
  ALUOp(0) <= opcode(2);

The table describes each control signal.

.. csv-table::
  :header: "signal name", "boolean expression", "description"

  "``RegDst``", "``not opcode(5)``","Selects the destination register number from the instruction. The inverted 6th bit of the instruction's opcode"
  "``ALUSrc``", "``opcode(5)``","Selects the second operand of the ALU (either sign-extended immediate or register). The 6th bit of the instruction's opcode."
  "``MemtoReg``", "``opcode(5)``","Selects which result is routed to the register write data port (memory output or ALU output). The 6th bit of the instruction's opcode."
  "``RegWrite``", "``(((not opcode(2)) and (not opcode(1))) or (opcode(5) and (not opcode(3))))``","Determines whether the instruction requires writing to a register."
  "``MemWrite``", "``opcode(3)``","Determines whether the instruction requires writing to memory."
  "``ALUOp(1)``", "``((not opcode(5)) and (not opcode(2)))``","Used to determine which operation the ALU should perform."
  "``ALUOp(0)``", "``opcode(2)``","Because we are implementing a limited subset of MIPS instructions this signal is not used in determining the ALU operation."

-----

------------
Question 2:
------------

*****************************************************************

Describe Boolean expressions for each of the 4 ALU control signal in
Step 2. (1 point)

Include the section of VHDL code (mips.vhd) for the 4 ALU control
signals. (1 point)

*****************************************************************

Response:
~~~~~~~~~

The code which implements the ALU control signals in step two is below.

.. code:: vhdl

  ------ Project 2 Signal Mapping (Step 2) ------

  ALUctl(3) <=   ALUOp(1) and func(2) and func(1) and func(0);
  ALUctl(2) <=   ALUOp(1) and func(1);
  ALUctl(1) <=   not ALUOp(1) or not func(2);
  ALUctl(0) <= ((ALUOp(1) and func(3)) or (ALUOp(1) and (not func(1)) and func(0)));

The table describes each ALU control signal.

.. csv-table::
  :header: "signal name", "boolean expression", "description"

  "``ALUctl(3)``","``ALUOp(1) and func(2) and func(1) and func(0)``","Determines whether the first ALU operand should be inverted."
  "``ALUctl(2)``","``ALUOp(1) and func(1)``","Determines whether the second ALU operand should be inverted"
  "``ALUctl(1)``","``not ALUOp(1) or not func(2)``","1 and 0 choose the ALU operation to perform."
  "``ALUctl(0)``","``((ALUOp(1) and func(3)) or (ALUOp(1) and (not func(1)) and func(0)))``","The ALU operations can be and, or, add, or set less than"


-----

------------
Question 3:
------------


*****************************************************************

Include the section of VHDL code (mips.vhd) that uses the three
multiplexor signals in Step 3. (1 point)

*****************************************************************

Response:
~~~~~~~~~

-----

------------
Question 4:
------------

*****************************************************************

Describe how you implement “sign_extend” in Step 4. (1 point)

*****************************************************************

Response:
~~~~~~~~~

The sign extended immediate is created by testing whether the immediate's (from 
the instruction) most significant bit is a one or a zero. If it is a one, then
the immediate is sign-extended to become a negative two's complement 32-bit
quantity by prepending 16 one's. If the MSB is a zero, then 16 zero's are prepended
to the immediate. The vhdl code for the sign extension unit is shown below.

.. code:: vhdl

  ------ Project 2 Sign Extend Unit (Step 4) ------
  with ( instruction_mips(15) and '1' ) 
  select sign_extend_output <=
    "1111111111111111" & instruction_mips(15 downto 0) when '1',
    "0000000000000000" & instruction_mips(15 downto 0) when others;
-----

------------
Question 5:
------------

*****************************************************************

Include the section of VHDL code (mips.vhd) for memory interfacing
in Step 4.

memory_in_mips, memory_address_mips, memory_write_mips, 
and memory_out_mips. (2 points)

*****************************************************************

Response:
~~~~~~~~~

-----

------------
Question 6:
------------

*****************************************************************

Explicitly mention if your design works, partially works, or is not
completed yet. (2 points)

*****************************************************************

Response:
~~~~~~~~~

Our design works. Once synthesized and programmed to the board the design 
produces the outputs as described in the project description.

-----


-----

Main_
~~~~~~~
.. _Main: main.html

Source_
~~~~~~~
.. _Source: source.html

Demonstration_
~~~~~~~~~~~~~~
.. _Demonstration: demonstration.html
