# 32-bit 5-STAGE PIPELINED MIPS PROCESSOR

Verilog code for this microprocessor design is mostly done by using STRUCTURAL MODELLING.Pipelining is an implementation technique whereby multiple instructions are overlapped in execution,it takes an advantage of parallelism that exists among the actions needed to execute an instruction.    

MIPS is a five stage pipeline processor,each stage is responsible to complete a part of an each instruction.    

STAGE - 1    Instruction Fetch (IF)   
* Sending PC to memory and fetching  the current instruction from memory as well    update the PC to next in sequence by adding 4 to the PC (PC = PC+4)    

STAGE - 2   Instruction decode (ID)    
* Decoding the instruction and reading the registers as specified in register file.   
 * For the possible branch instruction, doing the equality test on the registers as they are read. 
* Sign extend the offset field if it is needed.    
* Compute the possible branch target address 
* Decoding can be done in parallel with reading the registers since the register specifiers at a fixed location, this is called is ‘fixed field decoding’.   

STAGE - 3 Execute (EX)    
* In this stage, mainly ALU operations based on the instruction type. 
* In terms of memory instructions, it adds base address and offset to acquire effective address. 
* For register –register operations, as per the ALU – opcode it performs addition, subtraction as it is needed. 
* It performs operation for register –immediate ALU instructions.   
* ALUSrc, ALUOp and RegDsr are the signals that need to be set, it selects the ALU operation, resulting register, and either sign extended immediate field or read the data.   

STAGE - 4 Memory access (MEM)    
* In this particular stage, load and store instructions are being performed. 
* If it is a load instruction then it reads an effective address from the memory and in the case of store instruction it writes the data in to memory.   
* In this stage, MemWrite, MemRead and Branch are the signals that needs to be set, they are set by the store instruction, load instruction or by the branch equal respectively.    

STAGE - 5 Write Back (WB)    
* This is the last stage and it performs register – register ALU instruction or LOAD instruction to write the result in to register file (at ID stage), to check whether it comes through load instruction or from ALU when it is a case of ALU instruction.   
* There are two different control signals; MemtoReg which is responsible in deciding in between sending the memory value or ALU result from stage 3 and RegWrite which is responsible of writing the value.    









## INSTRUCTION SET DEFINITION

In MIPS, there are three different types of instructions: R-type, I-type and J-type.   
R-type Instructions:   
R-type instructions take three different arguments: rt and rs both source register and rd – destination register.   
ADD   
SUB   
MUL   
DIV   
AND    
OR    
NOR     

I-type Instructions:   
I-type instructions takes two arguments, rs and rt and 16 bit immediate value, this immediate value is not stores in memory but it is a part of the instruction. The benefit 
of such immediate is that we do not need to work with the memory so accessing constant (immediate) is much faster.    
LW - Load Word   
SW - Store Word    
BNE - Branch Not Equal   
BEQ - Branch Equal   
AddI - Add Immediate   
OrI - Or Immediate   

J-type Instructions:   
Jump Instructions devote all of the non-opcode space  to a 26-bit jump destination field.   
J - Jump    


## PIPELINE HAZARDS    

Generally, there are 3 types of pipeline hazards.   
1. Structural Hazard: Structural Hazard is the case when any two instructions wants to access same hardware in the same stage of pipeline.     

we can solve this hazard in two ways either by incurring stall cycles or increasing no. of resources.  

2. Data Hazard: This hazard occurs when an instruction depends on the result of same instruction & that result of instruction has not yet computed.    

Classification of Data Hazards:
1. Read After Write (RAW)   
2. Write After Read (WAR)    
3. Write After Write(WAW)
There are several ways to solve the data hazards. Few of them are  Operand Forwarding & Stall cycles insertion.    

Forwarding : 
It adds special circuitry to the pipeline. This method works because it takes less time for the required values to travel through a wire than it does for a pipeline segment to compute its result.    

Stall Insertion : 
it inserts one or more stall (no-op instructions) into the pipeline, which delays the execution of the current instruction until the required operand is written to the register file, but this method decreases pipeline efficiency and throughput.    

3. CONTROL HAZARD: These are generally caused by branch instructions.

This MIPS processor design basically detects control hazard & data hazards.We designed 4 units to resolve these hazards.    

Forwarding Unit:    
The Forwarding Unit is designed to solve the data hazards in pipelined MIPS Processor. The correct data at the output of the ALU is forwarded to the input of the ALU when data hazards are detected. Data hazards are detected when the source register (EX_rs or EX_rt) of the current instruction is the same as the destination register (MEM_WriteRegister or EX_WriteRegister) of the previous instruction.     

STALL CONTROL UNIT:    
Data hazards which needs stalling 1 cycle happen when the destination register (EX_rt) of the current reading memory instruction  is the same as the  source register (ID_rs or ID_rt) of the coming instruction in ID stage except for ID_rt of XORI and LW instructions (where Rt is the destination register not source register with XORI and LW).     

WB_FORWARD UNIT:    
Another hazard could happen at the Write Back Stage when writing and reading at the same address. The readout data may not be the correct writing data. To resolve this problem, a WB_Forward unit is designed to forward directly the correct writing data to the output data.      

FLUSH CONTROL UNIT:   
Flush Control Unit is designed to solve control hazards and it discards instructions in IF and ID stages when a jump instruction(J, JR, or BNE) performs.      








## APPROACH & IMPLEMENTATION    

The flow of designing of required modules to acheive a 32-bit MIPS 5 stage pipeline processor are as follows:   

1. 32-bit Adder   
2. Register file    
3. 32-bit ALU     
4. Instruction Memory    
5. Data Memory    
6. Zero Extension module    
7. Sign Extension & Shilt Left 2 module    
8. Control Unit    
9. ALU Control Unit    
10. JR Control Unit    
11. Forwarding Unit    
12. Stall Control unit    
13. Write back Forward unit   
14. 32-bit MIPS pipeline Processor (top module)    
15. Testbench for top module
