"""
@@@@@@@@@@@@@@@@@@@@@@@@@@@
        MACHINE CODE
@@@@@@@@@@@@@@@@@@@@@@@@@@@
Name: JMC ("Justin's Machine Code")


-- Registers --

There are 14 registers, each 8 bits in size. All have specific uses. Some are multi-purpose, but none are general.

The 14 registers are as follows:

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


-- Instructions --

Each instruction is 9 bits long. Most operations take only one instruction, however there is one that requires two
    separate instructions to complete (loading into register a value).

Assume each instruction is ordered from left to right, MSB to LSB, aka b9:b1
 1  0  1  0  1  0  1  0  1
b9 b8 b7 b6 b5 b4 b3 b2 b1

Bits b9:b6 make up the OP code, b5 is unused, and b4:b1 are bits that describe a register input if needed for the OP.

1010_1_0101
| a |b| c |

a - OP code
b - unused bit
c - register designation


Instruction Types:

T - Two instruction operation. Requires a second instruction to follow in order to complete.
O - One instruction operation. Only requires a single instruction and does NOT use the register designation (part 'c')
R - Register pre-designation operation. Only requires a single instruction and does use the register designation (part 'c')

OP Codes:

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

For descriptions on what each operation does exactly, refer to the JAL assembly language documentation.
"""

from Constants import *
from Utils import *


