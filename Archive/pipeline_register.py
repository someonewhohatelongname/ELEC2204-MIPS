class PipelineRegister:
    def __init__(self):
        self.data = {}
        self.next_data = {}

    def write(self, key: str, value: int) -> None:
        """
        Writes a value to the pipeline register.
        
        Args:
            key (str): The key to write to.
            value (int): The value to write.
        """
        self.next_data[key] = value

    def read(self, key: str) -> int:
        """
        Reads a value from the pipeline register.
        
        Args:
            key (str): The key to read from.
        
        Returns:
            int: The value at the specified key.
        """
        return self.data.get(key, {})  # Return 0 if the key is not found
    
    def update(self) -> None:
        """
        Updates the pipeline register with the next data.
        """
        self.data.update(self.next_data)
        self.next_data = {}

    def clear(self) -> None:
        """
        Clears the pipeline register.
        """
        self.data = {}
        self.next_data = {}