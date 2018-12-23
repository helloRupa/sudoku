# Sudoku

Play Sudoku using command line. Programmed in Ruby. Requires plain text file puzzles where '0' represents empty spaces. Can be extended to accept more filetypes by modifiying puzzle_loader.rb.

## Gameplay

Select a number from 0 to 9, and then input the coordinates for where that value should be placed. Once each row, column and 3x3 square consists of numbers 1-9 without any repeats in a column/row/3x3 the game is won.

## Solver

The computer will solve the puzzle for you. If there is no possible solution, a runtime error "Unsolvable puzzle" will result.

**To solve the puzzle:**
1. The program will generate a list of possible values for each space. If a space has only one possible value, it'll place that value on the board, and after going through all spaces, will regenerate possibilities until the board is solved or every unfilled space has more than one possible value.

2. The program will go through each space updating it with a possible value in order from its list of possible values. After the space is updated, it is checked for validity (i.e. no repeats).

3. If the update is valid, the program moves on to the next coordinate. Otherwise, it moves on to the next possible value for the same space. 

4. If the last value in the array of possibilities for a single space is invalid, that space will be set to '0', and the program will then backtrack until it is able to update a previous space with a valid value.