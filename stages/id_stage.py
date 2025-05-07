from instruction_parser import parse_instruction

class IDStage:
    def __init__(self, register_file, if_id_reg, id_ex_reg, hazard_unit):
        self.register_file = register_file
        self.if_id_reg = if_id_reg
        self.id_ex_reg = id_ex_reg
        self.hazard_unit = hazard_unit

    def execute(self):
        """
        Execute the Instruction Decode stage.
        Decode instruction, read register values, and update ID/EX register.
        """
        # Check if stage should be stalled
        if self.hazard_unit.stall_id():
            return
        
        # Check if stage should be flushed (branch taken)
        if self.hazard_unit.flush_id():
            self.id_ex_reg.clear()
            return
            
        # Get instruction from IF/ID register
        instruction = self.if_id_reg.read("instruction")
        pc = self.if_id_reg.read("pc")
        
        # No instruction to decode
        if not instruction:
            self.id_ex_reg.write("control_signals", {"is_nop": True})
            return
            
        # Parse instruction
        try:
            opcode, instr_type, operands = parse_instruction(instruction)
        except (ValueError, TypeError):
            # Invalid instruction, treat as NOP
            self.id_ex_reg.write("control_signals", {"is_nop": True})
            return
            
        # Extract register values
        rs_val = 0
        rt_val = 0
        imm_val = 0
        
        # Set up control signals
        control_signals = {
            "opcode": opcode,
            "alu_op": self._get_alu_op(opcode),
            "mem_read": opcode == "lw",
            "mem_write": opcode == "sw",
            "reg_write": opcode not in ["sw"],
            "mem_to_reg": opcode == "lw",
            "is_nop": False
        }
        
        # Get source register values based on instruction type
        if instr_type == 'R':
            # For R-type instructions, use rd as destination register
            if 'rs' in operands:
                rs_val = self.register_file.read(operands['rs'])
            if 'rt' in operands:
                rt_val = self.register_file.read(operands['rt'])
            
            # Destination register for writeback
            dest_reg = operands.get('rd', None)
            
        elif instr_type == 'I':
            # Handle immediate instructions
            if 'rs' in operands:
                rs_val = self.register_file.read(operands['rs'])
                
            # For I-type instructions like addi, use rd as destination
            if opcode == "addi":
                dest_reg = operands.get('rd', None)
            else:
                # For other I-type instructions, typically use rt as destination
                dest_reg = operands.get('rt', None)
                
            # Parse immediate value
            if 'imm' in operands:
                try:
                    imm_val = int(operands['imm'])
                except ValueError:
                    imm_val = 0
                    
            # Handle memory operations (lw/sw)
            if opcode in ["lw", "sw"]:
                # Parse memory offset format like "100($t0)"
                mem_op = operands.get('imm(rs)', '')
                if mem_op:
                    # Extract immediate value and register
                    try:
                        imm_str = mem_op.split('(')[0]
                        rs_name = mem_op.split('(')[1].rstrip(')')
                        imm_val = int(imm_str) if imm_str else 0
                        rs_val = self.register_file.read(rs_name)
                    except (IndexError, ValueError):
                        # Invalid format, use default values
                        pass
        
        # Check for hazards and update hazard unit
        if dest_reg:
            self.hazard_unit.set_id_reg_target(dest_reg)
        
        # Update ID/EX pipeline register
        self.id_ex_reg.write("rs_val", rs_val)
        self.id_ex_reg.write("rt_val", rt_val)
        self.id_ex_reg.write("imm_val", imm_val)
        self.id_ex_reg.write("dest_reg", dest_reg)
        self.id_ex_reg.write("control_signals", control_signals)
        self.id_ex_reg.write("pc", pc)
        
        # Pass register names for forwarding
        if 'rs' in operands:
            self.id_ex_reg.write("rs_name", operands['rs'])
        if 'rt' in operands:
            self.id_ex_reg.write("rt_name", operands['rt'])
    
    def _get_alu_op(self, opcode):
        """
        Determine ALU operation based on opcode.
        """
        alu_operations = {
            "add": "ADD",
            "addi": "ADD",
            "sub": "SUB",
            "and": "AND",
            "or": "OR",
            "xor": "XOR",
            "nor": "NOR",
            "lw": "ADD",  # Address calculation
            "sw": "ADD"   # Address calculation
        }
        return alu_operations.get(opcode, "ADD")