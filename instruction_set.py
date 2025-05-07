# MIPS instruction format specifications
R_TYPE_FORMAT = {
    'opcode': {'bits': 6, 'start': 26},
    'rs': {'bits': 5, 'start': 21},
    'rt': {'bits': 5, 'start': 16},
    'rd': {'bits': 5, 'start': 11},
    'shamt': {'bits': 5, 'start': 6},
    'funct': {'bits': 6, 'start': 0}
}

I_TYPE_FORMAT = {
    'opcode': {'bits': 6, 'start': 26},
    'rs': {'bits': 5, 'start': 21},
    'rt': {'bits': 5, 'start': 16},
    'immediate': {'bits': 16, 'start': 0}
}

J_TYPE_FORMAT = {
    'opcode': {'bits': 6, 'start': 26},
    'address': {'bits': 26, 'start': 0}
}

# Opcode and function code mappings for MIPS instructions
OPCODE_MAP = {
    'R-type': 0b000000,  # R-type instructions share opcode 0
    'addi': 0b001000,
    'lw': 0b100011,
    'sw': 0b101011
}

FUNCTION_MAP = {
    'add': 0b100000,
    'sub': 0b100010,
    'and': 0b100100,
    'or': 0b100101,
    'xor': 0b100110,
    'nor': 0b100111
}

# Register mappings
REGISTER_MAP = {
    '$zero': 0, '$0': 0,
    '$at': 1, '$1': 1,
    '$v0': 2, '$2': 2, '$v1': 3, '$3': 3,
    '$a0': 4, '$4': 4, '$a1': 5, '$5': 5, '$a2': 6, '$6': 6, '$a3': 7, '$7': 7,
    '$t0': 8, '$8': 8, '$t1': 9, '$9': 9, '$t2': 10, '$10': 10, '$t3': 11, '$11': 11,
    '$t4': 12, '$12': 12, '$t5': 13, '$13': 13, '$t6': 14, '$14': 14, '$t7': 15, '$15': 15,
    '$s0': 16, '$16': 16, '$s1': 17, '$17': 17, '$s2': 18, '$18': 18, '$s3': 19, '$19': 19,
    '$s4': 20, '$20': 20, '$s5': 21, '$21': 21, '$s6': 22, '$22': 22, '$s7': 23, '$23': 23,
    '$t8': 24, '$24': 24, '$t9': 25, '$25': 25,
    '$k0': 26, '$26': 26, '$k1': 27, '$27': 27,
    '$gp': 28, '$28': 28, '$sp': 29, '$29': 29, '$fp': 30, '$30': 30, '$ra': 31, '$31': 31
}

# Instruction set definitions
INSTRUCTION_SET = {
    "addi": {'type': 'I', 'format': ['rd', 'rs', 'imm']},
    "add": {'type': 'R', 'format': ['rd', 'rs', 'rt']},
    "sub": {'type': 'R', 'format': ['rd', 'rs', 'rt']},
    "and": {'type': 'R', 'format': ['rd', 'rs', 'rt']},
    "or": {'type': 'R', 'format': ['rd', 'rs', 'rt']},
    "xor": {'type': 'R', 'format': ['rd', 'rs', 'rt']},
    "nor": {'type': 'R', 'format': ['rd', 'rs', 'rt']},
    "lw": {'type': 'I', 'format': ['rt', 'imm(rs)']},
    "sw": {'type': 'I', 'format': ['rt', 'imm(rs)']}
}