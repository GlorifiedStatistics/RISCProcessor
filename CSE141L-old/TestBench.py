from Utils import *
from Constants import *
import random

_INIT_HAMMING = 11


def test_program1(mem, expected, pr=True):
    for i in range(NUM_LOOPS_P1):
        _check_mem(MEM_IN_P1 + i * 2, mem, expected, pr)
        _check_mem(MEM_IN_P1 + i * 2 + 1, mem, expected, pr)
        _check_mem(MEM_OUT_P1 + i * 2, mem, expected, pr)
        _check_mem(MEM_OUT_P1 + i * 2 + 1, mem, expected, pr)


def test_program2(mem, expected, pr=True):
    for i in range(NUM_LOOPS_P2):
        _check_mem(MEM_IN_P2 + i * 2, mem, expected, pr)
        _check_mem(MEM_IN_P2 + i * 2 + 1, mem, expected, pr)
        _check_mem(MEM_OUT_P2 + i * 2, mem, expected, pr)
        _check_mem(MEM_OUT_P2 + i * 2 + 1, mem, expected, pr)


def test_program3(mem, expected, pr=True):
    for i in range(NUM_LOOPS_P3 + 1):
        _check_mem(MEM_IN_P3 + i, mem, expected, pr)
    _check_mem(MEM_OUT_P3, mem, expected, pr)
    _check_mem(MEM_OUT_P3 + 1, mem, expected, pr)
    _check_mem(MEM_OUT_P3 + 2, mem, expected, pr)


def assert_equal_memory(mem, expected, pr=True):
    if len(mem) != len(expected):
        print("Unequal memory lengths! mem: %d, expected: %d" % (len(mem), len(expected)))

    bad = False
    for i in range(len(mem)):
        if not isinstance(mem[i], str) or not isinstance(expected[i], str):
            print("Bad memory types at i:", i)
        if len(mem[i]) != MEMORY_LENGTH or len(expected[i]) != MEMORY_LENGTH:
            print("Memory length is not correct at i:", i)
        if not _check_mem(i, mem, expected, pr):
            bad = True
    if not bad and pr:
        print("Memories are equal!")

    return not bad


def _check_mem(i, mem, expected, pr=True):
    if mem[i] != expected[i]:
        if pr:
            print(str(i) + ":", mem[i], "≠", expected[i])
        return False
    return True


