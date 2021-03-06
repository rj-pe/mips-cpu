
Project 1 Report
````````````````
----------------------
Part 1: Overall Design
----------------------

   Describe the overall design (mips, inst_memory, & data_memory) with input & 
   output ports interconnected with a diagram. (Refer to ``microcomputer.vhd``)

Response:
~~~~~~~~~
``microcomputer.vhd`` implements three smaller components within itself. The
first component is the data_memory component, this component is responsible
for storing all the data in different registers. The second component is
inst_memory, this component is responsible for storing the program that CPU
is going to execute. The final component is the CPU which currently the CPU
only has a 32-bit ALU inside but more will be added as the course progresses.
The majority of the work for project 1 was done inside of the CPU we were
responsible for creating a 1-bit ALU that implements the following
operations: and, or, add, sub, slt. Once the 1-bit ALU was created the file
ALU_32.vhd was responsible for concatenating 32 1-bit ALUs to give us a
32-bit ALU. Below is a diagram that shows how all the components are
interconnected.   

.. raw:: html
   
   <img src="../images/block_diagram.PNG" alt="" style="width: 100%;"/>
   <figcaption>block diagram for microcomputer.vhd</figcaption>

-----

--------------------
Part 2: Clock Signal
--------------------

  Explain how the clock signal is supplied in the design and how the clock
  proceeds. (Refer to ``test_mips.vhd``)

Response:
~~~~~~~~~
The 50MHz clock is supplied to the test_mips.vhd file as an input.
There are three different clock options that have been provided for us.
The first option is to use key(0) as the clock signal meaning when you
press the button the clock progresses. The second option is to slow down
the 50MHz clock signal down to a 10MHz clock signal so the CPU would
run a little slower. The final option is to use the standard 50MHz clock
that is provided with the DE-10 lite board. For project 1 we are utilizing
the Key(0) as the clock so every time the button is pushed the program counter
is incremented by one address or 4 bytes. We are also able to reset the
program counter by pressing key(1) and that will reset the program counter
back to 0 so we are able to step through the program again by pressing key(0).
The VHDL code checks to make sure both key(0) is pressed and the rising
edge of the clock has occurred if both of those are true it increments the
program counter by 4 bytes.

-----

------------------
Part 3: ALU Design
------------------

  Explain your ALU design. (Refer to ``alu.vhd``)

Response:
~~~~~~~~~

The arithmetic logic unit (ALU) performs and, or, add (``add``), subtract 
(``sub``), and set less than (``slt``) operations on 32-bit words. The ALU
can parse MIPS formatted instructions.

The ALU has three inputs: two 32-bit operands, and a 4-bit control signal. All
four bits of the control signal are fed to each of the 32 1-bit ALU's. A single
bit of each operand is fed to each of the 32 1-bit ALU's. 

The zeroth 1-bit ALU requires two unique signal logic statements.

The ALU has three outputs: one 32-bit result, a one-bit overflow indicator, and
a one-bit zero indicator. The overflow bit is set when an arithmetic operation
returns a result which cannot be expressed with 32-bits. The zero bit is set
when the result of an operation is ``0x00000000``. The 32-bit result is
collected bit-by-bit from each of the 32 1-bit ALU's.

The 32-bit ALU is constructed by wiring 32 1-bit ALU's in parallel (inputs).
The carry-in bit is taken from the carry-out of the previous 1-bit ALU.
The and / or operations are implemented using the corresponding logic gates. 
An adder is used to implement the other three operations. In order to select
which output to send as the result, the 1-bit ALU uses a four-to-one multiplexer. 

The sum of the 1-bit adder is implemented using a three input exclusive-or
gate. The inputs are the two operands and the carry-in bit. The carry-out bit
is set when at least two of the three input bits (two operands & carry-in)
are one.

The adder can also subtract using two's complement. We obtain the two's
complement representation of the negative of the second operand by negating 
all the bits and setting carry-in bit of the zeroth 1-bit ALU. In order to
tell the 1-bit ALU's that the second operand should be negated we include a
``b_invert`` signal as a select line to a two-to-one multiplexer connected to
the second input of the adder.


-----

--------------------------
Part 4: SLT Implementation
--------------------------
  Explain your implementation of ``slt`` instruction.

