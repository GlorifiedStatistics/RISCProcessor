# CSE141L
A RISC processor to quickly do hamming code and pattern matching operations.

## Running Test Bench
Any files in the form of "tb_[module]" are test benches for specific modules. The main test-bench is prog123_tb.sv. It is identical
to the file on canvas (as of ~4/20) except for two changes:
  1. Changed the name of the dut from 'DUT' to 'dut' using a global find-replace (also changed it in comments)
  2. Changed the instantiation name from 'prog' to 'DUT' as that is the name of the top-level module

With the modules files:
  - Verilog/alu.sv
  - Verilog/ctrl.sv
  - Verilog/dm.sv
  - Verilog/dut.sv
  - Verilog/ir.sv
  - Verilog/pc.sv
  - Verilog/rf.sv
And the testbech file:
  - Verilog/prog123_tb.sv

All compiled in ModelSim, the 'prog_123_tb' should be simulated. It should take ~1200ns to complete.

## Other Files
All files ending in '.jal' are the Justin's Assembly Language files whose workings are described below.
The python files are used to compile the JAL code into machine code. 'main.py' is just used to output
  the machine code however you wish, while the other files have descriptions in the fuctions.

## Assembler
Justin's Assembly Language (I know, very original) (JAL)
File extension: .jal

* There are 14 registers for use, none are necessarily 'general purpose':
```python
"""
- decimal value -- identifier -- full name
  0   ri      "Register for Index"
           - the current index of which result we are working on
  1   rmi     "Register for Memory Input"
          - the location of memory input
  2   rmo     "Register for Memory Output"
          - the location of memory output. Also the location the 'str' command uses as the memory address.
  3   rsi     "Register for Stopping Index"
          - the number of iterations to run any section of the program. IE: '15' for the first two programs because
              there are 15 examples to do for the hamming codes.
  4   rjls    "Register for Jumping to Loop Start"
          - the location in program memory for the start of the loop for the current program
  5   rlsb    "Register for Least Significant Bits (LSB)"
          - the LSB for the current loop of the program
  6   rmsb    "Register for Most Significant Bits (MSB)"
          - the MSB for the current loop of the program
  7   rpct    "Register for 'P' CounT"
          - holds the parity bits for the first two programs, and the counts of the number of occurrences in the third
  8   rstr    "Register for SToRe"
          - the register that the 'str' command pulls from to store into memory
  9   rptn    "Register for PaTterN"
          - the pattern that we are searching for in the 3rd program
  10  rjni    "Register for Jumping if Not Incrementing"
          - the location in program memory for the point to jump to if we should not increment things in 3rd program
  11  robc    "Register for One-Byte Count"
          - the number of times the pattern occurs within a byte over all byte
  12  rubc    "Register for Unique-Byte Count"
          - the number of bytes in which the pattern occurs at least once
  13  rtbc    "Register for Two-Byte Count"
          - the number of times the pattern occurs over the whole concatenated string. We increment this by counting
              the number of occurrences over two consecutive bytes at a time, hence the name.
"""
```

* Code begins reading from the beginning of the file down
* End of program occurs when the end of file is reached
* Jump points are defined by giving them a name and ending with a colon, for example, 'loop:'. The names of
    jump points must be alpha-numeric, and CAN contain underscores '_' and dashes '-'
* Instructions are separated by a linebreak, you cannot have multiple instructions on the same line
* '@' is for inline comments, everything after will be ignored until end of line
* All whitespace is ignored other than the special instance described below in operations

