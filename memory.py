class Memory:
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
        if address % 4 != 0:# Check if the address is aligned to 4 bytes
            raise ValueError("Memory address is not aligned to 4 bytes")  
        return self.data.get(address, 0) # Return 0 if the address is not found in memory
    
    def store(self, address: int, value: int) -> None:
        """
        Stores a value in memory at the specified address.
        
        Args:
            address (int): The memory address to store the value at.
            value (int): The value to store.
        """
        if address % 4 != 0:
            raise ValueError("Memory address is not aligned to 4 bytes")
        self.data[address] = value
        