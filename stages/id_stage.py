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
        is_nop = self.if_id_reg.read("is_nop")
        
        # Check if end of program reached
        if is_nop or not instruction:
            self.id_ex_reg.clear()
            self.id_ex_reg.write("instruction", instruction)
            self.id_ex_reg.write("pc", pc)
            self.id_ex_reg.write("control_signals", {"is_nop": True})
            return
            
        # Parse instruction
        try:
            instr_data = parse_instruction(instruction)
            if not instr_data:
                self.id_ex_reg.write("control_signals", {"is_nop": True})
                return
                
            opcode = instr_data['opcode']
            instr_type = instr_data['type']
            operands = instr_data['operands']
            binary_data = instr_data['binary']
            
        except (ValueError, TypeError):
            # Invalid instruction, treat as NOP
            self.id_ex_reg.write("control_signals", {"is_nop": True})
            return
            
        # Extract register values
        rs_val = None
        rt_val = None
        imm_val = 0
        shamt_val = 0  
        rs_name = None
        rt_name = None
        
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
            # Handle SLL instruction specifically
            if opcode == "sll":
                # SLL uses rt as source and rd as destination
                if 'rt' in operands:
                    rt_name = operands['rt']
                    rt_val = self.register_file.read(rt_name)
                
                # Get shift amount
                if 'shamt' in operands:
                    try:
                        shamt_val = int(operands['shamt'])
                    except ValueError:
                        shamt_val = 0
                
                # Destination register for writeback
                dest_reg = operands.get('rd', None)
            else:
                # For standard R-type instructions, use rd as destination register
                if 'rs' in operands:
                    rs_name = operands['rs']
                    rs_val = self.register_file.read(rs_name)
                if 'rt' in operands:
                    rt_name = operands['rt']
                    rt_val = self.register_file.read(rt_name)
                
                # Destination register for writeback
                dest_reg = operands.get('rd', None)
            
        elif instr_type == 'I':
            # Handle immediate instructions
            if 'rs' in operands:
                rs_name = operands['rs']
                rs_val = self.register_file.read(rs_name)
                
            # For I-type instructions like addi, use rd as destination
            if opcode == "addi":
                dest_reg = operands.get('rd', None)
            else:
                # For other I-type instructions, typically use rt as destination
                if 'rt' in operands:
                    rt_name = operands['rt']
                    rt_val = self.register_file.read(rt_name)
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
                        
                        # Store rs_name for base register forwarding
                        self.id_ex_reg.write("rs_name", rs_name)
                    except (IndexError, ValueError):
                        pass
                
                # For sw, handle rt register (value to store)
                if opcode == "sw" and 'rt' in operands:
                    rt_name = operands['rt']
                    rt_val = self.register_file.read(rt_name)
                    self.id_ex_reg.write("rt_name", rt_name)
                    self.id_ex_reg.write("rt_val", rt_val)
                    dest_reg = None  # No destination register for sw
                
                # For lw, handle rt register (destination)
                elif opcode == "lw" and 'rt' in operands:
                    rt_name = operands['rt']
                    dest_reg = rt_name

        # Check for hazards and update hazard unit
        if dest_reg:
            self.hazard_unit.set_id_reg_target(dest_reg)
        
        # Update ID/EX pipeline register
        self.id_ex_reg.write("instruction", instruction)  # Propagate instruction text
        self.id_ex_reg.write("rs_val", rs_val)
        self.id_ex_reg.write("rt_val", rt_val)
        self.id_ex_reg.write("imm_val", imm_val)
        self.id_ex_reg.write("shamt_val", shamt_val)  # Add shift amount for SLL
        self.id_ex_reg.write("dest_reg", dest_reg)
        self.id_ex_reg.write("control_signals", control_signals)
        self.id_ex_reg.write("pc", pc)
        
        # Pass register names for forwarding
        if rs_name:
            self.id_ex_reg.write("rs_name", rs_name)
        if rt_name:
            self.id_ex_reg.write("rt_name", rt_name)
            
        # Store binary representation
        self.id_ex_reg.write("binary_data", binary_data)
    
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
            "sll": "SLL",  
            "lw": "ADD",   
            "sw": "ADD"    
        }
        return alu_operations.get(opcode, "ADD")