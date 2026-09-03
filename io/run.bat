@echo off
del cards.odin
copy ..\cards.odin .\cards.odin

odin build .
io.exe %*