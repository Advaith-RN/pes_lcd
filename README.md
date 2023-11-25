![image](https://github.com/Advaith-RN/pes_lcd/assets/77977360/2f7859a4-d219-47e8-87fa-d4b8dfa9a979)![image](https://github.com/Advaith-RN/pes_lcd/assets/77977360/65fd6b1d-b471-4567-b000-9c6f0b62052e)# The complete ASIC flow for a module that controls a 16x2 lcd display

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


## RTL Synthesis

Ensure that the sky130 library is imported and copied into your working folder. The library can be found in [this repo](https://github.com/kunalg123/sky130RTLDesignAndSynthesisWorkshop).

Run yosys, and execute these commands to synthesize the top module.
```
 read_liberty -lib sky130_fd_sc_hd__tt_025C_1v80.lib
 read_verilog pes_lcd.v
 synth -top pes_lcd
```

![image](https://github.com/Advaith-RN/pes_lcd/assets/77977360/a9ddeb3e-1e15-40d9-8ab3-b088f135848e)

Generate the netlist with:
```
abc -liberty sky130_fd_sc_hd__tt_025C_1v80.lib
write_verilog -noattr pes_bupc_net.v
```

![image](https://github.com/Advaith-RN/pes_lcd/assets/77977360/540d31e9-afa6-4097-a1af-47d81516dcd3)

![image](https://github.com/Advaith-RN/pes_lcd/assets/77977360/2ddf75ae-82b0-4bdb-ab96-e5f0362b2aa1)

Now type ```show``` to display the netlist.

![image](https://github.com/Advaith-RN/pes_lcd/assets/77977360/efe04566-808a-491f-b523-a68409da4f64)

## GLS

Import the primatives.v and sky130_fd_sc_hd.v from the sky130 repo.Then run:
```
 iverilog primitives.v sky130_fd_sc_hd.v pes_lcd.v  pes_lcd_tb.v 
```
Run ```./a.out``` and open the generated vcd file with gtkwave.

![image](https://github.com/Advaith-RN/pes_lcd/assets/77977360/308ece5a-e52a-4817-82a8-0c70b9efb143)



# Physical Design

Add the design to the Openlane/designs folder.
```
cd OpenLane\designs
mkdir pes_lcd
cd pes_lcd
mkdir src
```

Create a config file.
```
gedit config.json
```

Add your verilog file and add the required pdks as well. Invoke ```make mount``` in the openlane directory and prep your design.
```
cd ~/Openlane
make mount
./flow.tcl -interactive

package require openlane 0.9
prep -design pes_lcd
```
![image](https://github.com/Advaith-RN/pes_lcd/assets/77977360/a46ac4ca-3b52-4c02-bb39-b4bff0468660)


```run_synthesis``` on the design.


![image](https://github.com/Advaith-RN/pes_lcd/assets/77977360/2c54886f-ff00-4e9c-ac5b-7db3e59a7884)

You can view the report in ```/home/OpenLane/designs/pes_lcd/runs/RUN_2023.11.25_14.36.53/reports.```

![image](https://github.com/Advaith-RN/pes_lcd/assets/77977360/754540ff-386f-4501-8ca1-4fbf7535c31e)

Now ```run_floorplan```.

![image](https://github.com/Advaith-RN/pes_lcd/assets/77977360/f01654db-f88f-4ae5-ba89-b04e923c812a)

You can view the results in ```/home/OpenLane/designs/pes_lcd/runs/RUN_2023.11.25_14.36.53/results./floorplan``` using magic. 

```
magic -T ../../../sky130A.tech lef read ../../tmp/merged.nom.lef def pes_lcd.def &
```
![image](https://github.com/Advaith-RN/pes_lcd/assets/77977360/ad63c3cc-316c-4836-bffb-769ccacf0590)

Now run the placement.
```
run_placement
```
![image](https://github.com/Advaith-RN/pes_lcd/assets/77977360/17c0b75e-b8cc-46eb-9478-113dfdf6e8f3)

Run the clock tree synthesis using
```
run_cts
```
View the slack reports at 
```
~/OpenLane/designs/pes_traffic/runs/RUN_2023.11.25_14.36.53/logs/cts/12-cts_sta.log
```









