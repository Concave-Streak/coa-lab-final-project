import sys

# Instruction dictionaries to map mnemonics to hex codes
OP_CODES = {
    'ALU': '0', 'ALUI': '1', 'LD': '20', 'ST': '30', 'BR': '40',
    'BMI': '50', 'BPL': '60', 'BZ': '70', 'MOVE': '80', 'CMOV': '90', 'JR': 'A0',
    'HALT': 'FF', 'NOP': 'EF'
}

ALU_OPS = {
    'ADD': '0', 'SUB': '1', 'SLT': '2', 'SGT': '3', 'AND': '4',
    'OR': '5', 'XOR': '6', 'NOT': '7', 'NOR': '8', 'LUI': '9',
    'SLA': 'A', 'SRL': 'B', 'SRA': 'C', 'INC': 'D', 'DEC': 'E', 'HAM': 'F'
}

REGISTERS = {
    '$0': '0', '$1': '1', '$2': '2', '$3': '3', '$4': '4',
    '$5': '5', '$6': '6', '$7': '7', '$8': '8', '$9': '9',
    '$A': 'A', '$B': 'B', '$C': 'C', '$D': 'D', '$E': 'E', '$F': 'F',
    '$RA': 'B','$SP': 'E', '$FO': 'F' # aliasing
}

MULTI_OPS = {'LA':2, 'JAL':2}

# Utility functions
def to_hex(value, bits=4):
    """Converts an integer value to hex, padded to a given number of bits."""
    return f'{value & ((1 << bits) - 1):0{bits//4}X}'

# Parse .data section
def parse_data_section(data_lines):
    """Parse the .data section and return a dictionary of data labels with memory locations."""
    data_memory = {}
    memory_address = 0
    data_instructions = []

    for line in data_lines:
        if ':' not in line:
            continue
        
        parts = line.split()
        label = parts[0].replace(':', '').strip()
        data_type = parts[1]

        if data_type == '.int':
            value = int(parts[2])
            data_memory[label] = memory_address
            data_instructions.append(to_hex(value, 32))
            memory_address += 1

        elif data_type == '.arr':
            values = parts[2].replace('{', '').replace('}', '').split(',')
            data_memory[label] = memory_address
            for value in values:
                data_instructions.append(to_hex(int(value), 32))
                memory_address += 1

        elif data_type == '.char':
            value = ord(parts[2].strip("'"))
            data_memory[label] = memory_address
            data_instructions.append(to_hex(value, 32))
            memory_address += 1

        elif data_type == '.str':
            string = parts[2].strip('"')
            data_memory[label] = memory_address
            for char in string:
                data_instructions.append(to_hex(ord(char), 32))
                memory_address += 1

    return data_memory, data_instructions

# First pass: Label handling and memory address assignment
def first_pass(instructions):
    """First pass: record the location of labels."""
    labels = {}
    instruction_memory = []
    address_counter = 0  # Instruction address starts at 0

    for instr in instructions:
        if ':' in instr:  # It's a label
            label = instr.replace(':', '').strip()
            labels[label] = address_counter  # Record label address
        elif (instr.strip() != ''):
            instruction_memory.append(instr)
            parts = instr.replace(',', '').split()  # Split instruction by spaces and remove commas
            op = parts[0].upper()
            
            if op in MULTI_OPS.keys():
                address_counter += MULTI_OPS[op]
            else:
                address_counter += 1  # Increment for each instruction

    return labels, instruction_memory

