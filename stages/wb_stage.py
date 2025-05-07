class WBStage:
    def __init__(self, register_file, mem_wb_reg):
        self.register_file = register_file
        self.mem_wb_reg = mem_wb_reg

    def execute(self):
        """
        Execute the Write Back stage.
        Write result back to register file.
        """
        # Read control signals from MEM/WB register
        control_signals = self.mem_wb_reg.read("control_signals")
        
        # Check if control_signals is a dictionary
        if not isinstance(control_signals, dict):
            return
            
        # If it's a NOP instruction or no register write needed, return
        if control_signals.get("is_nop", True) or not control_signals.get("reg_write", False):
            return
            
        # Get values from MEM/WB register
        alu_result = self.mem_wb_reg.read("alu_result")
        mem_data = self.mem_wb_reg.read("mem_data")
        dest_reg = self.mem_wb_reg.read("dest_reg")
        
        # Determine what to write back
        write_data = mem_data if control_signals.get("mem_to_reg", False) else alu_result
        
        # Write back to register file
        if dest_reg:
            try:
                self.register_file.write(dest_reg, write_data)
                print(f"Register write: {dest_reg} = {write_data}")  # Debug print
            except ValueError as e:
                print(f"Register write error to {dest_reg}: {e}")