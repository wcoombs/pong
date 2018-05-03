/*****************
 William Coombs
 COMP 1010 A01
 Assignment 2
 Question 2 - Pong
 *****************/

/*****************
 Create a version
 of the classic
 game, Pong.
 *****************/

// canvas properties
final int CANVAS_SIZE = 500;
final int BG_COLOR = 0;
final int width = CANVAS_SIZE;
final int height = CANVAS_SIZE;
final int WHITE_COLOR = 255; // the color of the paddles and the ball

// paddle properties
final float PADDLE_SIZE_X = width/10;
final float PADDLE_SIZE_Y = height/50;
float topPaddleX; // top paddle's x-coordinate, later defined by the mouse minus the paddle size x
final float TOP_PADDLE_Y = (height/25)*3; // top paddle's y-coordinate, as a fixed value based on canvas size, with room for score
final float PADDLE_SPEED = 15; // movement speed of the bottom paddle
float bottomPaddleX; // bottom paddle's x-coordinate, later defined in addition with the paddle speed
final float BOTTOM_PADDLE_Y = height-TOP_PADDLE_Y-(height/50); // bottom paddle's y-coordinate, as a fixed value based on canvas size, with room for score

// ball properties
float ballX;
float ballY;
final float BALL_SIZE = height/50; // ball's size as a fixed value based on canvas size
float theta;
float ballMoveX; // x-coordinate of the ball's movement, defined later in terms of trigonometry
float ballMoveY; // y-coordinate of the ball's movement, defined later in terms of trigonometry
final float radius = 3; // the speed at which the ball moves

// scoreboard properties
final String TOP_SCORE_TEXT = "Top score: "; // identifier text for top player's score
int topScore = 0;
final String BOTTOM_SCORE_TEXT = "Bottom score: "; // identifier text for bottom player's score
int bottomScore = 0;
final int textSize = 12;

boolean ballActive = false;

void setup()
{
  size(CANVAS_SIZE, CANVAS_SIZE);
}


