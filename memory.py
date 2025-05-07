class Memory:
    # Total memory size: 16KB (4096 words)
    MEM_SIZE = 0x4000  # 16KB total (0x4000 bytes)
    
    # Memory layout constants
    TEXT_START = 0x0000      # Text (code) segment: 0x0000 - 0x0FFF (4KB)
    TEXT_END = 0x0FFF
    
    STATIC_START = 0x1000    # Static data segment: 0x1000 - 0x1FFF (4KB)
    STATIC_END = 0x1FFF
    
    DYNAMIC_START = 0x2000   # Dynamic (heap) segment: 0x2000 - 0x2FFF (4KB)
    DYNAMIC_END = 0x2FFF
    
    STACK_START = 0x3000     # Stack segment: 0x3000 - 0x3FFF (4KB)
    STACK_END = 0x3FFF
    STACK_POINTER_INIT = STACK_END  # Stack grows downward

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
        
        # Store the value
        self.data[address] = value
    
    def is_text_segment(self, address: int) -> bool:
        """
        Checks if the address is in the text (code) segment.
        
        Args:
            address (int): The memory address to check.
            
        Returns:
            bool: True if the address is in text segment, False otherwise.
        """
        return self.TEXT_START <= address <= self.TEXT_END
    
    def is_static_segment(self, address: int) -> bool:
        """
        Checks if the address is in the static data segment.
        
        Args:
            address (int): The memory address to check.
            
        Returns:
            bool: True if the address is in static data segment, False otherwise.
        """
        return self.STATIC_START <= address <= self.STATIC_END
    
    def is_dynamic_segment(self, address: int) -> bool:
        """
        Checks if the address is in the dynamic (heap) segment.
        
        Args:
            address (int): The memory address to check.
            
        Returns:
            bool: True if the address is in dynamic segment, False otherwise.
        """
        return self.DYNAMIC_START <= address <= self.DYNAMIC_END
    
    def is_stack_segment(self, address: int) -> bool:
        """
        Checks if the address is in the stack segment.
        
        Args:
            address (int): The memory address to check.
            
        Returns:
            bool: True if the address is in stack segment, False otherwise.
        """
        return self.STACK_START <= address <= self.STACK_END
    
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
        if not (self.TEXT_START <= address <= self.STACK_END):
            raise ValueError(f"Memory address {hex(address)} is outside the valid range " 
                            f"({hex(self.TEXT_START)}-{hex(self.STACK_END)})")