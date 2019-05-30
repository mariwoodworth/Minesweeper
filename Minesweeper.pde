import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
final static int NUM_ROWS = 20;
final static int NUM_COLS = 20;
final static int NUM_BOMBS = 50;
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
}
public boolean isWon()
{
    int countM = 0;
    int countC = 0;
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++){
            if(buttons[r][c].isMarked())
                countM++;
            else if(buttons[r][c].isClicked())
                countC++;
        }
    }
    int countB = 0;
    for(int i = 0; i < bombs.size(); i++){
        if((bombs.get(i)).isMarked())
            countB++;
    }
    if((countB == bombs.size() && countM + countC == NUM_ROWS*NUM_COLS && countB == countM) && bombs.size() == (NUM_ROWS*NUM_COLS)-countC){
        return true;
    }
    return false;
}
public void displayLosingMessage()
{
    //your code here
    gameOver = true;
    fill(0);
    for(int r=0; r < NUM_ROWS; r++){
        for(int c=0; c < NUM_COLS; c++){
            if(bombs.contains(buttons[r][c])){
               buttons[r][c].clicked = true;
            }
        }    
    }    
    
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
    gameOver = true;
    fill(0);
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
    private boolean clicked, marked, stop;
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
        marked = clicked = stop = false;
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
        if(mouseButton == RIGHT && !isClicked()) { 
          marked = !marked;
          if(marked == true) 
            clicked = true;
          else
            marked = false;
            clicked = false;
        }
        else if(bombs.contains(this) && !marked) {
          gameOver = true;
          displayLosingMessage();
    }
        else if(countBombs(r,c) > 0)
          label = "" + countBombs(r, c) + "";
        else {
          if(isValid(r-1,c) && buttons[r-1][c].isClicked() == false)
            buttons[r-1][c].mousePressed();
          if(isValid(r-1,c-1) && buttons[r-1][c-1].isClicked() == false)
            buttons[r-1][c-1].mousePressed(); 
          if(isValid(r,c-1) && buttons[r][c-1].isClicked() == false)
            buttons[r][c-1].mousePressed();
          if(isValid(r+1,c-1) && buttons[r+1][c-1].isClicked() == false)
            buttons[r+1][c-1].mousePressed();
          if(isValid(r+1,c) && buttons[r+1][c].isClicked() == false)
            buttons[r+1][c].mousePressed();
          if(isValid(r+1,c+1) && buttons[r+1][c+1].isClicked() == false)
            buttons[r+1][c+1].mousePressed();
          if(isValid(r,c+1) && buttons[r][c+1].isClicked() == false)
            buttons[r][c+1].mousePressed();
          if(isValid(r-1,c+1) && buttons[r-1][c+1].isClicked() == false)
            buttons[r-1][c+1].mousePressed();  
        }
          
          
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

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
        for(int i=row-1; i<row+2; i++) {
          for(int j= col-1; i<col-2; j++) {
            if(isValid(i, j) == true && bombs.contains(buttons[i][j]))
              numBombs++;
          }
        } 
        return numBombs; 
    }
    
}
