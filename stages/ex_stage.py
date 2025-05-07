class EXStage:
    def __init__(self, id_ex_reg, ex_mem_reg, hazard_unit):
        self.id_ex_reg = id_ex_reg
        self.ex_mem_reg = ex_mem_reg
        self.hazard_unit = hazard_unit

    def execute(self):
        """
        Execute the Execution stage.
        Perform ALU operations and update EX/MEM register.
        """
        # Read control signals from ID/EX register
        control_signals = self.id_ex_reg.read("control_signals")
        
        # If it's a NOP instruction, propagate it
        if not isinstance(control_signals, dict) or control_signals.get("is_nop", True):
            self.ex_mem_reg.write("control_signals", {"is_nop": True})
            return
            
        # Get operands from ID/EX register
        rs_val = self.id_ex_reg.read("rs_val")
        rt_val = self.id_ex_reg.read("rt_val")
        imm_val = self.id_ex_reg.read("imm_val")
        dest_reg = self.id_ex_reg.read("dest_reg")
        pc = self.id_ex_reg.read("pc")
        
        # Apply forwarding if necessary
        rs_val = self.hazard_unit.forward_a(rs_val)
        rt_val = self.hazard_unit.forward_b(rt_val)
        
        # Perform ALU operation
        alu_op = control_signals.get("alu_op", "ADD")
        result = self._alu_execute(alu_op, rs_val, rt_val, imm_val)
        
        # Update EX/MEM pipeline register
        self.ex_mem_reg.write("alu_result", result)
        self.ex_mem_reg.write("rt_val", rt_val)  # Store value for memory operations
        self.ex_mem_reg.write("dest_reg", dest_reg)
        self.ex_mem_reg.write("control_signals", control_signals)
        self.ex_mem_reg.write("pc", pc)
        
        # Update hazard unit for forwarding
        if dest_reg and control_signals.get("reg_write", False):
            self.hazard_unit.set_ex_reg_target(dest_reg, result)
        
    def _alu_execute(self, alu_op, rs_val, rt_val, imm_val):
        """
        Execute the ALU operation.
        """
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
        else:
            return 0  # Default case