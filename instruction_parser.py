from instruction_set import (
    INSTRUCTION_SET, 
    R_TYPE_FORMAT, 
    I_TYPE_FORMAT, 
    J_TYPE_FORMAT, 
    OPCODE_MAP, 
    FUNCTION_MAP, 
    REGISTER_MAP
)

def get_register_number(reg_name):
    """Convert register name to its numeric value"""
    if reg_name in REGISTER_MAP:
        return REGISTER_MAP[reg_name]
    try:
        # Handle case when register is specified as a number
        if reg_name.startswith('$'):
            return int(reg_name[1:])
        return int(reg_name)
    except ValueError:
        raise ValueError(f"Unknown register: {reg_name}")

def parse_immediate(imm_value):
    """Parse immediate value and handle hex or decimal"""
    if isinstance(imm_value, str):
        if imm_value.startswith('0x'):
            return int(imm_value, 16)
        return int(imm_value)
    return imm_value

def format_binary(binary_value, width=32):
    """Format binary value with spaces for readability"""
    binary_str = format(binary_value, f'0{width}b')
    
    # For R-type: opcode(6) rs(5) rt(5) rd(5) shamt(5) funct(6)
    if width == 32:
        return f"{binary_str[0:6]} {binary_str[6:11]} {binary_str[11:16]} {binary_str[16:21]} {binary_str[21:26]} {binary_str[26:32]}"
    return binary_str

def instruction_to_binary(opcode, instr_type, operands):
    """Convert parsed instruction to its binary representation"""
    binary_instruction = 0
    
    if instr_type == 'R':
        # R-type: opcode(6) rs(5) rt(5) rd(5) shamt(5) funct(6)
        binary_instruction |= OPCODE_MAP['R-type'] << R_TYPE_FORMAT['opcode']['start']
        
        # Set rs, rt, rd fields
        if 'rs' in operands: # if false means its sll
            rs_value = get_register_number(operands['rs'])
            binary_instruction |= rs_value << R_TYPE_FORMAT['rs']['start']
        rt_value = get_register_number(operands['rt'])
        rd_value = get_register_number(operands['rd'])
        
        binary_instruction |= rt_value << R_TYPE_FORMAT['rt']['start']
        binary_instruction |= rd_value << R_TYPE_FORMAT['rd']['start']
        
        # Set function code
        binary_instruction |= FUNCTION_MAP[opcode]
        
    elif instr_type == 'I':
        # I-type: opcode(6) rs(5) rt(5) immediate(16)
        binary_instruction |= OPCODE_MAP[opcode] << I_TYPE_FORMAT['opcode']['start']
        
        # Handle memory operations (lw, sw) which have a different format
        if opcode in ["lw", "sw"]:
            rt_value = get_register_number(operands['rt'])
            binary_instruction |= rt_value << I_TYPE_FORMAT['rt']['start']
            
            # Parse base register
            if 'rs' in operands:
                rs_value = get_register_number(operands['rs'])
                binary_instruction |= rs_value << I_TYPE_FORMAT['rs']['start']
            
            # Parse immediate value
            if 'imm' in operands:
                imm_value = parse_immediate(operands['imm'])
                # Ensure immediate is only 16 bits (handle sign extension)
                imm_value = imm_value & 0xFFFF
                binary_instruction |= imm_value
        else:
            # Standard I-type (addi)
            rs_value = get_register_number(operands['rs'])
            rt_value = get_register_number(operands['rd'])  # Note: rd is actually rt in MIPS
            
            binary_instruction |= rs_value << I_TYPE_FORMAT['rs']['start']
            binary_instruction |= rt_value << I_TYPE_FORMAT['rt']['start']
            
            # Parse immediate value
            imm_value = parse_immediate(operands['imm'])
            # Ensure immediate is only 16 bits (handle sign extension)
            imm_value = imm_value & 0xFFFF
            binary_instruction |= imm_value
        
    return binary_instruction

