from instruction_set import REGISTER_MAP

class Register:
    def __init__(self):
        self.regs = [0] * 32  # Initialize 32 registers to 0
        self.name_to_num = REGISTER_MAP  # Use the centralized register mapping
        
    def read(self, reg_name: str) -> int:
        """
        Reads the value of a register.
        
        Args:
            reg_name (str): The name of the register (e.g., "$t0").
        
        Returns:
            int: The value of the register.
        """
        if reg_name in self.name_to_num:
            return self.regs[self.name_to_num[reg_name]]
        raise ValueError(f"Invalid register name: {reg_name}")
        
    def write(self, reg_name: str, value: int) -> None:
        """
        Writes a value to a register.
        
        Args:
            reg_name (str): The name of the register (e.g., "$t0").
            value (int): The value to write to the register.
        """
        if reg_name in self.name_to_num:
            reg_num = self.name_to_num[reg_name]
            if reg_num != 0:  # Check if the register is $zero
                self.regs[reg_num] = value
            else:
                raise ValueError("Cannot write to $zero register")
        else:
            raise ValueError(f"Invalid register name: {reg_name}")