def populate_memory():
    """
    :return: a tuple of the memory input for DUT, along with expected memory output
    """
    mem = ['0' * MEMORY_LENGTH for i in range(2 ** REG_SIZE)]
    expected = ['0' * MEMORY_LENGTH for i in range(2 ** REG_SIZE)]
    hamming = load_hamming()

    # PROGRAM 1

    # Generate input/output for program1
    for i in range(NUM_LOOPS_P1):
        v = random.randint(0, len(hamming) - 1)
        olsb, omsb = hamming[v]
        ib = '0' * (2 * MEMORY_LENGTH - _INIT_HAMMING) + to_binary(v, _INIT_HAMMING)
        ilsb = ib[-8:]
        imsb = ib[:8]

        mem[MEM_IN_P1 + 2 * i] = ilsb
        mem[MEM_IN_P1 + 2 * i + 1] = imsb

        expected[MEM_IN_P1 + 2 * i] = ilsb
        expected[MEM_IN_P1 + 2 * i + 1] = imsb
        expected[MEM_OUT_P1 + 2 * i] = olsb
        expected[MEM_OUT_P1 + 2 * i + 1] = omsb

    # PROGRAM 2

    # Generate input/output for program2
    for i in range(NUM_LOOPS_P2):
        v = random.randint(0, len(hamming) - 1)
        ilsb, imsb = hamming[v]
        p = random.randint(0, 2)

        ob = to_binary(v, 2 * MEMORY_LENGTH)
        olsb = ob[8:]
        omsb = ob[:8]

        # By number of bits changed
        if p == 0:
            pass
        elif p == 1:
            b, bb = random.randint(0, 1), random.randint(0, 7)
            if b == 0:
                ilsb = _flip(ilsb, bb)
            else:
                imsb = _flip(imsb, bb)
        else:
            b1, bb1 = random.randint(0, 1), random.randint(0, 7)
            b2, bb2 = random.randint(0, 1), random.randint(0, 7)

            # Make sure we dont flip the same bit twice
            while b1 == b2 and bb1 == bb2:
                b2, bb2 = random.randint(0, 1), random.randint(0, 7)

            if b1 == 0:
                ilsb = _flip(ilsb, bb1)
            else:
                imsb = _flip(imsb, bb1)
            if b2 == 0:
                ilsb = _flip(ilsb, bb2)
            else:
                imsb = _flip(imsb, bb2)

            pty = _get_parity(ilsb, imsb)
            opty = imsb[7] + ilsb[3] + ilsb[5:7]
            bc = "".join(['1' if a != b else '0' for a, b in zip(pty, opty)])
            idx = int(bc, 2)
            if idx >= 8:
                idx = 16 - idx - 1
                tmsb = imsb[:idx] + ('1' if imsb[idx] == '0' else '0') + imsb[idx + 1:]
                tlsb = ilsb
            else:
                idx = 8 - idx - 1
                tmsb = imsb
                tlsb = ilsb[:idx] + ('1' if ilsb[idx] == '0' else '0') + ilsb[idx + 1:]

            omsb = '10000' + tmsb[:3]
            olsb = tmsb[3:7] + tlsb[:3] + tlsb[4]

        mem[MEM_IN_P2 + 2 * i] = ilsb
        mem[MEM_IN_P2 + 2 * i + 1] = imsb

        expected[MEM_IN_P2 + 2 * i] = ilsb
        expected[MEM_IN_P2 + 2 * i + 1] = imsb
        expected[MEM_OUT_P2 + 2 * i] = olsb
        expected[MEM_OUT_P2 + 2 * i + 1] = omsb

    # Program 3

    #s = "00001000" + "01000010" + "00001000" + '0' * (MEMORY_LENGTH * (NUM_LOOPS_P3 - 2))
    #ptn = "00001"
    s = _random_bits(MEMORY_LENGTH * (NUM_LOOPS_P3 + 1))
    ptn = _random_bits(5)
    obc = 0
    ubc = 0

    mem[MEM_IN_PTN] = ptn + '000'
    expected[MEM_IN_PTN] = ptn + '000'

    for i in range(NUM_LOOPS_P3 + 1):
        byte = s[i * MEMORY_LENGTH:(i + 1) * MEMORY_LENGTH]
        if ptn in byte:
            ubc += 1
            obc += _count(ptn, byte)

        mem[MEM_IN_P3 + i] = byte
        expected[MEM_IN_P3 + i] = byte

    tbc = _count(ptn, s)

    expected[MEM_OUT_P3] = to_binary(obc, MEMORY_LENGTH)
    expected[MEM_OUT_P3 + 1] = to_binary(ubc, MEMORY_LENGTH)
    expected[MEM_OUT_P3 + 2] = to_binary(tbc, MEMORY_LENGTH)

    return mem, expected


def _flip(bits, idx):
    return bits[:idx] + ('1' if bits[idx] == '0' else '0') + bits[idx + 1:]


def _get_parity(lsb, msb):
    p8 = '0' if len((msb[:7]).replace('0', '')) % 2 == 0 else '1'
    p4 = '0' if len((msb[:4] + lsb[:3]).replace('0', '')) % 2 == 0 else '1'
    p2 = '0' if len((msb[:2] + msb[4:6] + lsb[:2] + lsb[4]).replace('0', '')) % 2 == 0 else '1'
    p1 = '0' if len((msb[:7:2] + lsb[:5:2]).replace('0', '')) % 2 == 0 else '1'
    return p8 + p4 + p2 + p1


def _random_bits(num):
    return "".join(['1' if random.randint(0, 1) == 1 else '0' for i in range(num)])


def _count(ptn, bits):
    c = 0
    for i in range(len(bits) - len(ptn) + 1):
        if bits[i:i + len(ptn)] == ptn:
            c += 1
    return c
