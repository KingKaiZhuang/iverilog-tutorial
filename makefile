# Directories
SRC_DIR = vvc
OUT_DIR = out
VCD_DIR = vcd

# Default file to simulate (can be overridden with make FILE=xxx)
FILE ?= half_adder_tb

# File paths
SRC_FILE = $(SRC_DIR)/$(FILE).v
OUT_FILE = $(OUT_DIR)/$(FILE).out
VCD_FILE = $(VCD_DIR)/$(FILE).vcd

# Default rule
all: run

# Compile
build:
	@mkdir -p $(OUT_DIR)
	iverilog -o $(OUT_FILE) $(SRC_FILE)
	@echo "Compiled $(SRC_FILE) -> $(OUT_FILE)"

# Run
run: build
	vvp $(OUT_FILE)

# View waveform
wave:
	gtkwave $(VCD_FILE)

# Clean
clean:
	rm -rf $(OUT_DIR)/*.out $(VCD_DIR)/*.vcd