Response:
~~~~~~~~~
The ``slt`` instruction is a simple instruction to check if the A input to the ALU
is smaller than the B input. To check if A is less than B we must take the two's 
complement  of B then do a subtraction instruction. Once that operation has been 
completed we can check the most significant bit or in this case the sign bit. 
If the sign bit is '1' then we know that the result of the subtraction operation
was a negative number which tells us that A is less than B. Our current implementation
of slt is to perform the subtraction operation on the 31\ :sup:`st` bits of the 
A input, B input, and the Carry in. If this operation results in a '1' then 
we know that A is less than B, but if this operation results in a '0' then we 
know that A is greater than B. 

There is another implementation that would involve adding an additional output
to every 1-bit ALU. If we added an additional output this would allow us to grab 
the most significant bit directly from the 31st 1-bit ALU rather than completing a 
second operation in ``ALU_32.vhd``. We decided against this route because that would
involve heavily modifying ``ALU_32.vhd`` and we were unaware if we were allowed make 
these changes. 

------

---------------------------
Part 5: ALU Control Circuit
---------------------------

  Explain your ALU control circuit design along with the Boolean expression of
  each of the four ``ALUctl`` signals, as well as the corresponding section of
  VHDL code (Refer to ``mips.vhd``)

Response:
~~~~~~~~~

Control in ``mips.vhd``
++++++++++++++++++++++++

The 6-bit opcode is extracted from the lower bits of MIPS instruction. To
construct the ``ALUctl`` signal, our implementation employs a six to four 
look-up table (LUT).

The LUT generates a 4-bit control signal (``c3 c2 c1 c0``) based on the MIPS
opcode. Where ``c3`` (or ``a_invert``) controls whether or not to invert the
first operand. Note that we are not currently using this signal. Similarly, 
``c2`` (or ``b_invert``) controls whether to invert the second operand. This
signal is asserted for both the ``sub`` and ``slt`` instructions. In order to
perform subtraction using an adder the second operand is inverted, and the
carry-in bit of the zeroth 1-bit ALU is asserted. ``c1`` & ``c0`` are used as
the selection lines for the final four-to-one multiplexer in the 1-bit
ALU. See table below for signal assignments.


Control in ``ALU_32.vhd``
++++++++++++++++++++++++++

Controlling the carry-in bit: When the operation calls for subtraction of the
two operands the carry-in bit of the zeroth 1-bit ALU is set.

Controlling the ``less_alu`` signal: The zeroth 1-bit ALU's ``less_alu`` input
is a three gate xor. The three inputs to the gate are: the sign bits of both
operands and the thirty-first 1-bit ALU's carry-in.

Control in ``ALU.vhd``
+++++++++++++++++++++++++
The four input lines for this multiplexer are: and, or, adder, & less.

.. csv-table:: 4-1 Multiplexer
  :header: "``c1``","``c0``", "ALU function description"

  "0","0","and gate output"
  "0","1","or gate output"
  "1","0","adder output"
  "1","1","less signal"


-----

---------------
Part 6: Results
---------------

  Explain if your program produces correct ALU output, include a summary of
  what occurs when ``A`` and ``B`` are swapped.

Response:
~~~~~~~~~

When loaded with our program the board's hex display can show either the address
of the instruction being executed by the ALU, or the ALU result in hexadecimal.
The hex display can show 6 digits, where each digit represents 4-bits. In our
implementation the lower 24 bits are displayed on the hex display and the
remaining 8 bits are represented on the row of LEDs.

The two hard-coded operands are ``A=0x000A 0FF0`` and ``B=0x0000 1010``. The 
order of instructions fed to the ALU are  ``add``, ``sub``, ``and``, ``or``,
and ``slt``. The following table summarizes the results obtained with our
implementation.



.. csv-table:: Order of operands A & B as given
  :header: "Instr.", "|","Result displayed","|", "Addr. displayed"

  "A + B", "|", "0A2 000","|","000 000"
  "A - B", "|", "09F FE0","|","000 004"
  "A & B", "|", "000 010","|","000 008"
  "A | B", "|", "0A1 FF0","|","000 00C"
  "A <? B","|", "000 000","|","000 010"


When the order of the operands ``A`` and ``B`` is reversed our implementation
displays the following hex digits on the display. Note that the ``slt`` (last
row) returns 1 in this case because ``B`` is a smaller number than ``A``.

.. csv-table:: Order of operands B & A reversed
  :header: "Instr.", "|","Hex displayed", "|","Addr. displayed"

  "B + A", "|", "0A2 000","|","000 000"
  "B - A", "|", "F60 020","|","000 004"
  "B & A", "|", "000 010","|","000 008"
  "B | A", "|", "0A1 FF0","|","000 00C"
  "B <? A","|", "000 0001","|","000 010"

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
