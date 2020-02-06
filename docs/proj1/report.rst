
Project 1 Report
````````````````
----------------------
Part 1: Overall Design
----------------------

   Describe the overall design (mips, inst_memory, & data_memory) with input
   & output ports interconnected with a diagram. (Refer to ``microcomputer.vhd``)

Response:
~~~~~~~~~
``microcomputer.vhd`` implements three smaller components within itself. The first
component is the data_memory component, this component is responsible for
storing all the data in different registers. The second component is
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
   
   <img src="../images/block_diagram.PNG" alt="" style="width: 100%;"/><figcaption>block diagram for microcomputer.vhd</figcaption>

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
press the button the clock progesses. The second option is to slow down
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
 This is some filler text.

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


-----

--------------
Part 6: Resuls
--------------

  Explain if your program produces correct ALU output, include a summary of
  what occurs when ``A`` and ``B`` are swapped.

Response:
~~~~~~~~~


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