class DUT:
    def __init__(self, instructions, memory):
        """
        Initialize the DUT
        :param instructions: a list of strings each 9 characters wide composed of only 1's and 0's
        :param memory: a list of length 256 of string to initialize memory to, each containing only 1's and 0's, and
            being of size MEMORY_LENGTH
        """
        self.inst = _check_mem(instructions, 'instructions', INSTRUCTION_LENGTH)
        self.mem = _check_mem(memory, 'memory', MEMORY_LENGTH, is_mem=True)
        self.reg = {to_binary(i, REG_INDEX_LENGTH): "00000000" for i in range(NUM_REGISTERS)}

    def get_memory(self):
        """
        Returns the memory as a list of strings instead of a dictionary
        """
        ret = [0 for i in range(len(self.mem.keys()))]
        for k, v in self.mem.items():
            ret[int(k, 2)] = v
        return ret

    def exec(self):
        """
        Executes the instructions in the DUT
        :return: number of clock cycles taken to execute
        """
        stats = {
            'num_cycles': 0
        }
        for k, v in OP_FROM_INSTRUCTION.items():
            stats[k] = 0

        execution_history = ""

        i = 0
        while True:
            inst = self.inst[i]
            op = inst[0:4]
            reg = inst[5:9]
            stats['num_cycles'] += 1

            if i == 65:
                c = 1

            if op == OP_FROM_INSTRUCTION['end']:
                stats['end'] += 1
                execution_history += "\nProgram Ending"
                break

            elif op == OP_FROM_INSTRUCTION['lrv']:
                i += 1
                self.reg[reg] = self.inst[i][1:9]
                execution_history += "\nLoading into register: " + REG_NAMES_FROM_BINARY[reg] + " the value: " \
                                     + self.inst[i][1:9] + " (" + str(int(self.inst[i][1:9], 2)) + ")"

            elif op == OP_FROM_INSTRUCTION['lrm']:
                self.reg[reg] = self._ld_mem()
                execution_history += "\nLoading into register: " + REG_NAMES_FROM_BINARY[reg] \
                        + " from memory location: " + str(int(self.reg[REG_NAMES['rmi']], 2)) + " the value: " \
                        + self.reg[reg]

            elif op == OP_FROM_INSTRUCTION['str']:
                self._str_mem(reg)
                execution_history += "\nStoring value in register: " + REG_NAMES_FROM_BINARY[reg] + " (" \
                    + self.reg[reg] + ") into memory location: " + str(int(self.reg[REG_NAMES['rmo']]))

            elif op == OP_FROM_INSTRUCTION['inc']:
                execution_history += "\nIncrementing value in register: " + REG_NAMES_FROM_BINARY[reg] + ". Was: " \
                    + self.reg[reg] + " (" + str(int(self.reg[reg], 2)) + "). "
                self.reg[reg] = (_add(self.reg[reg], to_binary(1, REG_SIZE)))
                execution_history += "Now: " + self.reg[reg] + " (" + str(int(self.reg[reg], 2)) + ")"

            elif op == OP_FROM_INSTRUCTION['bns']:
                execution_history += "\nBranching if not stopping."
                i, execution_history = self._bns(i, execution_history)

            elif op == OP_FROM_INSTRUCTION['bcz']:
                execution_history += "\nBranching if count is zero. Count: " + str(int(self.reg[REG_NAMES['rpct']], 2))
                i, execution_history = self._bcz(i, execution_history)

            elif op == OP_FROM_INSTRUCTION['hgp']:
                self.reg[reg] = self._hgp()

            elif op == OP_FROM_INSTRUCTION['hel']:
                self.reg[reg] = self._hel()

            elif op == OP_FROM_INSTRUCTION['hem']:
                self.reg[reg] = self._hem()

            elif op == OP_FROM_INSTRUCTION['hep']:
                self.reg[reg] = self._hep()

            elif op == OP_FROM_INSTRUCTION['hcl']:
                self.reg[reg] = self._hcl()

            elif op == OP_FROM_INSTRUCTION['hcm']:
                self.reg[reg] = self._hcm()

            elif op == OP_FROM_INSTRUCTION['pob']:
                execution_history += "\nChecking one byte with pattern: " + self.reg[REG_NAMES['rptn']][:-3] \
                    + " in lsb: " + self.reg[REG_NAMES['rlsb']] + ". "
                self.reg[reg] = self._pob()
                execution_history += "Found count of: " + self.reg[REG_NAMES['rpct']] + " (" \
                                     + str(int(self.reg[REG_NAMES['rpct']], 2)) + ")"

            elif op == OP_FROM_INSTRUCTION['ptb']:
                execution_history += "\nChecking TWO byte with pattern: " + self.reg[REG_NAMES['rptn']][:-3] \
                                     + " in lsb: " + self.reg[REG_NAMES['rlsb']] + " and msb: " \
                                     + self.reg[REG_NAMES['rmsb']] + ". "
                self.reg[reg] = self._ptb()
                execution_history += "Found count of: " + self.reg[REG_NAMES['rpct']] + " (" \
                                     + str(int(self.reg[REG_NAMES['rpct']], 2)) + ")"

            elif op == OP_FROM_INSTRUCTION['apc']:
                v = _add(self.reg[reg], self.reg[REG_NAMES['rpct']])
                execution_history += "\nAdding: " + self.reg[REG_NAMES['rpct']] + " (" \
                                     + str(int(self.reg[REG_NAMES['rpct']], 2)) + ") to register: "\
                                     + REG_NAMES_FROM_BINARY[reg] + " (" + str(int(self.reg[reg], 2)) \
                                     + ") with result: " + v + " (" + str(int(v, 2)) + ")"
                self.reg[reg] = v

            else:
                raise ValueError("This should not happen!")

            i += 1
            stats[INSTRUCTION_FROM_OP[op]] += 1

        stats['ex_hist'] = execution_history
        return stats

    def _ld_mem(self):
        """
        :return: the value in memory at the address currently stored in register 'rmi'
        """
        return self.mem[self.reg[REG_NAMES['rmi']]]

    def _str_mem(self, reg):
        """
        Stores the value in the given register into the memory location currently stored in register 'rmo'
        """
        self.mem[self.reg[REG_NAMES['rmo']]] = self.reg[reg]

    def _bns(self, i, ex_hist):
        """
        Branches to the jump point in 'rjls' iff 'ri' != 'rsi'
        :param i: the current instruction point
        :return: the next instruction. Will change if we should jump, otherwise just 'i'
        """
        if self.reg[REG_NAMES['ri']] != self.reg[REG_NAMES['rsi']]:
            ex_hist += " Branched!\n"
            i = int(self.reg[REG_NAMES['rjls']], 2)
        return i, ex_hist

    def _bcz(self, i, ex_hist):
        """
        Branches to the jump point in 'rjni' iff 'rpct' != 0
        :param i: the current instruction point
        :return: the next instruction. Will change if we should jump, otherwise, just 'i'
        """
        if int(self.reg[REG_NAMES['rpct']], 2) == 0:
            ex_hist += " Branched!"
            i = int(self.reg[REG_NAMES['rjni']], 2)
        return i, ex_hist

    def _hgp(self):
        """
        Return the parity bits from MSB in 'rmsb' and LSB in 'rlsb' where
            > p8 = ^(b11:b5)
            > p4 = ^(b11:b8,b4,b3,b2)
            > p2 = ^(b11,b10,b7,b6,b4,b3,b1)
            > p1 = ^(b11,b9,b7,b5,b4,b2,b1)
            > p0 = ^(b11:1,p8,p4,p2,p1)
        :return: the bits '000' + p8 + p4 + p2 + p1 + p0
        """
        p8 = '0' if len(self._get_mlsb_bits([11, 10, 9, 8, 7, 6, 5]).replace('0', '')) % 2 == 0 else '1'
        p4 = '0' if len(self._get_mlsb_bits([11, 10, 9, 8, 4, 3, 2]).replace('0', '')) % 2 == 0 else '1'
        p2 = '0' if len(self._get_mlsb_bits([11, 10, 7, 6, 4, 3, 1]).replace('0', '')) % 2 == 0 else '1'
        p1 = '0' if len(self._get_mlsb_bits([11, 9, 7, 5, 4, 2, 1]).replace('0', '')) % 2 == 0 else '1'
        p0 = '0' if len((self._get_mlsb_bits(range(1, 12)) + p8 + p4 + p2 + p1).replace('0', '')) % 2 == 0 else '1'
        return '000' + p8 + p4 + p2 + p1 + p0

    def _hel(self):
        """
        Return the LSB bits output of encoded hamming with 'rlsb' as LSB bits, and 'rpct' as parity bits
        """
        return self._get_mlsb_bits([4, 3, 2]) + self._get_parity_bits([4]) + self._get_mlsb_bits([1]) \
               + self._get_parity_bits([2, 1, 0])

    def _hem(self):
        """
        Return the MSB bits output of encoded hamming with 'rmsb' as MSB, 'rlsb' as LSB bits, and 'rpct' as parity bits
        """
        return self._get_mlsb_bits([11, 10, 9, 8, 7, 6, 5]) + self._get_parity_bits([8])

    def _hep(self):
        """
        Return the error bits as s0 + '00' + e8 + e4 + e2 + e1 + e0
        Assumes the encoded message is in 'rmsb' and 'rlsb'
        """
        s8 = '0' if len(self._get_mlsb_bits([16, 15, 14, 13, 12, 11, 10]).replace('0', '')) % 2 == 0 else '1'
        s4 = '0' if len(self._get_mlsb_bits([16, 15, 14, 13, 8, 7, 6]).replace('0', '')) % 2 == 0 else '1'
        s2 = '0' if len(self._get_mlsb_bits([16, 15, 12, 11, 8, 7, 4]).replace('0', '')) % 2 == 0 else '1'
        s1 = '0' if len(self._get_mlsb_bits([16, 14, 12, 10, 8, 6, 4]).replace('0', '')) % 2 == 0 else '1'
        s0 = '0' if len((self.reg[REG_NAMES['rmsb']] + self.reg[REG_NAMES['rlsb']]).replace('0', '')) % 2 == 0 else '1'

        e8 = _xor(s8, self._get_mlsb_bits([9]))
        e4 = _xor(s4, self._get_mlsb_bits([5]))
        e2 = _xor(s2, self._get_mlsb_bits([3]))
        e1 = _xor(s1, self._get_mlsb_bits([2]))

        if s0 == '0' and (e8 + e4 + e2 + e1) != '0000':
            s0 = '1'
        else:
            s0 = '0'

        return s0 + '00' + e8 + e4 + e2 + e1 + '0'

    def _hcl(self):
        """
        Returns the decoded LSB message assuming encoded message resides in 'rmsb' and 'rlsb' and parity bits in 'rpct'
        """
        flip = int(self.reg[REG_NAMES['rpct']][3:7], 2) + 1
        bits = [13, 12, 11, 10, 8, 7, 6, 4]
        ret = self._get_mlsb_bits(bits)
        if flip in bits:
            i = bits.index(flip)
            ret = ret[:i] + ('1' if ret[i] == '0' else '0') + ret[i + 1:]
        return ret

    def _hcm(self):
        """
        Returns the decoded MSB message assuming encoded message resides in 'rmsb' and 'rlsb' and parity bits in 'rpct'
        """
        flip = int(self.reg[REG_NAMES['rpct']][3:7], 2) + 1
        bits = [16, 15, 14]
        ret = self._get_mlsb_bits(bits)
        if flip in bits:
            i = bits.index(flip)
            ret = ret[:i] + ('1' if ret[i] == '0' else '0') + ret[i + 1:]
        return self.reg[REG_NAMES['rpct']][0] + '0000' + ret

    def _pob(self):
        """
        Returns the number of times the pattern in bits 7:3 of 'rptn' occur in the register 'rlsb'
        """
        ptn = self.reg[REG_NAMES['rptn']][0:5]
        return to_binary(_count(ptn, self.reg[REG_NAMES['rlsb']]), REG_SIZE)

    def _ptb(self):
        """
        Returns the number of times the pattern in bits 7:3 of 'rptn' occur in between registers 'rlsb' and 'rmsb'
        """
        ptn = self.reg[REG_NAMES['rptn']][0:5]
        chk = self.reg[REG_NAMES['rlsb']][4:8] + self.reg[REG_NAMES['rmsb']][0:4]
        return to_binary(_count(ptn, chk), REG_SIZE)

    """
    Helper Functions of DUT
    """

    def _get_mlsb_bits(self, bits):
        """
        Returns a string of the bits wanted in 'bits' using 'rmsb' as bits b16:b9 and 'rlsb' as bits b8:b1
        :param bits: the bits to get
        """
        ret = ""
        for b in bits:
            if b > 8:
                ret += self.reg[REG_NAMES['rmsb']][-(b - 8)]
            else:
                ret += self.reg[REG_NAMES['rlsb']][-b]
        return ret

    def _get_parity_bits(self, bits):
        """
        Returns a string of the bits wanted in 'rpct'; one or more of: p8, p4, p2, p1, p0
        :param bits: the bits to get
        """
        ret = ""
        for b in bits:
            if b == 8:
                ret += self.reg[REG_NAMES['rpct']][3]
            elif b == 4:
                ret += self.reg[REG_NAMES['rpct']][4]
            elif b == 2:
                ret += self.reg[REG_NAMES['rpct']][5]
            elif b == 1:
                ret += self.reg[REG_NAMES['rpct']][6]
            elif b == 0:
                ret += self.reg[REG_NAMES['rpct']][7]
        return ret


