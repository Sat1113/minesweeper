int [][] mineGrid; // The main mines grid, which tracks which squares are mines, and the count of adjacent mines
boolean isFirstClick; // Tracks the first click of the player to initialize the mineGrid
int numMines; // Game setting for the total number of mines in the game
int remainingMines; // Tracks how many mines the player has flagged
int screen = 0; // Tracks which screen the player is on
int [][] squareDisplayStatus; // Keeps track of which squares should be  displayed, which squares have flags, and which are still hidden
Square firstSquareClicked; // Stores the first square clicked by the player because it cannot be a mine and cannot be flagged
boolean steppedOnMine; // Tracks if player steps on a mine
PImage start; // The welcome screen background
PImage flag; // Flag image
PImage bomb; // Bomb image


/*
A class is like a blueprint for a programming object.
It defines the variables and functions that objects of that class can have. 
Objects are instances of a class.
You can create multiple objects with similar characteristics and functionalities using a class 
You are basicaly decribing somthing (the object) and what it does. 
Classes can be get compelex but I used a simple one in order to track each box on the game grid 
using row and column numbers
I had tried using separate int Row and Column variables but I couldn't keep track of all the squares that way
so I learned basic of class for this 
*/

class Square
{
  // This object is used to represent any square in the game.
  // Makes it easy to track rows and column of a square
  int Row;
  int Column;
  // This is a default function that initializes all the variables of this object
  Square()
  {
    Row = 0;
    Column = 0;
  }
}

void setup() 
{ 
  size(900, 1000);
  frameRate(60);
  start = loadImage("background.png"); 
  flag = loadImage("flag.png");
  bomb= loadImage("bomb.png");
  surface.setTitle("Minesweeper -- by Satwika Pujari"); 
  initializeGame(); // used to setup the whole game   
}
void initializeGame()
{
  // This function resets all the game variables and objects and prepares a new game. 
  // This is separated from the setup function because we would need to use it multiple times when resetting the game
  mineGrid = new int [9][9];
  firstSquareClicked = new Square();
  numMines = 10;
  remainingMines = numMines;
  isFirstClick = false; //game starts with empty grid when clicked on game screen. Then items are placed as so no bombs on first click
  squareDisplayStatus = new int [9][9];
  steppedOnMine = false;
  // By default all squares are hidden i.e. 0
  for (int i = 0; i < 9; i++) 
  {
    for (int j = 0; j < 9; j++)
    {
      // 0 = Hidden
      // 1 = Show
      // 2 = Flagged
      //-1 = mine
      squareDisplayStatus[i][j] = 0;
    }
  }
}
void draw () 
{ 
  if (screen == 0) 
  {
    // Show the Welcome screen
    background(0);
    image(start,-200,0);
    drawButton(200,600,200,50, "Play");
    drawButton(500,600,200,50, "Rules");    
  }
  
  if (screen == 1)
  {
    // Main game screen -- draw all the squares
    background(255);
    for (int i = 0; i < 9; i++) 
    {
      for (int j = 0; j < 9; j++)
      {
        int x = i * width / 9; 
        int y = j * 900 / 9; 
        fill(17,131,256);
        rect(x, y, width / 9, width / 9);        
      }
    }
    //  the remaining mines counter
    fill(0); // Black color for remaining mine count
    textSize(30);    
    text("Mines Remaining : " + remainingMines, 30, 950);
    
    // Show squares that have visibility boolean set to true
    for(int i = 0; i < 9; i++)
    {
      for(int j = 0; j < 9; j++)
      {
        if(squareDisplayStatus[i][j] > 0)
        {
          showSquare(i, j);
        }
       }
    }
      
   
  }
  
  if(screen == 2) 
  {
    // Win screen
    background(255);
    
    // Draw all the squares
    for (int i = 0; i < 9; i++) 
    {
      for (int j = 0; j < 9; j++)
      {
        int x = i * width / 9; 
        int y = j * 900 / 9; 
        fill(17,131,256);
        rect(x, y, width / 9, width / 9);        
      }
    }
    
    // Show all the squares and all the values    
    for(int i = 0; i < 9; i++)
    {
      for(int j = 0; j < 9; j++)
      {
        showSquare(i, j);        
      }
    }
    
    // Show the win message
    fill(0);
    textSize(30);
    text("Congratulations -- You found all the mines !!", 30, 950);
    // Show the Back button to restart
    drawButton(620,920,200,50, "Home");
  }  
  if(screen == 3) 
  {
    // Lose screen
    background(255);
    
    // Draw all the squares
    for (int i = 0; i < 9; i++) 
    {
      for (int j = 0; j < 9; j++)
      {
        int x = i * width / 9; 
        int y = j * 900 / 9; 
        fill(17,131,256);
        rect(x, y, width / 9, width / 9);        
      }
    }
    
    // Show all the squares and all the values    
    for(int i = 0; i < 9; i++)
    {
      for(int j = 0; j < 9; j++)
      {
        showSquare(i, j);        
      }
    }
    
    // Show the lose message
    fill(0);
    textSize(30);
    if(steppedOnMine)
    {
      text("Game Over -- You stepped on a mine :-(", 30, 950);      
    }
    else
    {
      // The player must have lost the game because they did not flag all the mines or flagged a non mine square
      text("Game Over -- You did not find all the mines :-(", 30, 950);
    }
    // Show the Back button to restart
    drawButton(620,920,200,50, "Try Again");
  }
  if(screen == 4)
  {
    // Rules screen
    background(0);
    textSize(70); 
    fill(255);
    text("Rules",300,80);
    textSize(30);
    text("1. The goal is to find all the mines without stepping on one", 15,150); 
    text("2. The number shows how many bombs are in the 8 adjacent squares", 15,200); 
    text("3. If You think a square is safe, left click.", 15,250);
    text("4. Right click a square to flag it as a mine", 15,300);
    text("5. If you use up all the flags and all bombs are not flagged, you lose", 15,350); 
    text("6. If you flag all the mines, you win!", 15,400); 
    text("7. Have Fun and don't step on a bomb!", 15,450); 
   
    drawButton(50,800,200,50, "Back");
    drawButton(600,800,200,50, "Play");
  }
}

