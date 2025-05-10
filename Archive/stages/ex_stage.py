class EXStage:
    def __init__(self, id_ex_reg, ex_mem_reg, hazard_unit, register_file):
        self.id_ex_reg = id_ex_reg
        self.ex_mem_reg = ex_mem_reg
        self.hazard_unit = hazard_unit
        self.register_file = register_file  # Add register file to access register values

    def execute(self):
        """
        Execute the Execution stage.
        Perform ALU operations and update EX/MEM register.
        """
        # Read control signals from ID/EX register
        control_signals = self.id_ex_reg.read("control_signals")
        
        # If it's a NOP instruction or invalid control signals, propagate NOP
        if not control_signals or control_signals.get("is_nop", True):
            self.ex_mem_reg.clear()
            self.ex_mem_reg.write("instruction", None)
            self.ex_mem_reg.write("control_signals", {"is_nop": True})
            return
            
        # Get operands from ID/EX register
        rs_val = self.id_ex_reg.read("rs_val")
        rt_val = self.id_ex_reg.read("rt_val")
        imm_val = self.id_ex_reg.read("imm_val")
        shamt_val = self.id_ex_reg.read("shamt_val")
        dest_reg = self.id_ex_reg.read("dest_reg")
        pc = self.id_ex_reg.read("pc")
        instruction = self.id_ex_reg.read("instruction")
        
        # Get register names if available
        rs_name = self.id_ex_reg.read("rs_name")
        rt_name = self.id_ex_reg.read("rt_name")
        
        # If we have register names but no values, look up the values
        if rs_name and not rs_val and isinstance(rs_name, str):
            try:
                rs_val = self.register_file.read(rs_name)
            except ValueError:
                rs_val = 0
                
        if rt_name and not rt_val and isinstance(rt_name, str):
            try:
                rt_val = self.register_file.read(rt_name)
            except ValueError:
                rt_val = 0
        
        # Apply forwarding if necessary
        # CRITICAL: Always apply forwarding to rs_val which is used for base address
        rs_val = self.hazard_unit.forward_a(rs_val)
        rt_val = self.hazard_unit.forward_b(rt_val)
        
        # Perform ALU operation
        alu_op = control_signals.get("alu_op", "ADD")
        result = self._alu_execute(alu_op, rs_val, rt_val, imm_val, shamt_val)

        
        # Update EX/MEM pipeline register
        self.ex_mem_reg.write("alu_result", result)
        self.ex_mem_reg.write("rt_val", rt_val)  # Store value for memory operations
        self.ex_mem_reg.write("dest_reg", dest_reg)
        self.ex_mem_reg.write("control_signals", control_signals)
        self.ex_mem_reg.write("pc", pc)
        self.ex_mem_reg.write("instruction", instruction)  # Pass instruction for logging
        
        # Forward register names for debugging
        if rs_name:
            self.ex_mem_reg.write("rs_name", rs_name)
            self.ex_mem_reg.write("rs_val", rs_val)
        if rt_name:
            self.ex_mem_reg.write("rt_name", rt_name)
        
        # Update hazard unit for forwarding
        if dest_reg and control_signals.get("reg_write", False):
            self.hazard_unit.set_ex_reg_target(dest_reg, result)
        
    def _alu_execute(self, alu_op, rs_val, rt_val, imm_val, shamt_val=None):
        """
        Execute the ALU operation.
        """
        # Ensure operands are integers
        try:
            rs_val = int(rs_val) if rs_val is not None else 0
            rt_val = int(rt_val) if rt_val is not None else 0
            imm_val = int(imm_val) if imm_val is not None else 0
            shamt_val = int(shamt_val) if shamt_val is not None else 0
        except (ValueError, TypeError):
            # If conversion fails, use default values
            rs_val = 0
            rt_val = 0
            imm_val = 0
            shamt_val = 0
            
        if alu_op == "ADD":
            # For load/store, add immediate value to base register
            if self.id_ex_reg.read("control_signals").get("mem_read") or \
               self.id_ex_reg.read("control_signals").get("mem_write"):
                return rs_val + imm_val
            # For addi, add immediate to rs
            elif self.id_ex_reg.read("control_signals").get("opcode") == "addi":
                return rs_val + imm_val
            # For add, add rs and rt
            else:
                return rs_val + rt_val
        elif alu_op == "SUB":
            return rs_val - rt_val
        elif alu_op == "AND":
            return rs_val & rt_val
        elif alu_op == "OR":
            return rs_val | rt_val
        elif alu_op == "XOR":
            return rs_val ^ rt_val
        elif alu_op == "NOR":
            return ~(rs_val | rt_val)
        elif alu_op == "SLL":
            # Shift left logical operation
            return rt_val << shamt_val
        else:
            return 0  # Default case