# ALSU-Verification-using-UVM
This project demonstrates a Universal Verification Methodology (UVM)-based verification environment for an Arithmetic Logic and Shift Unit (ALSU). The ALSU performs a wide range of arithmetic, logical, and shift operations, and the UVM testbench is designed to thoroughly verify its functional correctness, robustness, and coverage.

# Objectives:
Build a reusable, scalable UVM testbench to verify ALSU functionality

Stimulate various arithmetic, logic, and shift operations through randomized and directed test scenarios

Implement functional coverage and assertions to ensure complete verification

Detect corner cases and validate result accuracy across operand ranges

# ALSU Functional Overview:
The ALSU supports multiple operations such as:

Arithmetic: Addition, Subtraction, Increment, Decrement

Logic: AND, OR, XOR, NOT

Shifts: Logical left/right, Arithmetic right

Operation selection is controlled via an opcode input, and results are output along with relevant status flags (e.g., zero, carry, overflow).

# UVM Testbench Structure:
Sequence & Sequence Items: Generates random input operands and operation codes to cover a wide input space.

Driver: Drives ALSU inputs based on the sequence item.

Monitor: Observes inputs and outputs, and sends transactions to the scoreboard.

Scoreboard: Compares DUT output against expected results using a golden reference model.

Coverage Collector: Gathers functional coverage on opcodes, operands, and corner cases.

Assertions (Optional): Inline SVA used to check protocol and timing rules.

# Tools & Languages:
SystemVerilog for DUT and UVM testbench

Mentor QuestaSim simulation

UVM 1.2/IEEE 1800.2 standard methodology

# Results:
Achieved 100% functional coverage across all operation types

Detected and debugged corner-case behavior in overflow and shift operations

Demonstrated reusable UVM components for other ALU-type designs

# Contact Me!
- **Email:** shehabeldeen2004@gmail.com
- **LinkedIn:** (https://www.linkedin.com/in/shehabeldeen22)
- **GitHub:** (https://github.com/shehab-25)