void mousePressed() 
{
  if(screen == 1 ) // Main game screen
  {
    // Get coordinates of which point was click
    if(mouseY > 0 && mouseY <= 900) // Player clicked a box within the game area
    {      
      // if(!isFirstClick && firstSquareClicked.Row == 0 && firstSquareClicked.Column == 0 && mouseButton == LEFT)
      if(isFirstClick == false && firstSquareClicked.Row == 0 && firstSquareClicked.Column == 0)
      {
        // This is the first time the player has clicked in game
        // First Square Clicked is also 0
        
        // However, if the first click was a right-click -- ignore
        if(mouseButton == RIGHT)
        {
          return;
        }      
        
        // The player clicked the first box to start the game
        isFirstClick = true;
        
        // Set the First Square Clicked object
        Square clickedSquare = new Square();
        calculateSquarePressed(clickedSquare);
        
        // We need to track the first square clicked because the createMines() function needs to know which square should not have a mine
        firstSquareClicked.Row = clickedSquare.Row;
        firstSquareClicked.Column = clickedSquare.Column;
        
        createMines();
        // Fill the rest of the squares with mine counts for adjacent squares
        fillNonMineSquares();
        
        // Set the display status for the clicked square to 1
        squareDisplayStatus[firstSquareClicked.Column - 1][firstSquareClicked.Row - 1] = 1; // Show the square        
      }
      else
      {
        if(isFirstClick || (firstSquareClicked.Row == 0 && firstSquareClicked.Column == 0))
        {
          // Subsequent click
          if(mouseButton == LEFT)
          {
            Square clickedSquare = new Square();
            calculateSquarePressed(clickedSquare);
            if(mineGrid[clickedSquare.Column - 1][clickedSquare.Row - 1] == -1)
            {
              // Player hit a mine
              steppedOnMine = true;
              screen = 3;
            }
            else
            {
              // Player clicked a square that was not a mine and not a flag either
              // Set the display status for the clicked square to true so that when draw() runs it will show the square
              squareDisplayStatus[clickedSquare.Column - 1][clickedSquare.Row - 1] = 1;
            }
          }
          if(mouseButton == RIGHT)
          {            
            Square clickedSquare = new Square();
            calculateSquarePressed(clickedSquare);
            
            // Check if this square was already flagged
            if(squareDisplayStatus[clickedSquare.Column - 1][clickedSquare.Row - 1] == 2)
            {
              // Square was already flagged -- ignore
              return;
            }
            // Check if this square in the first square clicked to start the game -- first square cannot be flagged
            if(clickedSquare.Column == firstSquareClicked.Column && clickedSquare.Row == firstSquareClicked.Row)
            {
              // Player tried to flag the first square, which is already shown -- ignore
              return;
            }
            
            // Flag the square as a possible mine
            squareDisplayStatus[clickedSquare.Column - 1][clickedSquare.Row - 1] = 2;
            remainingMines--;
            if(remainingMines == 0)
            {
              // Player has flagged 10 mines -- calculate whether the player won or lost
              if(gameResult())
              {
                screen = 2; 
              }
              else
              {
                // Lost
                screen = 3;
              }
            }
          }          
        }
      }
    }
    else
    {
      // Player clicked outside the game area -- ignore
    }
  }
  
  if (screen == 0) //for using buttons
  {
    if (mouseX > 200 && mouseX <= 400 && mouseY >= 600 && mouseY <= 650)
    {
      screen = 1;
    }
    if (mouseX > 500 && mouseX <= 700 && mouseY >= 600 && mouseY <= 650)
    {
      screen = 4; 
    }
  }
   if (screen == 4)
  {
    if (mouseX > 50 && mouseX <= 250 && mouseY >= 800 && mouseY <= 850)
    {
      screen = 0;
    }
    if (mouseX > 600 && mouseX <= 800 && mouseY >= 800 && mouseY <= 850)
    {
      screen = 1; 
    }
  }
  
   if (screen == 3||screen == 2)
  {
    if (mouseX > 620 && mouseX <= 820 && mouseY >= 900 && mouseY <= 970)
    {
      screen = 0;
      initializeGame(); 
    }
  }
}

