# Project Name: Pongfinity

## Team Members: Derek Xu, Koen Lin, Louis Jimenez Hernandez, Jivesh Jain

## Project Demo:

## Overview: 
We built on top of the 2020 EC311 pong project which was a one player pong. The previous project included a single paddle 
and a non-functioning high score counter along with a ball and ball collision. We expanded on top of this by 
- Adding 2 players with (1 paddle for each)
- Changed the orientation of the game to be horizontal (like the original Pong instead of vertical like the previous project)
- Adapted player movement to the keyboard
- Adapted board buttons to change the mode
- Added modes
  - Mode 1: Original 2-player pong with lives
  - Mode 2: Easy/practice mode 2-player pong where each player is fighting against themselves attempting to last the longest. You can switch back to normal Pong once finished.
- **Implemented our own collision logic, we did not use the original collision logic**
- Altered scoring to be lives-based instead of score-based
- Implementing the lives of the two players onto the 7-segment displays
- Altered the colors of the game based on the current mode that the player selects

## Steps to run:
1. Download GitHub code

  > `git clone https://github.com/d0w/logic-design-project`

2. Add source files and memory files into your own Verilog project
3. Set the "top" module as the top module
4. Synthesize, implement, and generate the bitstream
5. Program the FPGA with the code.
6. Press the center button (N17) to switch modes/start the game
7. Buttons 'W' 'S' and 'A' control up/down/stop movement for player 1
8. Buttons 'UP' 'DOWN' and 'LEFT' control up/down/stop movement for player 2
### Notes:
- The FPGA should be connected via VGA to an external display
- A USB keyboard should be connected to the FPGA

## Code Structure:
top.v

> game.v

>> vga640x480.v
    
>> rocket.v
    
>> square.v
    
>>> debounce.v
        
> PS2Receiver.v

> clock_divider.v

> menu_screen.v

>> vga640x480.v
    
>> sram.v
    
> bg_gen.v (end_screen)

>incrementer.v

>> debounce.v
    
> score_to_7seg



### top.v: 
We have a top module that houses the "keyboard" "clock divider" "game screen" "menu screen" "7-segment-display" modules
and handles logic for the different modes, VGA display, clock data, instantiating the game, game conditions (menu->game->game over),
and board/keyboard input. 

### game.v:
In charge of the actual Pong game. game.v instantiates the "rocket" and "square" modules which act as the paddles and the ball respectively. 
The modules holds signals which determine whether or not to animate the next frame and whether or not a collision occurred. The modules also draws the 
paddles, ball, and extra items based on the mode to the VGA display. game.v is also responsible for sending back the endgame signals, VGA RGB signals, and lives values
to the top level module where the top level module will take the VGA output and display certain channels based on the current mode.

### vga640x480.v
This module is in charge of handling which pixel to draw at what x and y position on the VGA display.

### rocket.v
This serves as the paddle in which you would see in the original Pong. The paddle takes in the keyboard controls the move up and down. If the paddle detects the up key,
it goes up 10px, down goes down 10px, and left stops the current movement. The movement and button presses are stored in separate registers which allows 2 players to 
play simultaneously without interupting each other.

### square.v
This module is the ball seen in the original Pong. The ball is in charge of collision logic, scoring, and endgame conditions. The ball is able to detect the outer boundaries
or the other paddle positions. Once the square detects a collision with the edge of a paddle or screen, it changes its movement direction or handles lives logic accordingly. 
Keeping track of the lives, the ball also triggers endgame if one of the players' lives is 0.

### PS2Receiver.v
The module takes in the keycode of whatever key is presssed and stores it so that it can be passed to other modules. The module takes the 8-bit scan code which 
is determined by the key that is pressed. Then it stores the last 4 keys that were pressed and sends these back to the top level module.

### clock_divider.v
This module takes the clock from the FPGA board and divides it to output a 1Hz clock instead.

### menu_screen.v
This module is in charge of displaying the menu screen. The module loads an image file that is represented as .mem file into the sram.v module. It also loads
another .mem file that represents the palette of the image (colors) and instantiates a vga display module. Then the module outputs to the VGA display the RGB values
as well as the x and y coordinates to draw which draw the image loaded from the .mem file. 

### sram.v
This modules takes in a .mem file and stores it into an array so that the menu screen and game over screen can be displayed. Images were converted into bitmaps which
were then loaded into this module. Then menu_screen.v and bg_gen.v load this memory.

### bg_gen.v
A parametrized version of menu_screen that displays the gameover screen if the endgame flag is 1.

### incrementer.v
This module is in charge of taking in a button input, debouncing the input, and then changing the top level module's current mode. This mode controls what game mode the game will be played in.

### score_to_7seg.v:
A traditional 7-segment display which takes in the values of the 2 players' lives and displays them onto the board's 7-segment display.

### debounce.v:
Handles signals which can possibly cycle between high and low very quickly by adding an incrementer which acts as a delay. This makes it so the ball does not repeatedly bounce
and the button inputs do not click multiple times per click.


