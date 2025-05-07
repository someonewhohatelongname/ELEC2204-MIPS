class IFStage:
    def __init__(self, memory, if_id_reg, hazard_unit):
        self.memory = memory
        self.if_id_reg = if_id_reg
        self.hazard_unit = hazard_unit
        self.pc = self.memory.TEXT_START  # Initialize PC to start of text segment
        self.program_done = False  # Flag to indicate end of program

    def execute(self):
        """
        Execute the Instruction Fetch stage.
        Fetch instruction from memory at PC and update IF/ID register.
        """
        # If program is done, propagate NOP
        if self.program_done:
            self.if_id_reg.write("instruction", None)
            self.if_id_reg.write("is_nop", True)
            return
            
        # Check if pipeline needs to be stalled
        if self.hazard_unit.stall_if():
            return
            
        # Check if PC is within text segment
        if not self.memory.is_text_segment(self.pc):
            print(f"Warning: PC {hex(self.pc)} is outside text segment range.")
            # Program has reached the end
            self.program_done = True
            self.if_id_reg.write("instruction", None)
            self.if_id_reg.write("is_nop", True)
            return
        
        # Fetch instruction from memory
        instruction = self.memory.load(self.pc)
        
        # Update IF/ID pipeline register
        self.if_id_reg.write("instruction", instruction)
        self.if_id_reg.write("pc", self.pc)
        self.if_id_reg.write("is_nop", False)
        
        # Update PC (handle branch predictions here if implemented)
        if self.hazard_unit.flush_if():
            self.pc = self.hazard_unit.branch_target
            # Ensure PC is within text segment bounds
            if not self.memory.is_text_segment(self.pc):
                print(f"Warning: Branch target {hex(self.pc)} is outside text segment!")
                self.program_done = True
        else:
            self.pc += 4  # Increment PC by 4 (assuming word-aligned instructions)
            # Check if PC has reached end of text segment
            if self.pc > self.memory.TEXT_END:
                print(f"Reached end of text segment at PC={hex(self.pc)}")
                self.program_done = True