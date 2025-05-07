from instruction_parser import parse_instruction
class HazardUnit:
    def __init__(self, register_file, if_id_reg, id_ex_reg, ex_mem_reg, mem_wb_reg):
        self.register_file = register_file
        self.if_id_reg = if_id_reg
        self.id_ex_reg = id_ex_reg
        self.ex_mem_reg = ex_mem_reg
        self.mem_wb_reg = mem_wb_reg
        
        # For forwarding
        self.ex_forwarding_reg = None
        self.ex_forwarding_value = 0
        self.mem_forwarding_reg = None
        self.mem_forwarding_value = 0
        
        # For branch handling
        self.branch_target = 0
        self.branch_taken = False
        
        # Stall signals
        self.stall_pipeline = False
        self.id_reg_target = None  # Target register being written in ID stage
        
    def set_id_reg_target(self, reg_name):
        """Set the target register for the ID stage"""
        self.id_reg_target = reg_name
        
    def set_ex_reg_target(self, reg_name, value):
        """Set the target register and value for forwarding from EX stage"""
        if reg_name and isinstance(reg_name, str):
            self.ex_forwarding_reg = reg_name
            self.ex_forwarding_value = value
        
    def set_mem_reg_target(self, reg_name, value):
        """Set the target register and value for forwarding from MEM stage"""
        if reg_name and isinstance(reg_name, str):
            self.mem_forwarding_reg = reg_name
            self.mem_forwarding_value = value
        
    def _forward_value(self, reg_name, original_value):
        """Generic forwarding logic for both rs and rt"""
        if not reg_name or not isinstance(reg_name, str):
            return original_value
            
        # Forward from MEM stage (priority over EX)
        if self.mem_forwarding_reg == reg_name:
            return self.mem_forwarding_value
            
        # Forward from EX stage
        if self.ex_forwarding_reg == reg_name:
            return self.ex_forwarding_value
            
        return original_value
        
    def forward_a(self, original_value):
        """Forward value A (rs) if needed"""
        return self._forward_value(self.id_ex_reg.read("rs_name"), original_value)
        
    def forward_b(self, original_value):
        """Forward value B (rt) if needed"""
        return self._forward_value(self.id_ex_reg.read("rt_name"), original_value)
        
    def detect_data_hazards(self):
        """Detect data hazards that require stalling"""
        control_signals = self.id_ex_reg.read("control_signals")
        
        # If control_signals is not a dictionary, there's no instruction in EX stage
        if not isinstance(control_signals, dict):
            return False
        
        # If a load instruction is in EX stage and its destination is used in ID stage,
        # we need to stall for one cycle (load-use hazard)
        if control_signals.get("mem_read", False):
            dest_reg = self.id_ex_reg.read("dest_reg")
            if dest_reg and isinstance(dest_reg, str):
                # Get potential source registers from ID stage
                if_id_instr = self.if_id_reg.read("instruction")
                if if_id_instr and isinstance(if_id_instr, str):
                    try:
                        opcode, instr_type, operands = parse_instruction(if_id_instr)
                        
                        # Check if ID stage uses this register as a source
                        for reg_field, reg_name in operands.items():
                            if reg_field in ['rs', 'rt'] and reg_name == dest_reg:
                                return True
                    except (ValueError, TypeError, AttributeError):
                        pass
                        
                # Check if ID stage uses this register (fallback method)
                if dest_reg == self.id_reg_target:
                    return True
        return False
        
    def stall_if(self):
        """Check if IF stage should be stalled"""
        return self.stall_pipeline or self.detect_data_hazards()
        
    def stall_id(self):
        """Check if ID stage should be stalled"""
        return self.stall_pipeline or self.detect_data_hazards()
        
    def flush_if(self):
        """Check if IF stage should be flushed (branch taken)"""
        return self.branch_taken
        
    def flush_id(self):
        """Check if ID stage should be flushed (branch taken)"""
        return self.branch_taken
        
    def take_branch(self, target):
        """Signal that a branch should be taken"""
        self.branch_taken = True
        self.branch_target = target
        
    def clear_branch(self):
        """Clear branch signal after it's been handled"""
        self.branch_taken = False