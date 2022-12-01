![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg)

# CNS Test Submission 1
<img  align="center" width='800px' src = "https://github.com/NYIT-CNS/cns001-tt02-submission1/blob/main/score-board.png?raw=true">

## Score Board

* Authors: Bryan Bonilla Garay, Devin Alvarez, Ishaan Singh, Yu Feng Zhou, and N. Sertac Artan

* Description: Display an 8-bit score from one of two players as a two-digit hexadecimal value.
* [GitHub repository](https://github.com/NYIT-CNS/cns001-tt02-submission1)
* [Wokwi](https://wokwi.com/projects/349822052986782291) project
* Clock: 0 Hz
* External hardware: None

### How it works

Fourteen T Flip-Flops are made into two 8-bit Up counters that hold two different user scores (0-255 or 0 - FF). The down functionality is achieved via a not gate connected to the after the first T Flip-Flop. Both user scores are fed into eight 2:1 muxes to which are controlled by the Display User pin. As the board only contains one 7-segment display, This output is then fed into four 2:1 muxes which are controlled by the Display Digit pin (to show either MSD or LSD), which is fed into a 7-segment decoder at the end.

### How to to test

Using default settings, increment the first user score up until the second digit increments (16 increments). Check to make sure it is displaying both the correct MSD and LSD and decrement back to 0. Repeat with the second user's score, and then increment and decrement with a combination of both scores. With both scores at arbitrary values, hit the reset button and check both users scores.


### IO

| # | Input        | Output       |
|---|--------------|--------------|
| 0 |  Clock   |  segment a  |
| 1 |  none   |  segment b  |
| 2 |  none   |  segment c  |
| 3 |  RST   |  segment d  |
| 4 |  Display Digit  |  segment e  |
| 5 |  Display User   |  segment f  |
| 6 |  User  |  segment g  |
| 7 |  Mode   |  segment dp  |


Updating scores (Make sure to toggle)

<img  align="center" width='300px' src = "https://github.com/NYIT-CNS/cns001-tt02-submission1/blob/main/state-table-score-update.png?raw=true">
    
Displaying User Score:

  <img  align="center" width='300px' src = "https://i.ibb.co/SN47pT7/Screen-Shot-2022-11-29-at-10-28-42-PM.png">