void draw()
{
  background(BG_COLOR);
  stroke(WHITE_COLOR);
  fill(WHITE_COLOR);

  // saves the score text and the numbers as they change in real-time
  String TOP_SCORE = TOP_SCORE_TEXT + topScore;
  String BOTTOM_SCORE = BOTTOM_SCORE_TEXT + bottomScore;

  if (ballActive == false) // if the ball has gone off the screen, create a new one
  {
    ballX = width/2; // generate a new ball in the center x-coordinate
    ballY = height/2; // generate a new ball in the center y-coordinate
    theta = random(TWO_PI); // generate a random angle with which the new ball will travel

    /***************************************************************************************************************************************
     If the randomly generated theta value from above is close to 0, PI, or 2*PI, then the following trigonometric calculations for
     ballMoveY and ballMoveX yields a value at or very close to 0 for the y-movement. When this happens, the ball simply bounces from edge
     to edge with barely any movement up or down. To prevent this from happening, we check what the randomly generated value of theta is.
     
     If theta is at or between 0 and PI/6 or is at or between 5*PI/6 and PI, that means the ball is headed down, but in such a way that it
     will bounce from side to side with barely any movement down. To prevent this, a new theta value is generated, bound between PI/6 and
     5*PI/6. This allows the ball to still move down, as that factor was determined from the original randomly generated theta value, but
     not side to side with barely any movement down.
     
     This same technique is applied if the randomly generated value of theta is at or between PI and 7*PI/6 or is at or between 11*PI/6 and
     2*PI. If this happens, that means the ball is headed up, but in such a way that it will bounce from side to side with barely any
     movement up. To prevent this, a new theta value is generated, bound between 7*PI/6 and 11*PI/6. This allows the ball to still move up,
     as that factor was determined from the original randomly generated theta value, but not side to side with barely any movement up.
     
     Neither of these checks affects the overall speed of the ball, as it will still move at a rate of the radius.
     ***************************************************************************************************************************************/

    // check if the original theta value causes the ball to move side to side with barely any movement down
    if ((theta >= 0 && theta < PI/6) || (theta >= 5*PI/6 && theta < PI))
    {
      theta = random(PI/6, 5*PI/6); // the theta value is regenerated to instead be bound between PI/6 and 5*PI/6
    }
    // check if the original theta value causes the ball to move side to side with barely any movement up
    if ((theta >= PI && theta <= 7*PI/6) || (theta >= 11*PI/6 && theta <= TWO_PI))
    {
      theta = random(7*PI/6, 11*PI/6); // the theta value is regenerated to instead be bound between 7*PI/6 and 11*PI/6
    }

    ballMoveX = radius*cos(theta); // calculates how far the ball moves in the x-direction
    ballMoveY = radius*sin(theta); // calculates how far the ball moves in the y-direction, after adjustment, to prevent side-to-side movement
    ballActive = true;
  } else {
    if (ballActive == true)
    {
      ballX += ballMoveX;
      ballY += ballMoveY;
      if (ballX > width || ballX < 0) // if the ball hits either edge of the screen
      {
        ballMoveX *= -1; // reverses the ball's direction
      }
      if (ballY >= BOTTOM_PADDLE_Y) // if the ball passes the y-coordinate of the bottom of the bottom paddle (the side closest to the edge)
      {
        ballActive = false;

        // increase top player's score
        topScore++;
      }
      if (ballY <= TOP_PADDLE_Y) // if the ball passes the y-coordinate of the bottom of the top paddle (the side closest to the edge)
      {
        ballActive = false;

        // increase bottom player's score
        bottomScore++;
      }
    }
  }

  // top paddle hit detection
  if (ballY <= TOP_PADDLE_Y + BALL_SIZE) // BALL_SIZE is added so the ball bounces when it's edge hits the paddle
  {
    if (ballX <= topPaddleX + PADDLE_SIZE_X && ballX >= topPaddleX)
    {
      ballMoveY *= -1; // reverses the direction of the ball if the ball hits the paddle
    }
  }

  // bottom paddle hit detection
  if (ballY >= BOTTOM_PADDLE_Y - BALL_SIZE) // BALL_SIZE is subtracted so the ball bounces when it's edge hits the paddle
  {
    if (ballX <= bottomPaddleX + PADDLE_SIZE_X && ballX >= bottomPaddleX)
    {
      ballMoveY *= -1; // reverses the direction of the ball if the ball hits the paddle
    }
  }

  // top paddle movement
  topPaddleX = mouseX-PADDLE_SIZE_X/2; // moves the top paddle, centered on the mouse, based on the x-coordinate of the mouse
  topPaddleX = max(topPaddleX, 0); // prevents the paddle from moving off the left edge of the screen
  topPaddleX = min(topPaddleX, width-PADDLE_SIZE_X); // prevents the paddle from moving off the right edge of the screen

  // bottom paddle movement
  if (keyPressed)
  {
    if (key == CODED)
    {
      if (keyCode == LEFT)
      {
        bottomPaddleX -= PADDLE_SPEED; // moves the paddle left if the left arrow key is pressed
      } else if (keyCode == RIGHT)
      {
        bottomPaddleX += PADDLE_SPEED; // moves the paddle right if the right arrow key is pressed
      }
    }
  }
  bottomPaddleX = max(bottomPaddleX, 0); // prevents the paddle from moving off the left edge of the screen
  bottomPaddleX = min(bottomPaddleX, width-PADDLE_SIZE_X); // prevents the paddle from moving off the right edge of the screen

  // draw the score for both the top and bottom players
  textSize(textSize);
  text(TOP_SCORE, width/20, (height/25));
  text(BOTTOM_SCORE, width-(width/4), height-(height/25));

  ellipse(ballX, ballY, BALL_SIZE, BALL_SIZE); // draws the ball
  rect(topPaddleX, TOP_PADDLE_Y, PADDLE_SIZE_X, PADDLE_SIZE_Y); // draws the top paddle
  rect(bottomPaddleX, BOTTOM_PADDLE_Y, PADDLE_SIZE_X, PADDLE_SIZE_Y); // draws the bottom paddle
}

