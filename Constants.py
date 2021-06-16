def to_binary(num, bits):
    if num >= 2 ** bits:
        raise ValueError("Error: need more bits for value %d, only have %d" % (num, bits))
    ret = "{0:b}".format(num)
    while len(ret) < bits:
        ret = '0' + ret
    return ret


REG_INDEX_LENGTH = 4
INSTRUCTION_LENGTH = 9

REG_NAMES = {
    "ri": to_binary(0, REG_INDEX_LENGTH),
    "rmi": to_binary(1, REG_INDEX_LENGTH),
    "rmo": to_binary(2, REG_INDEX_LENGTH),
    "rsi": to_binary(3, REG_INDEX_LENGTH),
    "rjls": to_binary(4, REG_INDEX_LENGTH),
    "rlsb": to_binary(5, REG_INDEX_LENGTH),
    "rmsb": to_binary(6, REG_INDEX_LENGTH),
    "rpct": to_binary(7, REG_INDEX_LENGTH),
    "rstr": to_binary(8, REG_INDEX_LENGTH),
    "rptn": to_binary(9, REG_INDEX_LENGTH),
    "rjni": to_binary(10, REG_INDEX_LENGTH),
    "robc": to_binary(11, REG_INDEX_LENGTH),
    "rubc": to_binary(12, REG_INDEX_LENGTH),
    "rtbc": to_binary(13, REG_INDEX_LENGTH),
}

NUM_REGISTERS = len(REG_NAMES.keys())

######################
# Assembly Constants #
######################

INSTRUCTION_OP_CODE_LENGTH = 4

CC = '@'  # Comment Char
NC = '#'  # Number Char
DC = '$'  # Definition Char

OP_FROM_INSTRUCTION = {
    'end': to_binary(0, INSTRUCTION_OP_CODE_LENGTH),
    'lrv': to_binary(1, INSTRUCTION_OP_CODE_LENGTH),
    'lrm': to_binary(2, INSTRUCTION_OP_CODE_LENGTH),
    'str': to_binary(3, INSTRUCTION_OP_CODE_LENGTH),
    'inc': to_binary(4, INSTRUCTION_OP_CODE_LENGTH),
    'bns': to_binary(5, INSTRUCTION_OP_CODE_LENGTH),
    'bcz': to_binary(6, INSTRUCTION_OP_CODE_LENGTH),
    'hgp': to_binary(7, INSTRUCTION_OP_CODE_LENGTH),
    'hel': to_binary(8, INSTRUCTION_OP_CODE_LENGTH),
    'hem': to_binary(9, INSTRUCTION_OP_CODE_LENGTH),
    'hep': to_binary(10, INSTRUCTION_OP_CODE_LENGTH),
    'hcl': to_binary(11, INSTRUCTION_OP_CODE_LENGTH),
    'hcm': to_binary(12, INSTRUCTION_OP_CODE_LENGTH),
    'pob': to_binary(13, INSTRUCTION_OP_CODE_LENGTH),
    'ptb': to_binary(14, INSTRUCTION_OP_CODE_LENGTH),
    'apc': to_binary(15, INSTRUCTION_OP_CODE_LENGTH),
}