boolean gameResult()
{
  boolean result = true;
  for(int i = 0; i < 9; i++)
  {
    for(int j = 0; j < 9; j++)
    {
      if(mineGrid[i][j] >= 0)
      {
        // This square was not a mine - check if the player flagged it
        if(squareDisplayStatus[i][j] == 2)
        {
          // Player flagged a non mine square as a mine -- lost game
          return false;
        }
      }
      // At this point, the player has not flagged a non mine square as a mine
      // Check if they flagged every mine
      if(mineGrid[i][j] == -1)
      {
        // This square is a mine
        if(squareDisplayStatus[i][j] != 2)
        {
          // Player did not flag this mine
          return false;
        }
      }
    }
  }
  // If we reached this point, it means the player did not flag any non mine squares as a mine,
  // and flagged all the mines - game won
  return result;
}
void createMines()
{
  int i = 0;
  int randomRow;
  int randomColumn;
  while(i < numMines)
  {
    randomRow = floor(random(9));
    randomColumn = floor(random(9));
    if(mineGrid[randomRow][randomColumn] == -1)
    {
      // Square is already a mine -- skip and keep looping
    }
    else
    {
      if(randomRow == (firstSquareClicked.Row - 1) && randomColumn == (firstSquareClicked.Column - 1))
      {
        // The first square clicked by the player must not be a mine -- skip 
      }
      else
      {
        mineGrid[randomRow][randomColumn] = -1;
        i++;
      }
    }
  }  
}

void fillNonMineSquares()
{
  // Loop through all the elements of the mines array and fill the non-mine squares 
  // with the counts of the number of mines in the adjacent 8 squares
  int numberOfMines = 0;
  for(int i = 0; i < 9; i++)
  {
    for(int j = 0; j < 9; j++)
    {
      if(mineGrid[i][j] == -1)
      {
        // This square is already a mine -- do nothing
      }
      else
      {
        // This square does not have a mine
        // Calculate the number of mines in the adjacent 8 squares and store it in this square
        numberOfMines = getNumberOfMines(i, j);
        mineGrid[i][j] = numberOfMines;
      }
    }
  }
}

