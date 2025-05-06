class Register:
    def __init__(self):
        self.regs = [0] * 32  # Initialize 32 registers to 0
        self.name_to_num = {
            "$zero": 0, "$at": 1,
            "$v0": 2, "$v1": 3,
            "$a0": 4, "$a1": 5, "$a2": 6, "$a3": 7,
            "$t0": 8, "$t1": 9, "$t2": 10, "$t3": 11, "$t4": 12, "$t5": 13, "$t6": 14, "$t7": 15,
            "$s0": 16, "$s1": 17, "$s2": 18, "$s3": 19, "$s4": 20, "$s5": 21, "$s6": 22, "$s7": 23,
            "$t8": 24, "$t9": 25,
            "$sp": 29, "$ra": 31
        }
    def read(self, reg_name: str) -> int:
        """
        Reads the value of a register.
        
        Args:
            reg_name (str): The name of the register (e.g., "$t0").
        
        Returns:
            int: The value of the register.
        """
        reg = self.name_to_num[reg_name] if reg_name in self.name_to_num else None # Check if the register name is valid
        if reg is not None:
            return self.regs[reg]# If the register name is valid, return its value
        else:
            raise ValueError(f"Invalid register name: {reg_name}")# If the register name is not valid, raise an error
        
    def write(self, reg_name: str, value: int) -> None:
        """
        Writes a value to a register.
        
        Args:
            reg_name (str): The name of the register (e.g., "$t0").
            value (int): The value to write to the register.
        """
        reg = self.name_to_num[reg_name] if reg_name in self.name_to_num else None# Check if the register name is valid
        if reg is not None:
            if reg != 0: # Check if the register is $zero
                self.regs[reg] = value # write the value to the register
            else:
                raise ValueError("Cannot write to $zero register") # If the register is $zero, raise an error
        else:
            raise ValueError(f"Invalid register name: {reg_name}")# If the register name is not valid, raise an error

        