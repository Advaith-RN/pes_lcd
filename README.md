# The complete ASIC flow for a module that controls a 16x2 lcd display

## Intro
The objective of this project is to control a 16x2 LCD display. We will be using iVerilog to design the submodules.

## Datasheets

### Taking a look at the [datasheets](https://www.sparkfun.com/datasheets/LCD/ADM1602K-NSW-FBS-3.3v.pdf), we can see that the display has a total of 16 pins.
<br><br>
![lcd schematic](https://github.com/Advaith-RN/pes_lcd_segment/assets/77977360/cea32e47-9391-4efb-b82f-58dec38adfa2)
<br><br>
- Pins VCC, VDD and VEE are for our LCD backlight, contrast control, and power supply.
  - **VCC**: Ground
  - **VDD**: 3V Power
  - **VEE**: PWM to adjust contrast
- RS and RW are the Register Select and Register Write pins
  - These pins work in tandem with the Data pins to execute a number of instructions.
  - The instruction sheet is displayed below:
<br><br>

![image](https://github.com/Advaith-RN/pes_lcd_segment/assets/77977360/a06e9cd6-557a-406b-ba21-692866ff917b)
<br><br>
As we can see, all non-write operations have a varying length of trailing 0s, followed by 1. The bits after the 1 specify settings for the actual command.

For the scope of this project, I will select a base set of instructions, which are absolutely necesssary to display our message on the LCD.


## Instructions to be included
Clear Display<br>
```
0  0  :  0  0  0  0  0  0  0  1
```
Return Home<br>
```
0  0  :  0  0  0  0  0  0  1  -
```
Display ON/OFF<br>
```
0  0  :  0  0  0  0  1  D  C  B

D - Set Display
C - Set Cursor
B - Set Cursor Blink

To turn on display, without a cursor:

0  0  :  0  0  0  0  1  1  0  0
```
Function Set<br>
```
0  0  :  0  0  1  DL N  F  0  0
This instruction is used to specify whether we use 8-bit mode or 4-bit mode to transfer data.

DL - Set Data length -> 8-bit(high), 4-bit(low)
N - Set numbers of display line -> 2-line(high), 1-line(low)
F - Font Type -> 5x11(high), 5x8(low)

We are sending 8-bit instructions, displaying on both lines, and displaying 5x11 font.

0  0  :  0  0  1  1  1  1  0  0
 
```
Write Data<br>
```
1  0  :  D0 D1 D2 D3 D4 D5 D6 D7
```

# RTL to GDS Flow

Taking the verilog file and the testbench, first running
```
iverilog pes_lcd.v pes_lcd_tb.v
```
This generates an ```a.out``` file which when run gives a ```dump.vcd``` file.

```
gtkwave dump.vcd
```

![image](https://github.com/Advaith-RN/pes_lcd/assets/77977360/46bd95ec-697d-453f-9e43-833da87274be)


