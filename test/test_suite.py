import unittest
import sys
import os

# Add the parent directory to sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from memory import Memory
from register import Register
from pipeline_register import PipelineRegister
from instruction_parser import parse_instruction
from simulator import Simulator

class TestMemory(unittest.TestCase):
    def setUp(self):
        self.memory = Memory()
        
    def test_store_load(self):
        self.memory.store(0, 123)
        self.assertEqual(self.memory.load(0), 123)
        
    def test_unaligned_access(self):
        with self.assertRaises(ValueError):
            self.memory.store(1, 123)
        with self.assertRaises(ValueError):
            self.memory.load(1)
            
class TestRegisterFile(unittest.TestCase):
    def setUp(self):
        self.reg = Register()
        
    def test_register_access(self):
        self.reg.write("$t0", 123)
        self.assertEqual(self.reg.read("$t0"), 123)
        
    def test_zero_register(self):
        with self.assertRaises(ValueError):
            self.reg.write("$zero", 123)
        self.assertEqual(self.reg.read("$zero"), 0)
        
    def test_invalid_register(self):
        with self.assertRaises(ValueError):
            self.reg.read("$invalid")
        with self.assertRaises(ValueError):
            self.reg.write("$invalid", 123)
            
class TestPipelineRegister(unittest.TestCase):
    def setUp(self):
        self.pipe_reg = PipelineRegister()
        
    def test_read_write(self):
        self.pipe_reg.write("test", 123)
        self.pipe_reg.update()
        self.assertEqual(self.pipe_reg.read("test"), 123)
        
    def test_clear(self):
        self.pipe_reg.write("test", 123)
        self.pipe_reg.update()
        self.pipe_reg.clear()
        self.assertEqual(self.pipe_reg.read("test"), 0)
        
class TestInstructionParser(unittest.TestCase):
    def test_r_type(self):
        opcode, instr_type, operands = parse_instruction("add $t0, $t1, $t2")
        self.assertEqual(opcode, "add")
        self.assertEqual(instr_type, "R")
        self.assertEqual(operands, {"rt": "$t0", "rs": "$t1", "rt": "$t2"})
        
    def test_i_type_addi(self):
        opcode, instr_type, operands = parse_instruction("addi $t0, $t1, 123")
        self.assertEqual(opcode, "addi")
        self.assertEqual(instr_type, "I")
        self.assertEqual(operands, {"rd": "$t0", "rs": "$t1", "imm": "123"})
        
    def test_i_type_memory(self):
        opcode, instr_type, operands = parse_instruction("lw $t0, 8($t1)")
        self.assertEqual(opcode, "lw")
        self.assertEqual(instr_type, "I")
        self.assertEqual(operands, {"rt": "$t0", "imm(rs)": "8($t1)"})
        
class TestSimulator(unittest.TestCase):
    def test_simple_program(self):
        # Simple program to add two numbers
        program = [
            (0, "addi $t0, $zero, 5"),  # $t0 = 5
            (4, "addi $t1, $zero, 10"),  # $t1 = 10
            (8, "add $t2, $t0, $t1")    # $t2 = $t0 + $t1 = 15
        ]
        
        simulator = Simulator(program=program)
        simulator.run()
        
        # Check final register values
        self.assertEqual(simulator.register_file.read("$t0"), 5)
        self.assertEqual(simulator.register_file.read("$t1"), 10)
        self.assertEqual(simulator.register_file.read("$t2"), 15)
        
    def test_memory_operations(self):
        # Program to test load and store
        program = [
            (0, "addi $t0, $zero, 100"),  # Address
            (4, "addi $t1, $zero, 42"),   # Value to store
            (8, "sw $t1, 0($t0)"),        # Store $t1 at address in $t0
            (12, "lw $t2, 0($t0)")        # Load from address in $t0 to $t2
        ]
        
        simulator = Simulator(program=program)
        simulator.run()
        
        # Check memory and registers
        self.assertEqual(simulator.memory.load(100), 42)
        self.assertEqual(simulator.register_file.read("$t2"), 42)
        
if __name__ == '__main__':
    unittest.main()