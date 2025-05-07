class Memory:
    # Memory layout constants
    INSTR_START = 0x0000
    INSTR_END = 0x0FFF
    DATA_START = 0x1000
    DATA_END = 0x3FFF
    MEM_SIZE = 0x4000  # 16 KB total (0x4000 bytes)

    def __init__(self):
        self.data = {}  # Initialize an empty dictionary to represent memory

    def load(self, address: int) -> int:
        """
        Loads a value from memory at the specified address.
        
        Args:
            address (int): The memory address to load from.
        
        Returns:
            int: The value at the specified memory address.
        """
        # Validate address
        self._check_address_alignment(address)
        self._check_address_range(address)
        
        # Return 0 if the address is not found in memory
        return self.data.get(address, 0)
    
    def store(self, address: int, value: int) -> None:
        """
        Stores a value in memory at the specified address.
        
        Args:
            address (int): The memory address to store the value at.
            value (int): The value to store.
        """
        # Validate address
        self._check_address_alignment(address)
        self._check_address_range(address)
        
        # Check if this is an instruction memory write attempt
        if self.is_instruction_memory(address):
            # For a real system, we might want to prevent writes to instruction memory
            # during execution, but for simulation purposes, we'll allow it
            pass
            
        self.data[address] = value
    
    def is_instruction_memory(self, address: int) -> bool:
        """
        Checks if the address is in the instruction memory region.
        
        Args:
            address (int): The memory address to check.
            
        Returns:
            bool: True if the address is in instruction memory, False otherwise.
        """
        return self.INSTR_START <= address <= self.INSTR_END
    
    def is_data_memory(self, address: int) -> bool:
        """
        Checks if the address is in the data memory region.
        
        Args:
            address (int): The memory address to check.
            
        Returns:
            bool: True if the address is in data memory, False otherwise.
        """
        return self.DATA_START <= address <= self.DATA_END
    
    def _check_address_alignment(self, address: int) -> None:
        """
        Checks if the address is aligned to 4 bytes (word aligned).
        
        Args:
            address (int): The memory address to check.
            
        Raises:
            ValueError: If the address is not word-aligned.
        """
        if address % 4 != 0:
            raise ValueError(f"Memory address {hex(address)} is not aligned to 4 bytes")
    
    def _check_address_range(self, address: int) -> None:
        """
        Checks if the address is within the valid memory range.
        
        Args:
            address (int): The memory address to check.
            
        Raises:
            ValueError: If the address is outside the valid memory range.
        """
        if not (self.INSTR_START <= address <= self.DATA_END):
            raise ValueError(f"Memory address {hex(address)} is outside the valid range " 
                            f"({hex(self.INSTR_START)}-{hex(self.DATA_END)})")