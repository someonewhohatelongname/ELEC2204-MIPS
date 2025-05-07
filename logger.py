class Logger:
    def __init__(self, log_file="log.txt"):
        self.log_data = []
        self.cycle = 0
        self.log_file_path = log_file
        # Clear previous log file content
        with open(self.log_file_path, "w") as f:
            f.write("")

    def _log(self, message):
        """Prints to terminal and appends to log file"""
        print(message)
        with open(self.log_file_path, "a") as f:
            f.write(message + "\n")

    def start_cycle(self):
        self.cycle += 1
        self.current_cycle_log = {
            "cycle": self.cycle,
            "stages": {},
            "registers": {},
            "memory": {}
        }

    def log_stage(self, stage_name, data):
        self.current_cycle_log["stages"][stage_name] = data

    def log_registers(self, registers):
        self.current_cycle_log["registers"] = registers

    def log_memory(self, memory):
        self.current_cycle_log["memory"] = memory

    def end_cycle(self):
        self.log_data.append(self.current_cycle_log)

    def print_cycle(self, cycle_num=None):
        if cycle_num is None:
            cycle_num = self.cycle

        if cycle_num <= 0 or cycle_num > len(self.log_data):
            self._log(f"Invalid cycle number: {cycle_num}")
            return

        cycle_log = self.log_data[cycle_num - 1]
        self._log(f"===== Cycle {cycle_log['cycle']} =====")

        self._log("\nPipeline Stages:")
        for stage, data in cycle_log["stages"].items():
            self._log(f"  {stage}:")
            
            # Print instruction for each stage if available
            if "instruction" in data:
                self._log(f"    Instruction: {data['instruction']}")
                
            # Special handling for register values to show names and values
            if "rs_name" in data and "rs_val" in data:
                self._log(f"    RS: {data['rs_name']} = {data['rs_val']}")
            if "rt_name" in data and "rt_val" in data:
                self._log(f"    RT: {data['rt_name']} = {data['rt_val']}")
                
            # Print other stage data
            for key, value in data.items():
                if key not in ["instruction", "rs_name", "rs_val", "rt_name", "rt_val"]:
                    self._log(f"    {key}: {value}")

        self._log("\nRegisters:")
        for reg, value in cycle_log["registers"].items():
            if value != 0:
                self._log(f"  {reg}: {value}")

        self._log("\nMemory:")
        for addr, value in cycle_log["memory"].items():
            self._log(f"  {addr}: {value}")

        self._log("=" * 30)

    def print_summary(self):
        self._log(f"\n===== Summary ({self.cycle} cycles) =====")
        last_cycle = self.log_data[-1]

        self._log("\nFinal Register State:")
        for reg, value in last_cycle["registers"].items():
            if value != 0:
                self._log(f"  {reg}: {value}")

        self._log("\nFinal Memory State:")
        for addr, value in last_cycle["memory"].items():
            self._log(f"  {addr}: {value}")