int getNumberOfMines(int row, int column)
{
  // This function takes a row and column number as arguments and calculates the number of mines in the adjacent 8 squares of this square
  int numberOfMines = 0;
  for (int i = row - 1; i <= row + 1; i++)
  {
    for (int j = column - 1; j <= column + 1; j++)
    {
      // Check if the current adjacent square is within the mineGrid boundaries
      if (i >= 0 && i < 9 && j >= 0 && j < 9)
      {
        // Check if the adjacent square contains a mine
        if (mineGrid[i][j] == -1)
        {
          numberOfMines++;
        }
      }
    }
  }
  return numberOfMines;
}

void showSquare(int row, int column)
{
  // This function displays either a mine or the count of adjacent mines in the current square
  if(mineGrid[row][column] == -1)
  {
    // This square is a mine
    
    // fill(255, 0, 0);
    // rect((row * width / 9), (column * 900 / 9), 100, 100);
    
    // Check if it was already flagged
    if(squareDisplayStatus[row][column] == 2)
    {
      // Square was already flagged -- do nothing
      // It will show the flag with the next if() statement
    }
    else
    {  
      // Square was not flagged -- show the bomb
      image(bomb,(row * width / 9), (column * 900 / 9),100,100);
    }
  }
  if(squareDisplayStatus[row][column] == 2)
  {
    // Square was flagged by the player -- show the flag
   // fill(0, 255, 0); 
    //rect((row * width / 9), (column * 900 / 9), 100, 100);  
    image(flag,(row * width / 9), (column * 900 / 9),99,99);
    return; // Don't proceed to show the adjacent mine count
  }
  if(mineGrid[row][column] >= 0)
  {
    //This square is not a mine - show adjacent mine count
    fill(0); // Black color for mine count
    textSize(25);
    if (mineGrid[row][column] >= 0)
    {
      text(mineGrid[row][column], (row * width / 9) + width / 18, (column * 900 / 9) + width / 18);
    }
  }
}

void calculateSquarePressed(Square sq) 
{
  
  // Get the coordinates of the clicked square  
  if(mouseX >= 0 && mouseX < 100)
  {
    sq.Column = 1;
  }
  if(mouseX >= 100 && mouseX < 200)
  {
    sq.Column = 2;
  }
  if(mouseX >= 200 && mouseX < 300)
  {
    sq.Column = 3;
  }
  if(mouseX >= 300 && mouseX < 400)
  {
    sq.Column = 4;
  }
  if(mouseX >= 400 && mouseX < 500)
  {
    sq.Column = 5;
  }
  if(mouseX >= 500 && mouseX < 600)
  {
    sq.Column = 6;
  }
  if(mouseX >= 600 && mouseX < 700)
  {
    sq.Column = 7;
  }
  if(mouseX >= 700 && mouseX < 800)
  {
    sq.Column = 8;
  }
  if(mouseX >= 800 && mouseX < 900)
  {
    sq.Column = 9;
  }
  
  if(mouseY >= 0 && mouseY < 100)
  {
    sq.Row = 1;
  }
  if(mouseY >= 100 && mouseY < 200)
  {
    sq.Row = 2;
  }
  if(mouseY >= 200 && mouseY < 300)
  {
    sq.Row = 3;
  }
  if(mouseY >= 300 && mouseY < 400)
  {
    sq.Row = 4;
  }
  if(mouseY >= 400 && mouseY < 500)
  {
    sq.Row = 5;
  }
  if(mouseY >= 500 && mouseY < 600)
  {
    sq.Row = 6;
  }
  if(mouseY >= 600 && mouseY < 700)
  {
    sq.Row = 7;
  }
  if(mouseY >= 700 && mouseY < 800)
  {
    sq.Row = 8;
  }  
  if(mouseY >= 800 && mouseY < 900)
  {
    sq.Row = 9;
  }
  if(mouseY >= 900)
  {
    // Player clicked in the score and time counter area -- ignore
    sq.Row = 0;
    sq.Column= 0;
  }    
}

void drawButton(int x, int y, int w , int h, String text) //to make the buttons
{ 
  if(mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h)
  {
    fill(255,0,0); 
  }
  else
  {
    fill(255);
  }
  rect(x, y, w, h);
  textSize(20);
  fill(0);
  text(text, x + w*0.5- textWidth(text)*0.5, y + h - 15);
}
