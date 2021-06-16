"""
@@@@@@@@@@@@@@@@@@@@@@@@@@@
     ASSEMBLY LANGUAGE
@@@@@@@@@@@@@@@@@@@@@@@@@@@
Name: JAL ("Justin's Assembly Language")


* There are 14 registers for use:
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
            Builds the output byte for the LSB output like so: [b4,b3,b2,p4,b1,p2,p1,p0], and stores into 'rstr' using
                input bits from 'rlsb' and 'rpct'
        - hem                   "Hamming Encode Most significant bits"
            Builds the output byte for the MSB output like so: [b11,b10,b9,b8,b7,b6,b5,p8], and stores into 'rstr' using
                input bits from 'rmsb', 'rlsb', and 'rpct'
        - hep                   "Hamming Error Parity bits"
            Builds the error parity bits by getting the parity bits expected from the received message, and XOR-ing them
                with the parity bits from the received message. Stores into 'rpct'. Uses input from 'rmsb' and 'rlsb'
        - hcl                   "Hamming Correct Least significant bits"
            Makes what we believe is the correct message for the LSB and stores into 'rstr'. Does this by flipping
                a bit in the input message iff the binary value of [p8,p4,p2,p1] == current index of bit. Uses input
                from 'rmsb', 'rlsb', and 'rpct'.
        - hcm                   "Hamming Correct Most significant bits"
            Makes what we believe is the correct message for the MSB and stores into 'rstr'. Does this by flipping
                a bit in the input message iff the binary value of [p8,p4,p2,p1] == current index of bit. Uses input
                from 'rmsb', 'rlsb', and 'rpct'.

    Pattern Matching Operations:
        For these operations, make sure the 5-bit pattern you want to check is stored in bits [7:3] of 'rptn'

        - pob                   "Pattern One Byte"
            Counts the number of times the pattern in 'rptn' occurs in 'rlsb', and stores this value into 'rpct'
        - ptb                   "Pattern Two Byte"
            Counts the number of times the pattern in 'rptn' occurs strictly across 'rlsb' and 'rmsb', and stores this
                value into 'rpct'

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
"""

from Constants import *


def assemble(code):
    """
    Builds the machine code from the given assembly code.
    :param code: the assembly code (a string)
    :return: a list of machine code operations
    """

    # Clean up the lines to get only the code
    comment = False
    cleaned = ""
    for c in code:
        if comment:
            if c == '\n':
                cleaned = cleaned + '\n'
                comment = False
            continue

        if c == CC:
            comment = True
        elif c == ' ' or c == '\t':
            continue
        else:
            cleaned = cleaned + c

    # Split into separate lines of code
    lines = cleaned.split('\n')

    definitions = {}
    machine_code = []
    jump_codes = []  # Holds tuples of (index of machine code that needs to have jump value changed, jump name, line)
    jump_names = {}  # Names of jump points as keys along with machine code indexes of where to jump
    jump_next_instruction = False  # If true, then the next instruction we have needs a jump point attached to it
    jump_name_temp = ""  # Holds temporary name of jump point until we find the next instruction to map it with
    for line in lines:
        if len(line) == 0:
            continue
        if line[0] == '$':
            if '=' not in line:
                raise ValueError("No '=' in definition: %s" % line)
            definitions[line.split('=')[0]] = line.split('=')[1]
            continue
        elif ':' in line:
            jump_name_temp = line.split(':')[0]
            jump_next_instruction = True
            line = line.split(':')[1]
            if len(line) == 0:
                continue

        # Check to replace definitions
        line = _replace_def(line, definitions)

        # Do the instructions
        if len(line) < 3:
            raise ValueError("Unknown instruction: %s" % line)

        # Do the op codes
        op = line[:3]
        line = line[3:]

        # The doing of the codes
        #
        #

        if op == 'lrv':
            o1, o2 = _parse_comma(2, op, line)
            _check_reg(o1, line)

            if o2[0] == '#':
                try:
                    v = int(o2[1:])
                except:
                    raise ValueError("Can not make an integer number from '%s': %s" % (o2, line))
                if v < 0 or v > 255:
                    raise ValueError("Values must be in range [0, 255]: %d, in: %s" % (v, line))
                v = to_binary(v, INSTRUCTION_LENGTH)
            else:
                v = '0' * INSTRUCTION_LENGTH
                jump_codes.append((len(machine_code) + 1, o2, line))

            machine_code.append(_make_instruction(op, o1))
            machine_code.append(v)

        elif op in ['lrm', 'str', 'inc', 'apc']:
            o1 = _parse_comma(1, op, line)
            _check_reg(o1, line)
            machine_code.append(_make_instruction(op, o1))

        elif op in ['hel', 'hem', 'hcl', 'hcm']:
            _parse_comma(0, op, line)
            machine_code.append(_make_instruction(op, 'rstr'))

        elif op in ['hgp', 'hep', 'pob', 'ptb']:
            _parse_comma(0, op, line)
            machine_code.append(_make_instruction(op, 'rpct'))

        elif op in ['bns', 'bcz', 'end']:
            _parse_comma(0, op, line)
            machine_code.append(_make_instruction(op))

        else:
            raise ValueError("Unknown instruction: %s" % op)

        #
        #
        # End doing of the codes

        # Make the jump values if necessary
        if jump_next_instruction:
            jump_names[jump_name_temp] = len(machine_code) - 1
            jump_next_instruction = False

    # Fix the jump areas
    for i, jump, line in jump_codes:
        if jump not in jump_names.keys():
            raise ValueError("Unknown jump location '%s': %s" % (jump, line))
        machine_code[i] = to_binary(jump_names[jump], INSTRUCTION_LENGTH)

    if machine_code[-1][:INSTRUCTION_OP_CODE_LENGTH] != OP_FROM_INSTRUCTION['end']:
        machine_code.append(OP_FROM_INSTRUCTION['end'] + '0' * (INSTRUCTION_LENGTH - len(OP_FROM_INSTRUCTION['end'])))
    return machine_code


def _check_reg(o, l):
    if o not in REG_NAMES.keys():
        raise ValueError("Unknown register '%s' in: %s" % (o, l))


def _make_instruction(operation, reg=None):
    return OP_FROM_INSTRUCTION[operation] + '0' + (REG_NAMES[reg] if reg is not None else '0' * REG_INDEX_LENGTH)


def _parse_comma(n, inst, l):
    if n == 0 or n == 1:
        if ',' in l:
            raise ValueError('%s instruction takes %d arguments, but found a comma after: %s' % (inst, n, l))
    elif ',' not in l:
        raise ValueError('%s instruction takes %d arguments, but a comma was not found: %s' % (inst, n, l))
    elif l.count(',') > 1:
        raise ValueError('%s instruction takes %d arguments, but multiple commas were found: %s' % (inst, n, l))

    if n == 1:
        return l
    elif n == 2:
        return l.split(',')[:2]


def _replace_def(line, definitions):
    names = sorted(list(definitions.keys()), key=lambda x: len(x), reverse=True)

    new_line = line[:]

    found_name = True
    count = 0
    while found_name:
        found_name = False
        for name in names:
            if name in new_line:
                new_line = new_line.replace(name, definitions[name])
                found_name = True
                count += 1
        if count > len(names):
            raise ValueError("Recursive definitions in: %s" % line)

    return new_line
