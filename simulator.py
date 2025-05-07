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

class Simulator:
    def __init__(self, program=None, data=None, max_cycles=1000):
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
        # Pass register_file to EXStage
        self.ex_stage = EXStage(self.id_ex_reg, self.ex_mem_reg, self.hazard_unit, self.register_file)
        self.mem_stage = MEMStage(self.memory, self.ex_mem_reg, self.mem_wb_reg, self.hazard_unit)
        self.wb_stage = WBStage(self.register_file, self.mem_wb_reg)
        
        # Load program and data if provided
        if program:
            self.load_program(program)
        if data:
            self.load_data(data)
            
    def load_program(self, program):
        """
        Load program instructions into memory.
        
        Args:
            program (list): List of (address, instruction) tuples
        """
        for address, instruction in program:
            self.memory.store(address, instruction)
            
    def load_data(self, data):
        """
        Load data into memory.
        
        Args:
            data (list): List of (address, value) tuples
        """
        for address, value in data:
            self.memory.store(address, value)
            
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
        if_stage_data = {"pc": self.if_stage.pc}
        id_stage_data = {"instruction": self.if_id_reg.read("instruction")}
        ex_stage_data = {
            "control": self.id_ex_reg.read("control_signals"),
            "rs_val": self.id_ex_reg.read("rs_val"),
            "rt_val": self.id_ex_reg.read("rt_val")
        }
        mem_stage_data = {
            "control": self.ex_mem_reg.read("control_signals"),
            "alu_result": self.ex_mem_reg.read("alu_result")
        }
        wb_stage_data = {
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
        
        # Log memory
        self.logger.log_memory(self.memory.data)
        
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