<img width="347" height="325" alt="1770345126649862863285757915093" src="https://github.com/user-attachments/assets/7d7b58ec-bac0-47e0-8263-b05234249332" />
<img width="373" height="463" alt="1000063495" src="https://github.com/user-attachments/assets/9ea9420e-8b49-4350-b6f1-0460fddb7f20" />

# GB-Pong

This project consists of a pong game for the original Nintendo GameBoy DMG-001, written entirely in assembly. One player uses the D-Pad up and down to control a paddle while the other player uses buttons A and B. Future versions could include Link-Cable support, but I'm planning to concentrate on programming modern hardware in future projects.

## How to Execute 

To test the game out, an emulator can be used or it can be run on original hardware using a programmed Flash/EEPROM cartridge or similar. The game executable ```pong.gb``` can be found inside the bin folder once built with ```make``` command. This program has been tested on real hardware, as shown in the GIF, using an SD card flashcard.

## Context

Back when I was 15, I wondered if I could program a real videogame. With a quick Google search, I found I could easily make one for the GameBoy using "GB-Studio," but I realized this tool was quite limited for the kind of games I wanted to make back then. 

That led me to learning DMG assembly to have more control over the hardware. After months of being completely lost, something finally clicked when looking at some example code, and I made my first GameBoy game—a pong port—which can be found on an older repo.

This set me on track for pursuing my degree in EE. Back then I made a working game, but I didn't understand DMA, Git, or how to be organized when coding. Now that I'm halfway through my bachelor's, I decided in December 2025 to completely rewrite my first GameBoy program; this is it.

## Technical Details

* **Language:** SM83 Assembly
* **Tools:** RGBDS (Rednex Game Boy Development System)
* **Target:** Original GameBoy (DMG-001), LR35902 CPU

### Improvements in this version
* **DMA Transfers:** Proper implementation of OAM DMA for sprite memory management.
* **Organization:** Clean modular structure and efficient memory mapping.
* **Version Control:** Proper use of Git for project history.
* **Physics System:** Acceleration implemented in paddles instead of the usual constant speed movement. Ball physics also include an effect simulating friction, where paddles can accelerate the ball on the Y-axis.
* **Ball Launching State Machine:** A routine that decides which player serves next and cycles through a process where a player gets to position and accelerate the ball during a serve. This includes a V-Blank (frame) counting timer with visual feedback for the other player to prepare.

---