####################
# Helper Functions #
####################

def _add(b1, b2):
    return to_binary((int(b1, 2) + int(b2, 2)) % 2 ** REG_SIZE, REG_SIZE)


def _xor(b1, b2):
    if not isinstance(b1, str) or not isinstance(b2, str) or len(b1) != 1 or len(b2) != 1:
        raise ValueError("XOR needs two single bits!")
    return '1' if b1 != b2 else '0'


def _check_mem(mem, name, size, is_mem=False):
    if not is_list(mem) or len(mem) > 256:
        raise ValueError(name + " input must have size <= 256")
    if is_mem and len(mem) != 256:
        raise ValueError("DUT memory input must be array of size 256")

    for m in mem:
        if not isinstance(m, str) or m.replace('1', '').replace('0', '') != '':
            raise ValueError(name + " elements must be strings composed only of 1's and 0's")
        if len(m) != size:
            raise ValueError(name + " elements must be strings of size: %d" % size)

    if is_mem:
        ret = {}
        for i in range(len(mem)):
            ret[to_binary(i, MEMORY_LENGTH)] = mem[i]
        return ret

    return [m for m in mem]


def _count(ptn, bits):
    c = 0
    for i in range(len(bits) - len(ptn) + 1):
        if bits[i:i+len(ptn)] == ptn:
            c += 1
    return c
