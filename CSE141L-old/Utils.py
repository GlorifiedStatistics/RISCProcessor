from Constants import *


def load_hamming(path='hamming_codes.txt'):
    """
    :return: dictionary of integer keys with tuple values, tuple is 2 strings (LSB, MSB)
    """
    with open(path, 'r') as f:
        return {i: (l[8:-1], l[:8]) for i, l in enumerate(f.readlines())}


def load_program(path='program.jal'):
    with open(path, 'r') as f:
        return f.read()


def print_machine_code(machine_code):
    print("Machine Code Instructions:\n")
    for i, mc in enumerate(machine_code):
        print(str(i) + ": " + (" " if i < 10 else "") + mc[:4] + "_" + mc[4] + "_" + mc[5:])
    print("\n")


def print_machine_code_stats(machine_code):
    counts = {k: 0 for k, v in OP_FROM_INSTRUCTION.items()}

    skip = False
    for inst in machine_code:
        if skip:
            skip = False
            continue

        counts[INSTRUCTION_FROM_OP[inst[:4]]] += 1
        if inst[:4] == OP_FROM_INSTRUCTION['lrv']:
            skip = True

    num_un = 0
    for k, v in counts.items():
        num_un += v

    print("Num Instructions:", len(machine_code))
    print("Num Unique Instructions:", num_un)
    print()
    print("Num Per Instruction:")
    for k, v in counts.items():
        print("\"" + k + "\":", v)
    print("\n")


def print_dut_mem(mem):
    print("Final Memory Values:\n")
    for k, v in mem.items():
        i = int(k, 2)
        print(str(i) + ":" + (" " if i < 10 else "") + (" " if i < 100 else ""), v, int(v, 2))
    print("\n")


def print_dut_stats(stats):
    print("Num Cycles:", stats['num_cycles'])
    print()
    print("Num Executions per Instruction:")
    for k, v in stats.items():
        if k in OP_FROM_INSTRUCTION.keys():
            print("\"" + k + "\":", stats[k])


def generate_instruction_rom(machine_code):
    ret = """// This file auto-generated
module inst_ROM (
  input wire          reset,
  input wire    [7:0] address,
  output wire	[8:0] instruction
);

  reg   [{0}:0] inst_mem [{1}:0];
  integer i;
  
  always @(*) begin
    if (reset) begin
""".format(INSTRUCTION_LENGTH, 2**REG_SIZE - 1)
    for i, inst in enumerate(machine_code):
        ret += "      inst_mem[{0}] <= 9'b{1};\n".format(i, inst[:4] + "_" + inst[4] + "_" + inst[5:], i)

    ret += """      for (i={0}; i<255; i=i+1) begin
        inst_mem[i] <= 9'd0;
      end
    end
  end
  
  assign instruction = inst_mem[address];
  
endmodule""".format(len(machine_code))

    return ret


def is_list(l):
    """
    Checks iterability and indexing to make see if l is a list
    """
    try:
        for _ in l:
            pass
        if len(l) > 0:
            a = l[0]
        return not isinstance(l, dict)
    except TypeError:
        return False


def to_binary(num, bits):
    if num >= 2 ** bits:
        raise ValueError("Error: need more bits for value %d, only have %d" % (num, bits))
    ret = "{0:b}".format(num)
    while len(ret) < bits:
        ret = '0' + ret
    return ret
