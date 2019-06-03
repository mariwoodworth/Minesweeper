import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
public boolean gameOver = false;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r=0; r<NUM_ROWS; r++) {
      for(int c=0; c<NUM_COLS; c++) {
        buttons[r][c] = new MSButton(r, c);
      }
    }
    for(int b =0; b < NUM_BOMBS ; b++) 
      setBombs();
}
public void setBombs()
{
   while(bombs.size() < NUM_BOMBS) {
      int row = (int)(Math.random()*NUM_ROWS);
      int col = (int)(Math.random()*NUM_COLS);
      if(buttons[row][col].isValid(row, col) && !bombs.contains(buttons[row][col]) )
        bombs.add(buttons[row][col]);
        //System.out.println(row + "," + col);  
   } 
}

public void draw ()
{
    background( 0 );
    if(isWon())
      displayWinningMessage();
    if(gameOver == true)
      displayLosingMessage();
}
public boolean isWon()
{
  for(int r=0; r<NUM_ROWS; r++) {
    for(int c=0; c<NUM_COLS; c++) {
      if(buttons[r][c].isClicked() == false && !bombs.contains(buttons[r][c]))
        return false;
    }
  }
  return true;
}
public void displayLosingMessage()
{
    //your code here
  buttons[10][6].setLabel("Y");
  buttons[10][7].setLabel("o");
  buttons[10][8].setLabel("u");
  buttons[10][10].setLabel("L");
  buttons[10][11].setLabel("o");
  buttons[10][12].setLabel("s");
  buttons[10][13].setLabel("e");
  buttons[10][14].setLabel("!");
  
}
public void displayWinningMessage()
{
    //your code here
  buttons[10][6].setLabel("Y");
  buttons[10][7].setLabel("o");
  buttons[10][8].setLabel("u");
  buttons[10][10].setLabel("W");
  buttons[10][11].setLabel("i");
  buttons[10][12].setLabel("n");
  buttons[10][13].setLabel("!");
  
}

public class MSButton
{
  private int r, c;
  private float x,y, width, height;
  private boolean clicked, marked;
  private String label;
    
  public MSButton ( int rr, int cc )
    {
      width = 400/NUM_COLS;
      height = 400/NUM_ROWS;
      r = rr;
      c = cc; 
      x = c*width;
      y = r*height;
      label = "";
      marked = clicked = false;
      Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
     return marked;
    }
    public boolean isClicked()
    {
     return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
      clicked = true;
      //your code here
      if(keyPressed == true) {
        marked = !marked;
        if(marked == false)
          clicked = false;
      } 
      else if(bombs.contains(this)) {
        clicked = true;
        gameOver = true;
      }
      else if(countBombs(r,c) > 0)
        setLabel(str(countBombs(r,c)));
      else {
        for(int rw = r-1; rw < r+2; rw++) {
          for(int co = c-1; co < c+2; co++) {
            if(isValid(rw,co) && !buttons[rw][co].isClicked())
              buttons[rw][co].mousePressed();
            }
          }  
        }
    }

    public void draw () 
    {    
      if (marked)
       fill(255);
      else if(clicked && bombs.contains(this) ) 
        fill(135,106,255); 
      else if(clicked)
        fill(107,209,247);
      else if(gameOver == true && bombs.contains(this))
        fill(255,0,0); 
      else 
         fill(191,237,255);  

      rect(x, y, width, height);
      fill(0);
      text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
      label = newLabel;
    }
    public boolean isValid(int r, int c)
    {  
      if(r < 0 || c < 0)
       return false;
      else if(r < NUM_ROWS && c < NUM_COLS)
       return true;
      else 
        return false;
          
    }
    public int countBombs(int row, int col)
    { 
     int numBombs = 0; 
     for(int r=row-1; r<row+2; r++) {
       for(int c= col-1; c<col+2; c++) {
         if(isValid(r,c) && bombs.contains(buttons[r][c]))
            numBombs++;
          }
        } 
         return numBombs; 
    }
    
}
