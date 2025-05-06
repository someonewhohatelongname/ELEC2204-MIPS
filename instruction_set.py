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