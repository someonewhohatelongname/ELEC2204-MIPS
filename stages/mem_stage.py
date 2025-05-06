class MEMStage:
    def __init__(self, memory, ex_mem_reg, mem_wb_reg, hazard_unit):
        self.memory = memory
        self.ex_mem_reg = ex_mem_reg
        self.mem_wb_reg = mem_wb_reg
        self.hazard_unit = hazard_unit

    def execute(self):
        """
        Execute the Memory stage.
        Perform memory operations and update MEM/WB register.
        """
        # Read control signals from EX/MEM register
        control_signals = self.ex_mem_reg.read("control_signals")
        
        # Check if control_signals is a dictionary
        if not isinstance(control_signals, dict):
            self.mem_wb_reg.write("control_signals", {"is_nop": True})
            return
            
        # If it's a NOP instruction, propagate it
        if control_signals.get("is_nop", True):
            self.mem_wb_reg.write("control_signals", {"is_nop": True})
            return
            
        # Get values from EX/MEM register
        alu_result = self.ex_mem_reg.read("alu_result")
        rt_val = self.ex_mem_reg.read("rt_val")
        dest_reg = self.ex_mem_reg.read("dest_reg")
        pc = self.ex_mem_reg.read("pc")
        
        # Initialize memory data (for loads)
        mem_data = 0
        
        # Perform memory operation if needed
        if control_signals.get("mem_read", False):
            # Load word
            try:
                mem_data = self.memory.load(alu_result)
            except ValueError as e:
                print(f"Memory read error at address {alu_result}: {e}")
                
        elif control_signals.get("mem_write", False):
            # Store word
            try:
                self.memory.store(alu_result, rt_val)
            except ValueError as e:
                print(f"Memory write error at address {alu_result}: {e}")
        
        # Update MEM/WB pipeline register
        self.mem_wb_reg.write("alu_result", alu_result)
        self.mem_wb_reg.write("mem_data", mem_data)
        self.mem_wb_reg.write("dest_reg", dest_reg)
        self.mem_wb_reg.write("control_signals", control_signals)
        self.mem_wb_reg.write("pc", pc)
        
        # Update hazard unit for forwarding
        if dest_reg and control_signals.get("reg_write", False):
            result_value = mem_data if control_signals.get("mem_to_reg", False) else alu_result
            self.hazard_unit.set_mem_reg_target(dest_reg, result_value)