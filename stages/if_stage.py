class IFStage:
    def __init__(self, memory, if_id_reg, hazard_unit):
        self.memory = memory
        self.if_id_reg = if_id_reg
        self.hazard_unit = hazard_unit
        self.pc = self.memory.INSTR_START  # Initialize PC to start of instruction memory

    def execute(self):
        """
        Execute the Instruction Fetch stage.
        Fetch instruction from memory at PC and update IF/ID register.
        """
        # Check if pipeline needs to be stalled
        if self.hazard_unit.stall_if():
            return
            
        # Check if PC is within instruction memory range
        if not self.memory.is_instruction_memory(self.pc):
            print(f"Warning: PC {hex(self.pc)} is outside instruction memory range.")
            # In a real system, this might cause an exception
            # For simulation, we'll either wrap around or stop
            if self.pc > self.memory.INSTR_END:
                # Reached end of instruction memory, stop fetching
                self.if_id_reg.write("instruction", 0)  # NOP
                return
        
        # Fetch instruction from memory
        instruction = self.memory.load(self.pc)
        
        # Update IF/ID pipeline register
        self.if_id_reg.write("instruction", instruction)
        self.if_id_reg.write("pc", self.pc)
        
        # Update PC (handle branch predictions here if implemented)
        if self.hazard_unit.flush_if():
            self.pc = self.hazard_unit.branch_target
            # Ensure PC is within instruction memory bounds
            if not self.memory.is_instruction_memory(self.pc):
                print(f"Warning: Branch target {hex(self.pc)} is outside instruction memory!")
                # Adjust PC to be within instruction memory range
                self.pc = self.memory.INSTR_START + (self.pc % (self.memory.INSTR_END - self.memory.INSTR_START + 1))
        else:
            self.pc += 4  # Increment PC by 4 (assuming word-aligned instructions)
            # Check if PC has reached end of instruction memory
            if self.pc > self.memory.INSTR_END:
                print(f"Reached end of instruction memory at PC={hex(self.pc)}")