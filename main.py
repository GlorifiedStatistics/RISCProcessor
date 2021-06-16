from Assembler import assemble

path = 'JAL/program.jal'

with open(path, 'r') as f:
    machine_code = assemble(f.read())

    for i, inst in enumerate(machine_code):
        print("    core[%d] = 9'b%s;" % (i, inst))
