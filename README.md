# Tiger Compiler – Basic Blocks & Control Flow Graph (CFG)

##  Overview

This project implements core components of a **Tiger compiler pipeline**, including:

* Parsing Tiger programs
* Translating to Intermediate Representation (IR)
* Generating MIPS assembly
* Constructing **Basic Blocks**
* Building a **Control Flow Graph (CFG)**

---

## Compiler Pipeline

```
.tig → AST → IR → MIPS → Basic Blocks → CFG
```

---

## 🔹 Basic Blocks

A **basic block** is a sequence of instructions with:

* Single entry
* Single exit
* No internal jumps

Blocks are formed by:

* Identifying leaders (labels, jump targets, post-jump instructions)
* Grouping instructions until the next leader

---

## 🔹 Control Flow Graph (CFG)

A CFG represents execution flow between blocks:

* **Nodes** → Basic Blocks
* **Edges** → Control flow (jumps + fall-through)

### Example

```
Node 0 -> 1
Node 1 -> 2 3
Node 2 -> 1
Node 3 ->
```



---

## Project Structure

```
lib/
  tiger_0/
    ast.ml        → AST definitions
    ir.ml         → Intermediate Representation
    translate.ml  → AST → IR
    codegen.ml    → IR → MIPS
    blocks.ml     → Basic block construction
    graphs.ml     → Graph ADT (CFG)

  backend/
    mips/
      inst.ml     → MIPS instruction definitions and printing
      reg.ml      → Register representation
      mips.ml     → interface

bin/
  main.ml    → Full compiler pipeline (tc)
  block.ml   → Prints basic blocks
  graphs.ml  → Builds and prints CFG

test/
  *.tig      → Sample Tiger programs
```

---

##  How to Run

### Build

```
dune build
```

### Run compiler

```
dune exec tc -- test/for1.tig
```

### View Basic Blocks

```
dune exec block -- test/for1.tig
```

### View CFG

```
dune exec graphs -- test/for1.tig
```

---

## Key Concepts

* Basic block formation using leader rules
* CFG construction using:

  * Conditional branches (`bne`, `beq`)
  * Unconditional jumps (`j`)
  * Fall-through edges
* Loop representation using back edges

---


##  Summary

> Basic Blocks = straight-line execution
> CFG = program control structure

This project builds the foundation for advanced compiler design.

---
