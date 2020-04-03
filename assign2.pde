final int ROG_START_X = 320;
final int ROG_START_Y = 80;
final int SOLDIER_RANGE =0;
final int SOLDIER_Y = 160;
final int ROBOT_Y = 160;
final int BLOCK = 80;


//GAMESTATE
final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
final int GAME_WIN = 3;
int gameState = GAME_START;

//BUTTON
final int BUTTON_LEFT = 248;
final int BUTTON_UP = 360;
final int BUTTON_DOWN = 420;
final int BUTTON_RIGHT = 392;

//rog move
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

//life
boolean newLife = false;
int newLifeX;
int heartNum;


PImage  bg,life,robot,soil,soldier,cabbage;
PImage  startImg,overImg,restartHovered,restartNormal,startHovered,startNormal;
PImage  groundhogIdle,groundhogDown,groundhogLeft,groundhogRight;

int randRobot,randSoldier;
float hogX , hogY , hogSpeed;
float hogMoveX,hogMoveY;
float soldierX=0.0, soldierY , soldierSpeed;
float cabbageX , cabbageY;


void setup() {
  size(640, 480, P2D);
  bg = loadImage("img/bg.jpg");
  life = loadImage("img/life.png");
  robot = loadImage("img/robot.png");
  soil = loadImage("img/soil.png");
  soldier = loadImage("img/soldier.png");
  cabbage = loadImage("img/cabbage.png");
  
  //game start & end
  startImg = loadImage("img/title.jpg");
  overImg = loadImage("img/gameover.jpg");
  restartHovered = loadImage("img/restartHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  startHovered = loadImage("img/startHovered.png");
  startNormal = loadImage("img/startNormal.png");
  
  //groundhog
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  
  
  //soldier
  randSoldier = floor(random(0,4));
  soldierY = SOLDIER_Y + randSoldier*80;
  soldierSpeed = floor(random( 1,3 )) ;
  
  
  //groundhog
  hogX = ROG_START_X;
  hogY = ROG_START_Y;
  
  //cabbage
  cabbageX=floor(random(0,8))*BLOCK;
  cabbageY= 160+floor(random(0,4))*BLOCK;
  
  //life
  heartNum = 2;
}

void draw() {
  
  //game button
  switch( gameState ){
    case GAME_START:
      image( startImg ,0,0 );
      if( mouseX > BUTTON_LEFT && mouseX < BUTTON_RIGHT 
      && mouseY > BUTTON_UP && mouseY < BUTTON_DOWN  ){
        image( startHovered , BUTTON_LEFT , BUTTON_UP );
        
        if( mousePressed ){
          gameState = GAME_RUN;
        }
      }else{
        image( startNormal , BUTTON_LEFT , BUTTON_UP );
      }
      break;
      
    case GAME_RUN:
      //bg picture
      image( bg,0,0,width,height );
      
      //grass
      fill( 124,204,25 );
      noStroke();
      rect( 0,145,640,335 );
      image( soil,0,160 );
      
      //sun
      fill( 255,255,0 );
      ellipse( 590,50,130,130 );
      fill( 253,184,19 );
      ellipse( 590,50,120,120 );
      
      
      //soldier
      image( soldier, soldierX ,soldierY );
      break;
      
    case GAME_OVER:
      image( overImg,0,0  );
      
      if( mouseX > BUTTON_LEFT && mouseX < BUTTON_RIGHT 
      && mouseY > BUTTON_UP && mouseY < BUTTON_DOWN  ){
        
        image( restartHovered , BUTTON_LEFT , BUTTON_UP );
        
        if( mousePressed ){
          //cabbage
          cabbageX=floor(random(0,8))*BLOCK;
          cabbageY= 160+floor(random(0,4))*BLOCK;
          
          //soldier
          randSoldier = floor(random(0,4));
          soldierY = SOLDIER_Y + randSoldier*80;
          soldierSpeed = floor(random( 1,3 )) ;
          
          gameState = GAME_RUN;
          heartNum = 2;
          newLife = false;
        }
      }else{
        image( restartNormal , BUTTON_LEFT , BUTTON_UP );
      }
     break;
          
        
  }
   
 //GAME RUN
  if( gameState == GAME_RUN ){
  
    //soldier
    soldierX += soldierSpeed;
    
    if( soldierX>640 ){
      soldierX = -100;
    }
    
    //cabbage  newlife
    if( !newLife ){
      image( cabbage,cabbageX,cabbageY );
      
      if( hogX>=cabbageX && hogX<(cabbageX+BLOCK) ){
        if( hogY==cabbageY ){
          heartNum --;
          newLife = true;
        }
      }
    }
    
   //amount of heart
    switch( heartNum ){
      case 1:
        image( life,150,10 );
      
      case 2:
        image( life,80,10 );
        
      case 3:
        image( life,10,10 );
        break;
      
    }
    
    //meet soldier lose heart
    if( hogY==soldierY ){
      
      if( (hogX+BLOCK) > (soldierX+BLOCK) && hogX < (soldierX+BLOCK)  ){
        heartNum ++;
        hogX = ROG_START_X;
        hogY = ROG_START_Y;
      }
      if( (hogX+BLOCK) > soldierX && hogX < soldierX  ){
        heartNum ++;
        hogX = ROG_START_X;
        hogY = ROG_START_Y;
      }
    }
    
    
      
      //no heart game over
      if( heartNum>3 ){
        gameState = GAME_OVER;
      }
    
      //groundhog move
      if( rightPressed ){
        if( hogMoveX<=hogX ){
          image( groundhogRight , hogMoveX, hogY );
          hogMoveX += 5;
        }else{
          rightPressed = false;
        }
      }
      else if(leftPressed){
        if( hogMoveX>=hogX ){
          image( groundhogLeft , hogMoveX, hogY );
          hogMoveX -= 5;
        }else{
          leftPressed = false;
        }
      }
      else if(downPressed){
        if( hogMoveY<=hogY ){
          image( groundhogDown , hogX, hogMoveY );
          hogMoveY += 5;
        }else{
          downPressed = false;
        }
      }
      else{
        image( groundhogIdle,hogX,hogY );
      }
      
    }
}

void keyPressed(){
  
  switch( keyCode ){
    case LEFT:
      hogMoveX = hogX;
      if( hogX>0 ){
        leftPressed = true;
        hogX -= BLOCK;
      }
      break;
      
    case RIGHT:
      hogMoveX = hogX;
      if( hogX<560 ){
        rightPressed = true;
        hogX += BLOCK;
      }
      break;
      
    case DOWN:
      hogMoveY = hogY;
      if( hogY<400 ){
        downPressed = true;
        hogY += BLOCK;
      }
      break;   
   }
}