* Operations work as follows:
    op [WHITESPACE] [reg1, reg2, ...]

    That is, the operation comes first, then some form of whitespace (either space or tab), then the register or
        registers needed for the operation separated by commas.


    -- There are 16 total operations --

    General Operations:
    
        - lrv   reg, va        "Load into Register a Value"
            Loads the value 'va' into 'reg'. This is a two-instruction operation. 'va' can either be a number or an
                address for a jump point:
                > If it is a number, then the number must be preceded with a '#'. Only positive integer base-10 values
                    from [0-255] are allowed. When compiled into machine code, this gets translated into one 'lrv'
                    instruction (See JMC machine code documentation), immediately followed by the value 'va' stored
                    in binary in bits b9:b1 of the instruction.
                > If it is a jump point, then only the name of the point to jump to must be written.
                
        - lrm   reg             "Load into Register from Memory"
            Loads the value at the memory address currently stored in 'rmi' into 'reg'.
            
        - str   reg             "SToRe into memory"
            Stores the value currently in 'reg' into the memory address currently in 'rmo'.
            
        - inc   reg             "Increment"
            Increments the given register 'reg' by 1.

    Branching Operations:
    
        - bns                   "Branch if Not Stopping"
            Branch to the address currently in 'rjls' iff:  'ri' != 'rsi'
            
        - bcz                   "Branch if Count is Zero"
            Branch to the address currently in 'rjni' iff:  'rpct' == 0

    Hamming Operations:
        For these operations, assume 'rmsb' has bits denoted as b16:b9, and 'rlsb' has bits denoted as b8:b1. Parity
            bits are denoted as p8, p4, p2, p1, and p0. Bits for the error code calculated in program 2 are denoted
            s8, s4, s2, s1, s0.
            
        - hgp                   "Hamming Generate Parity bits"
            Generates the parity bits for the 11-bit message stored with MSB in 'rmsb' and LSB in 'rlsb', then stores
                these parity bits into 'rpct'. Generates the parity bits such that:
                > p8 = ^(b11:b5)
                > p4 = ^(b11:b8,b4,b3,b2)
                > p2 = ^(b11,b10,b7,b6,b4,b3,b1)
                > p1 = ^(b11,b9,b7,b5,b4,b2,b1)
                > p0 = ^(b11:1,p8,p4,p2,p1)
                
        - hel                   "Hamming Encode Least significant bits"
            Builds the output byte for the LSB output like so: [b4,b3,b2,p4,b1,p2,p1,p0], and stores into 'rstr'
              usinginput bits from 'rlsb' and 'rpct'
              
        - hem                   "Hamming Encode Most significant bits"
            Builds the output byte for the MSB output like so: [b11,b10,b9,b8,b7,b6,b5,p8], and stores into 'rstr'
              using input bits from 'rmsb', 'rlsb', and 'rpct'
              
        - hep                   "Hamming Error Parity bits"
            Builds the error parity bits by getting the parity bits expected from the received message, and 
              XOR-ing them with the parity bits from the received message. Stores into 'rpct'. Uses input from 
              'rmsb' and 'rlsb'
              
        - hcl                   "Hamming Correct Least significant bits"
            Makes what we believe is the correct message for the LSB and stores into 'rstr'. Does this by flipping
                a bit in the input message iff the binary value of [p8,p4,p2,p1] == current index of bit. Uses 
                input from 'rmsb', 'rlsb', and 'rpct'.
                
        - hcm                   "Hamming Correct Most significant bits"
            Makes what we believe is the correct message for the MSB and stores into 'rstr'. Does this by flipping
                a bit in the input message iff the binary value of [p8,p4,p2,p1] == current index of bit. Uses 
                input from 'rmsb', 'rlsb', and 'rpct'.

    Pattern Matching Operations:
        For these operations, make sure the 5-bit pattern you want to check is stored in bits [7:3] of 'rptn'
        
        - pob                   "Pattern One Byte"
            Counts the number of times the pattern in 'rptn' occurs in 'rlsb', and stores this value into 'rpct'
            
        - ptb                   "Pattern Two Byte"
            Counts the number of times the pattern in 'rptn' occurs strictly across 'rlsb' and 'rmsb', and stores 
              this value into 'rpct'

    Adding Operations:
    
        - apc   reg             "Add Pattern Count"
            Adds the value in 'rpct' to the value in 'reg' and stores this value in 'reg'

    Ending Execution:
    
        - end                   "End"
            Ends code execution. This command is automatically placed at the end of any program by the assembler, but
                it could be placed manually anywhere in the code and have the same effect.


