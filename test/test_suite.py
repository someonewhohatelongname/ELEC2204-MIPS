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

    def test_store_and_load_word(self):
        address = 0x1000  # static segment, aligned
        self.memory.store(address, 42)
        self.assertEqual(self.memory.load(address), 42)

    def test_load_uninitialized_returns_zero(self):
        address = 0x1000
        self.assertEqual(self.memory.load(address), 0)

    def test_store_unaligned_address_raises(self):
        with self.assertRaises(ValueError):
            self.memory.store(0x1003, 99)  # Not 4-byte aligned

    def test_store_out_of_range_address_raises(self):
        with self.assertRaises(ValueError):
            self.memory.store(0x4000, 99)  # Out of bounds

    def test_segment_identification(self):
        self.assertTrue(self.memory.is_text_segment(0x0000))
        self.assertTrue(self.memory.is_static_segment(0x1000))
        self.assertTrue(self.memory.is_dynamic_segment(0x2000))
        self.assertTrue(self.memory.is_stack_segment(0x3000))

        self.assertFalse(self.memory.is_text_segment(0x1000))
        self.assertFalse(self.memory.is_static_segment(0x2000))
        self.assertFalse(self.memory.is_dynamic_segment(0x3000))
        self.assertFalse(self.memory.is_stack_segment(0x0000))

    def test_stack_pointer_initial_value(self):
        self.assertEqual(self.memory.STACK_POINTER_INIT, self.memory.STACK_END)

            
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
        self.assertEqual(self.pipe_reg.read("test"), {})
        
class TestInstructionParser(unittest.TestCase):
    def test_r_type(self):
        result = parse_instruction("add $t0, $t1, $t2")
        self.assertEqual(result['opcode'], "add")
        self.assertEqual(result['type'], "R")
        self.assertEqual(result['operands'], {"rd": "$t0", "rs": "$t1", "rt": "$t2"})

    def test_i_type_addi(self):
        result = parse_instruction("addi $t0, $t1, 123")
        self.assertEqual(result['opcode'], "addi")
        self.assertEqual(result['type'], "I")
        self.assertEqual(result['operands'], {"rd": "$t0", "rs": "$t1", "imm": "123"})

    def test_i_type_memory(self):
        result = parse_instruction("lw $t0, 8($t1)")
        self.assertEqual(result['opcode'], "lw")
        self.assertEqual(result['type'], "I")
        self.assertEqual(result['operands'], {
            "rt": "$t0",
            "imm(rs)": "8($t1)",
            "imm": "8",
            "rs": "$t1"
        })

        
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