def format_instruction_fields(binary_instr, instr_type):
    """Format binary instruction according to its type"""
    if instr_type == 'R':
        opcode = (binary_instr >> 26) & 0x3F
        rs = (binary_instr >> 21) & 0x1F
        rt = (binary_instr >> 16) & 0x1F
        rd = (binary_instr >> 11) & 0x1F
        shamt = (binary_instr >> 6) & 0x1F
        funct = binary_instr & 0x3F
        
        return {
            'binary': format_binary(binary_instr),
            'fields': {
                'opcode': format(opcode, '06b'),
                'rs': format(rs, '05b'),
                'rt': format(rt, '05b'),
                'rd': format(rd, '05b'),
                'shamt': format(shamt, '05b'),
                'funct': format(funct, '06b')
            },
            'registers': {
                'rs': f"${rs}",
                'rt': f"${rt}",
                'rd': f"${rd}"
            }
        }
    
    elif instr_type == 'I':
        opcode = (binary_instr >> 26) & 0x3F
        rs = (binary_instr >> 21) & 0x1F
        rt = (binary_instr >> 16) & 0x1F
        imm = binary_instr & 0xFFFF
        
        # Sign extend immediate if needed
        if imm & 0x8000:
            imm_signed = imm - 0x10000
        else:
            imm_signed = imm
            
        return {
            'binary': format_binary(binary_instr),
            'fields': {
                'opcode': format(opcode, '06b'),
                'rs': format(rs, '05b'),
                'rt': format(rt, '05b'),
                'immediate': format(imm, '016b')
            },
            'registers': {
                'rs': f"${rs}",
                'rt': f"${rt}"
            },
            'immediate': imm_signed
        }
        
    return {'binary': format_binary(binary_instr)}

def parse_instruction(instruction):
    """
    Parses a single instruction, converts to binary, and returns its components.
    Args:
        instruction (str): The instruction to parse.
    Returns:
        dict: A dictionary containing the parsed instruction details including binary representation
    """
    # Handle string or integer instruction
    if not isinstance(instruction, str):
        return None
        
    # Strip comments and empty lines
    instruction = instruction.split('#')[0].strip()
    if not instruction:
        return None
        
    # Split the instruction into parts
    parts = instruction.replace(',','').split()
    
    # Get the opcode
    opcode = parts[0]
    
    # Check if the opcode is valid
    if opcode not in INSTRUCTION_SET:
        raise ValueError(f"Invalid opcode: {opcode}")
        
    # Get the type and format of the instruction
    instr_type = INSTRUCTION_SET[opcode]['type']
    instr_format = INSTRUCTION_SET[opcode]['format']
    
    # Parse the operands based on the format
    operands = {}
    
    # Special handling for memory operations (lw, sw)
    if opcode in ["lw", "sw"] and len(parts) >= 3:
        operands["rt"] = parts[1]
        
        # Parse the address part (e.g., "0($t4)")
        addr_part = parts[2]
        operands["imm(rs)"] = addr_part
        
        # Try to extract immediate and register parts
        if "(" in addr_part and ")" in addr_part:
            imm_part = addr_part.split("(")[0].strip()
            reg_part = addr_part.split("(")[1].rstrip(")").strip()
            
            if imm_part:
                operands["imm"] = imm_part
            operands["rs"] = reg_part
    else:
        # Standard parsing for other instructions
        for i, operand in enumerate(parts[1:]):
            if i < len(instr_format):
                field_name = instr_format[i]
                operands[field_name] = operand
            else:
                raise ValueError(f"Too many operands for {opcode}: {instruction}")
    
    # Convert the instruction to binary
    binary_instr = instruction_to_binary(opcode, instr_type, operands)
    
    # Format the binary instruction according to its type
    formatted_binary = format_instruction_fields(binary_instr, instr_type)
    
    # Return all information
    return {
        'original': instruction,
        'opcode': opcode,
        'type': instr_type,
        'operands': operands,
        'binary': formatted_binary
    }