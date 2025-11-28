# --- Configuration ---

PROJECT_NAME = pong
SRC_DIR = src
BUILD_DIR = build
BIN_DIR = bin

# --- Toolchain & Flags ---

RGBASM = rgbasm
RGBLINK = rgblink
RGBFIX = rgbfix

ASMFLAGS = -Werror # Treat warnings as errors
LINKFLAGS = -n -l -m $(BUILD_DIR)/$(PROJECT_NAME).map
FIXFLAGS = -v -f lhg -p 0xFF

# --- File Generation ---

# Find all .asm files in the src/ directory
ASM_SOURCES = $(wildcard $(SRC_DIR)/*.asm)

# Convert the list of .asm sources into a list of .o objects in the build/ directory
# Example: src/main.asm -> build/main.o
OBJECTS = $(patsubst $(SRC_DIR)/%.asm,$(BUILD_DIR)/%.o,$(ASM_SOURCES))

ROM_PATH = $(BIN_DIR)/$(PROJECT_NAME).gb

# --- Build Targets ---

.PHONY: all clean run

# Default target: builds the ROM
all: $(ROM_PATH)

# Primary Rule: Links all object files into the final ROM
$(ROM_PATH): $(OBJECTS)
	@mkdir -p $(BUILD_DIR) # CRITICAL: Ensures the directory exists for the .map file
	@mkdir -p $(BIN_DIR)
	@echo "--- LINKING $(PROJECT_NAME).gb ---"
	$(RGBLINK) $(LINKFLAGS) -o $@ $^
	@echo "--- FIXING HEADER ---"
	$(RGBFIX) $(FIXFLAGS) $@

# Assembly Rule (Pattern): Assembles any .asm file that is newer than its .o file
# This is where the magic happens: it runs rgbasm for every file in the OBJECTS list.
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	@mkdir -p $(BUILD_DIR)
	@echo "--- ASSEMBLING $< ---"
	$(RGBASM) $(ASMFLAGS) -o $@ $<

# --- Utility Targets ---

clean:
	@echo "--- CLEANING ---"
	@rm -rf $(BUILD_DIR) $(BIN_DIR)