# Second pass: Assembling instructions
def assemble(instructions, data_labels):
    """Takes a list of assembly instructions and outputs machine code in hex."""
    machine_code = []
    labels, instructions = first_pass(instructions)

    address_counter = 0  # Reset address counter for final assembly

    for instr in instructions:
        parts = instr.replace(',', '').split()  # Split instruction by spaces and remove commas

        op = parts[0].upper()
        
        if op=='LI':
            rd = REGISTERS[parts[1].upper()]
            imm = to_hex(int(parts[2]), 16)
            instruction = f"1{ALU_OPS['ADD']}{rd}0{imm[:16]}"
            
        elif op=='NOT':
            rd = REGISTERS[parts[1].upper()]
            rs1 = REGISTERS[parts[2].upper()]
            instruction = f"0{ALU_OPS['NOT']}{rd}{rs1}0000"
        
        elif op=='LA':
            rd = REGISTERS[parts[1].upper()]
            addr = parts[2]
            if addr in data_labels:
                addr = data_labels[addr]
            else:
                raise ValueError(f"Label {addr} not found.")
    
            imm = to_hex(int(addr), 32)
            pseudo = f"1{ALU_OPS['LUI']}{rd}0{imm[:4]}"
            machine_code.append(pseudo)
            address_counter += 1
            instruction = f"1{ALU_OPS['OR']}{rd}{rd}{imm[4:]}"
        
        elif op=='LUI':
            alu_op = ALU_OPS[op]
            rd = REGISTERS[parts[1].upper()]
            imm = to_hex(int(parts[2]), 16)  # Immediate value
            instruction = f"1{alu_op}{rd}0{imm}"

        # Handle ALUI (immediate version)
        elif op.endswith('I') and op[:-1] in ALU_OPS:
            alu_op = ALU_OPS[op[:-1]]
            rd = REGISTERS[parts[1].upper()]
            rs1 = REGISTERS[parts[2].upper()]  
            imm = to_hex(int(parts[3]), 16)  # Immediate value
            instruction = f"1{alu_op}{rd}{rs1}{imm}"

        # Handle ALU register-register instructions
        elif op in ALU_OPS:
            alu_op = ALU_OPS[op]
            rd = REGISTERS[parts[1].upper()]
            rs1 = REGISTERS[parts[2].upper()]
            rs2 = REGISTERS[parts[3].upper()]
            instruction = f"0{alu_op}{rd}{rs1}{rs2}000"

        # Load/Store instructions with label support and implicit $0 addressing
        elif op == 'LD' or op == 'ST':
            rd = REGISTERS[parts[1].upper()]
            if '(' in parts[2]:
                offset, rs1 = parts[2].split('(')  # Get offset and register (e.g., 100($0))
                rs1 = rs1.rstrip(')')
            else:
                offset = data_labels[parts[2]]  # Access label in data
                rs1 = '$0'  # Default to $0 if no register specified
            
            if offset in data_labels:
                offset = data_labels[offset]
                
            imm = to_hex(int(offset), 16)  # Immediate offset value
                
            instruction = f"{OP_CODES[op]}{rd}{REGISTERS[rs1.upper()]}{imm}"

        elif op == 'JAL':
            imm = to_hex(address_counter+2, 16)
            pseudo = f"1{ALU_OPS['ADD']}{REGISTERS['$RA']}0{imm}"
            machine_code.append(pseudo)
            address_counter += 1
            
            label = parts[1]
            if label in labels:
                label_address = labels[label]
                offset = label_address - (address_counter + 1)  # Offset relative to next instruction
                imm = to_hex(offset, 16)
                instruction = f"{OP_CODES['BR']}00{imm}"
            else:
                raise ValueError(f"Label {label} not found.")
            
        elif op == "JR":
            rs1 = REGISTERS[parts[1].upper()]
            instruction = f"{OP_CODES[op]}00{rs1}000"

        # Branch instructions (label-based)
        elif op in ['BR', 'BMI', 'BPL', 'BZ']:
            
            if op == 'BR':
                label = parts[1]
            else:
                label = parts[2]
                rs1 = REGISTERS[parts[1].upper()]
            
            # Calculate branch offset
            if label in labels:
                label_address = labels[label]
                offset = label_address - (address_counter + 1)  # Offset relative to next instruction
                imm = to_hex(offset, 16)
                if op == 'BR':
                    instruction = f"{OP_CODES[op]}00{imm}"
                else:
                    instruction = f"{OP_CODES[op]}0{rs1}{imm}" 
            else:
                raise ValueError(f"Label {label} not found.")
        
        # Move/Conditional Move instructions
        elif op == 'MOVE':
            rd = REGISTERS[parts[1].upper()]
            rs1 = REGISTERS[parts[2].upper()]
            instruction = f"80{rd}{rs1}0000"

        elif op == 'CMOV':
            rd = REGISTERS[parts[1].upper()]
            rs1 = REGISTERS[parts[2].upper()]
            rs2 = REGISTERS[parts[3].upper()]
            instruction = f"90{rd}{rs1}{rs2}000"

        # HALT instruction
        elif op == 'HALT':
            instruction = 'FF000000'

        # NOP instruction
        elif op == 'NOP':
            instruction = 'EF000000'

        # Add the instruction to machine code list
        machine_code.append(instruction)
        address_counter += 1  # Increment address counter after each instruction

    return machine_code

# Main function: Reads from a file and assembles it
def main():
    if len(sys.argv) < 2:
        print("Usage: python assembler.py <input_file>")
        return
    
    input_file = sys.argv[1]
    
    # Read the input file
    with open(input_file, 'r') as f:
        assembly_program = f.readlines()

    # Separate .data and .text sections
    data_section = []
    text_section = []
    is_data_section = False

    for line in assembly_program:
        line = line.split('#')[0].strip()  # Remove comments
        if line == '.data':
            is_data_section = True
            continue
        elif line == '.text':
            is_data_section = False
            continue

        if is_data_section:
            data_section.append(line)
        else:
            text_section.append(line)

    # Parse data section and get data labels and instructions
    data_labels, data_instructions = parse_data_section(data_section)

    # Assemble instructions
    machine_code = assemble(text_section, data_labels)
        
    # Write instruction .coe file
    with open("inst.coe", 'w') as out_f:
         with open("inst.coe", 'w') as inst_f:
            inst_f.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n")
            for line in machine_code:
                inst_f.write(line.lower() + '\n')
            inst_f.write(';')

    # Write data .coe file
    with open("data.coe", 'w') as data_f:
        data_f.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n")
        for line in data_instructions:
            data_f.write(line.lower() + '\n')
            
        if len(data_instructions) == 0:
            data_f.write('00000000\n')
        
        data_f.write(';')

if __name__ == '__main__':
    main()
