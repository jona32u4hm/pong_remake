# GB-Pong

This project consists of a pong game for the original Nintendo GameBoy DMG-001, written entirely in assembly. One player uses the D-Pad up and down to control a paddle while the other player uses buttons A and B. Future versions could include Link-Cable support, but I'm planning to concentrate on programming modern hardware in future projects.

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
