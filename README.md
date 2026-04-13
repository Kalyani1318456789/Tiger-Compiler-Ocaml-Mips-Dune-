A complete compiler for a subset of the Tiger programming language, implementing an end-to-end pipeline from source code to executable MIPS assembly.

✨ Features
Supports variables, expressions, loops, and control flow
Full compilation pipeline:
AST (Abstract Syntax Tree)
IR (Three-address code)
Register Allocation
MIPS Code Generation
Symbol table with virtual register abstraction (Temp.temp)
Greedy register allocator with reuse optimization
IR optimizations to reduce register pressure
Basic block construction for CFG preparation
Typed MIPS AST for safe and modular backend
Generates SPIM-compatible MIPS assembly
Compiler Pipeline:
Source (.tig)
   ↓
Lexer (lexer.mll)
   ↓
Parser (parser.mly)
   ↓
AST (ast.ml)
   ↓
IR Translation (translate.ml)
   ↓
IR (ir.ml)
   ↓
Basic Blocks (blocks.ml)
   ↓
Code Generation (codegen.ml)
   ↓
MIPS AST (mips.ml)
   ↓
Output (program.asm)
