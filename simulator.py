from memory import Memory
from register import Register
from pipeline_register import PipelineRegister
from hazard_unit import HazardUnit
from stages.if_stage import IFStage
from stages.id_stage import IDStage
from stages.ex_stage import EXStage
from stages.mem_stage import MEMStage
from stages.wb_stage import WBStage
from logger import Logger
from instruction_parser import parse_instruction

class Simulator:
    def __init__(self, program=None, data=None, max_cycles=1000, stack_pointer=None):
        # Initialize components
        self.memory = Memory()
        self.register_file = Register()
        self.logger = Logger()
        self.max_cycles = max_cycles
        
        # Initialize pipeline registers
        self.if_id_reg = PipelineRegister()
        self.id_ex_reg = PipelineRegister()
        self.ex_mem_reg = PipelineRegister()
        self.mem_wb_reg = PipelineRegister()
        
        # Initialize hazard unit
        self.hazard_unit = HazardUnit(
            self.register_file,
            self.if_id_reg,
            self.id_ex_reg,
            self.ex_mem_reg,
            self.mem_wb_reg
        )
        
        # Initialize pipeline stages
        self.if_stage = IFStage(self.memory, self.if_id_reg, self.hazard_unit)
        self.id_stage = IDStage(self.register_file, self.if_id_reg, self.id_ex_reg, self.hazard_unit)
        self.ex_stage = EXStage(self.id_ex_reg, self.ex_mem_reg, self.hazard_unit, self.register_file)
        self.mem_stage = MEMStage(self.memory, self.ex_mem_reg, self.mem_wb_reg, self.hazard_unit)
        self.wb_stage = WBStage(self.register_file, self.mem_wb_reg)
        
        # Initialize stack pointer
        if stack_pointer is None:
            stack_pointer = self.memory.STACK_POINTER_INIT
        self.register_file.write("$sp", stack_pointer)
        
        # Load program and data if provided
        if program:
            self.load_program(program)
        if data:
            self.load_data(data)
            
    def load_program(self, program):
        """
        Load program instructions into text segment memory.
        
        Args:
            program (list): List of (address, instruction) tuples
        """
        for address, instruction in program:
            # Validate address is in text segment
            if not self.memory.is_text_segment(address):
                # Adjust address to be within text segment if needed
                adjusted_address = self.memory.TEXT_START + (address % (self.memory.TEXT_END - self.memory.TEXT_START + 1))
                print(f"Warning: Address {hex(address)} is outside text segment. "
                    f"Adjusted to {hex(adjusted_address)}.")
                address = adjusted_address
                
            self.memory.store(address, instruction)
            
    def load_data(self, data):
        """
        Load data into memory, respecting segment boundaries.
        
        Args:
            data (list): List of (address, value) tuples
        """
        for address, value in data:
            # Check which segment the address belongs to and store accordingly
            if self.memory.is_static_segment(address):
                # Static segment data
                self.memory.store(address, value)
            elif self.memory.is_dynamic_segment(address):
                # Dynamic/heap segment data
                self.memory.store(address, value)
            elif self.memory.is_stack_segment(address):
                # Stack segment data
                self.memory.store(address, value)
            else:
                # Address outside any defined segment, adjust to appropriate segment
                if address < self.memory.TEXT_START:
                    # Below memory range, adjust to start of memory
                    adjusted_address = self.memory.TEXT_START
                    segment_name = "text"
                elif address <= self.memory.TEXT_END:
                    # In text segment but program load should handle this
                    print(f"Warning: Attempting to load data to text segment at {hex(address)}.")
                    continue
                elif address <= self.memory.STATIC_END:
                    # In static range (should be caught by is_static_segment)
                    adjusted_address = address
                    segment_name = "static"
                elif address <= self.memory.DYNAMIC_END:
                    # In dynamic range (should be caught by is_dynamic_segment)
                    adjusted_address = address
                    segment_name = "dynamic"
                elif address <= self.memory.STACK_END:
                    # In stack range (should be caught by is_stack_segment)
                    adjusted_address = address
                    segment_name = "stack"
                else:
                    # Above memory range, default to static segment
                    adjusted_address = self.memory.STATIC_START + (address % (self.memory.STATIC_END - self.memory.STATIC_START + 1))
                    segment_name = "static"
                    
                print(f"Warning: Address {hex(address)} is outside valid memory segments. "
                    f"Adjusted to {hex(adjusted_address)} in {segment_name} segment.")
                self.memory.store(adjusted_address, value)
            
    def run(self, verbose=False):
        """
        Run the simulation until completion or max cycles.
        
        Args:
            verbose (bool): Whether to print detailed logs
        """
        cycle_count = 0
        done = False
        
        while not done and cycle_count < self.max_cycles:
            self.logger.start_cycle()
            
            # Execute stages in reverse order to prevent overwriting
            self.execute_cycle()
            
            # Log the state after this cycle
            self.log_state()
            self.logger.end_cycle()
            
            if verbose:
                self.logger.print_cycle()
                
            cycle_count += 1
            
            # Check if we're done (no more instructions in the pipeline)
            done = self.check_completion()
            
        self.logger.print_summary()
        return cycle_count
        
    def execute_cycle(self):
        """Execute a single cycle of the pipeline."""
        # Execute stages in reverse order to avoid overwriting
        self.wb_stage.execute()
        self.mem_stage.execute()
        self.ex_stage.execute()
        self.id_stage.execute()
        self.if_stage.execute()
        
        # Update all pipeline registers at once
        self.if_id_reg.update()
        self.id_ex_reg.update()
        self.ex_mem_reg.update()
        self.mem_wb_reg.update()
        
        # Clear branch signal after it's been handled
        self.hazard_unit.clear_branch()
        
    def log_state(self):
        """Log the current state of the pipeline."""
        # Log pipeline stages
        if_stage_data = {
            "pc": self.if_stage.pc,
            "instruction": self.memory.load(self.if_stage.pc)
        }
        
        id_instr = self.if_id_reg.read("instruction")
        id_stage_data = {
            "instruction": id_instr
        }
        
        # Get register names from ID/EX for EX stage
        rs_name = self.id_ex_reg.read("rs_name")
        rt_name = self.id_ex_reg.read("rt_name")
        ex_stage_data = {
            "instruction": self.id_ex_reg.read("instruction"),
            "control": self.id_ex_reg.read("control_signals"),
            "rs_name": rs_name,
            "rs_val": self.id_ex_reg.read("rs_val"),
            "rt_name": rt_name,
            "rt_val": self.id_ex_reg.read("rt_val")
        }
        
        mem_stage_data = {
            "instruction": self.ex_mem_reg.read("instruction"),
            "control": self.ex_mem_reg.read("control_signals"),
            "alu_result": self.ex_mem_reg.read("alu_result")
        }
        
        wb_stage_data = {
            "instruction": self.mem_wb_reg.read("instruction"),
            "control": self.mem_wb_reg.read("control_signals"),
            "dest_reg": self.mem_wb_reg.read("dest_reg")
        }
        
        self.logger.log_stage("IF", if_stage_data)
        self.logger.log_stage("ID", id_stage_data)
        self.logger.log_stage("EX", ex_stage_data)
        self.logger.log_stage("MEM", mem_stage_data)
        self.logger.log_stage("WB", wb_stage_data)
        
        # Log registers
        reg_state = {}
        for name, num in self.register_file.name_to_num.items():
            reg_state[name] = self.register_file.regs[num]
        self.logger.log_registers(reg_state)
        
        # Log memory (categorize by segments)
        memory_state = {}
        
        # Add text segment entries
        text_segment = {addr: val for addr, val in self.memory.data.items() 
                       if self.memory.is_text_segment(addr)}
        
        # Add static segment entries
        static_segment = {addr: val for addr, val in self.memory.data.items() 
                         if self.memory.is_static_segment(addr)}
        
        # Add dynamic segment entries
        dynamic_segment = {addr: val for addr, val in self.memory.data.items() 
                          if self.memory.is_dynamic_segment(addr)}
        
        # Add stack segment entries
        stack_segment = {addr: val for addr, val in self.memory.data.items() 
                        if self.memory.is_stack_segment(addr)}
        
        # Combine all segments with labels
        memory_state.update({f"TEXT[{hex(addr)}]": val for addr, val in text_segment.items()})
        memory_state.update({f"STATIC[{hex(addr)}]": val for addr, val in static_segment.items()})
        memory_state.update({f"HEAP[{hex(addr)}]": val for addr, val in dynamic_segment.items()})
        memory_state.update({f"STACK[{hex(addr)}]": val for addr, val in stack_segment.items()})
        
        self.logger.log_memory(memory_state)
        
    def check_completion(self):
        """Check if the simulation is complete (no more valid instructions in the pipeline)."""
        # Check if all pipeline stages contain NOPs or invalid instructions
        id_nop = self.if_id_reg.read("instruction") == 0
        
        # Safely check control signals
        ex_control = self.id_ex_reg.read("control_signals")
        mem_control = self.ex_mem_reg.read("control_signals")
        wb_control = self.mem_wb_reg.read("control_signals")
        
        ex_nop = not isinstance(ex_control, dict) or ex_control.get("is_nop", True)
        mem_nop = not isinstance(mem_control, dict) or mem_control.get("is_nop", True)
        wb_nop = not isinstance(wb_control, dict) or wb_control.get("is_nop", True)
        
        # If PC has reached end of program and all stages are empty, we're done
        return id_nop and ex_nop and mem_nop and wb_nop