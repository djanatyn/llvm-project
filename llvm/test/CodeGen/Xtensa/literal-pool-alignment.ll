; Verify that the literal pool is emitted into its own 4-byte aligned section.
; The l32r instruction can only load from a 4-byte aligned address (its PC
; relative offset is encoded in units of 4 bytes), so the pool must not be
; appended inline to the text section at an arbitrary offset. Here the pool
; for @calls_external is placed after @empty, whose body is not a multiple
; of 4 bytes (entry + retw.n = 5 bytes).

; RUN: llc -mtriple=xtensa -mcpu=esp32 -filetype=obj < %s -o - \
; RUN:   | llvm-readobj --sections - | FileCheck %s

declare void @callee()

define void @empty() {
entry:
  ret void
}

define void @calls_external() {
entry:
  call void @callee()
  ret void
}

; CHECK: Name: .literal
; CHECK: AddressAlignment: 4
; CHECK: Name: .rela.literal
