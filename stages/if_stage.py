class IFStage:
    def __init__(self, memory, if_id_reg, hazard_unit):
        self.memory = memory
        self.if_id_reg = if_id_reg
        self.hazard_unit = hazard_unit
        self.pc = 0

    def execute(self):
        """
        Execute the Instruction Fetch stage.
        Fetch instruction from memory at PC and update IF/ID register.
        """
        # Check if pipeline needs to be stalled
        if self.hazard_unit.stall_if():
            return
            
        # Fetch instruction from memory
        instruction = self.memory.load(self.pc)
        
        # Update IF/ID pipeline register
        self.if_id_reg.write("instruction", instruction)
        self.if_id_reg.write("pc", self.pc)
        
        # Update PC (handle branch predictions here if implemented)
        if self.hazard_unit.flush_if():
            self.pc = self.hazard_unit.branch_target
        else:
            self.pc += 4  # Increment PC by 4 (assuming word-aligned instructions)