* Definitions can be defined anywhere before use by preceding the variable name with a '$', then a '=', then the
    value that should replace that phrase anywhere else in the code. They are called again later by simply writing
    the definition name preceded by a '$'. They cannot be defined within another instruction or jump point. For example:

        $VALUE = #10
        main:
            ldr     ri, $VALUE          @ Loads $VALUE (The decimal number '10') into register ri


## Machine Code
-- Registers --

There are 14 registers, each 8 bits in size. All have specific uses. Some are multi-purpose, but none are general.

The 14 registers are as follows:

```python
"""
decimal value -- hex value -- binary value -- shorthand name -- description

0  -- 0x0 -- 0000 -- ri   -- "Register for Index"
1  -- 0x1 -- 0001 -- rmi  -- "Register for Memory Input"
2  -- 0x2 -- 0010 -- rmo  -- "Register for Memory Output"
3  -- 0x3 -- 0011 -- rsi  -- "Register for Stopping Index"
4  -- 0x4 -- 0100 -- rjls -- "Register for Jumping to Loop Start"
5  -- 0x5 -- 0101 -- rlsb -- "Register for Least Significant Bits (LSB)"
6  -- 0x6 -- 0110 -- rmsb -- "Register for Most Significant Bits (MSB)"
7  -- 0x7 -- 0111 -- rpct -- "Register for 'P' CounT"
8  -- 0x8 -- 1000 -- rstr -- "Register for SToRe"
9  -- 0x9 -- 1001 -- rptn -- "Register for PaTterN"
10 -- 0xA -- 1010 -- rjni -- "Register for Jumping if Not Incrementing"
11 -- 0xB -- 1011 -- robc -- "Register for One-Byte Count"
12 -- 0xC -- 1100 -- rubc -- "Register for Unique-Byte Count"
13 -- 0xD -- 1101 -- rtbc -- "Register for Two-Byte Count"
"""
```

-- Instructions --

Each instruction is 9 bits long. Most operations take only one instruction, however there is one that requires two
    separate instructions to complete (loading into register a value).

Assume each instruction is ordered from left to right, MSB to LSB, aka b9:b1

```python
"""
 1  0  1  0  1  0  1  0  1
b9 b8 b7 b6 b5 b4 b3 b2 b1
"""
```

Bits b9:b6 make up the OP code, b5 is unused, and b4:b1 are bits that describe a register input if needed for the OP.

```python
"""
1010_1_0101
| a |b| c |

a - OP code
b - unused bit
c - register designation
"""
```

Instruction Types:

T - Two instruction operation. Requires a second instruction to follow in order to complete.

O - One instruction operation. Only requires a single instruction and does NOT use the register designation (part 'c')

R - Register pre-designation operation. Only requires a single instruction and does use the register designation (part 'c')

OP Codes:

```python
"""
decimal value -- hex value -- binary value -- instruction name -- instruction type

0  -- 0x0 -- 0000 -- end -- O
1  -- 0x1 -- 0001 -- lrv -- T
2  -- 0x2 -- 0010 -- lrm -- R
3  -- 0x3 -- 0011 -- str -- R
4  -- 0x4 -- 0100 -- inc -- R
5  -- 0x5 -- 0101 -- bns -- O
6  -- 0x6 -- 0110 -- bcz -- O
7  -- 0x7 -- 0111 -- hgp -- O
8  -- 0x8 -- 1000 -- hel -- O
9  -- 0x9 -- 1001 -- hem -- O
10 -- 0xA -- 1010 -- hep -- O
11 -- 0xB -- 1011 -- hcl -- O
12 -- 0xC -- 1100 -- hcm -- O
13 -- 0xD -- 1101 -- pob -- O
14 -- 0xE -- 1110 -- ptb -- O
15 -- 0xF -- 1111 -- apc -- R
"""
```

For descriptions on what each operation does exactly, refer to the JAL assembly language documentation.
