import java.awt.geom.Point2D;
//int translateX = 40;
//int translateY = 70;

ArrayList<int[]> bulletPosA = new ArrayList<int[]>();
ArrayList<int[]> bulletPosB = new ArrayList<int[]>();

//int bulletX = gun1x + gunSize * 104 + translateX;
//int bulletY = gun1y + 6 + translateY;



static int MAX_BURST_ANGLE = 45;
static int MAX_BURST_AMOUNT = 10;
static int MAX_BULLET_SPEED = 10;
static int MAX_BURST_SIZE = 10;
static int MAX_BULLET_SIZE = 10;
static int MAX_WAIT_TIME = 10;

static int BURST_ANGLE_INDEX = 0;
static int BURST_AMOUNT_INDEX = 1;
static int BULLET_SPEED_INDEX = 2;
static int BURST_SIZE_INDEX = 3;
static int BULLET_SIZE_INDEX = 4;
static int WAIT_TIME_INDEX = 5;
static int WAIT_COUNTER_INDEX = 6;
static int USAGE_FREQ_INDEX = 7;
static int GUN_CHOICES = 4;
int[][][] guns = new int[2][GUN_CHOICES][8];

static int LEAST_0 = 0;
static int LEAST_1 = 1;

int selectedGunA = 0;
int selectedGunB = 0;

int[] least = new int[]{0,1,1,1,1,1};
int[] max = new int[]{MAX_BURST_ANGLE + 1,MAX_BURST_AMOUNT + 1,MAX_BULLET_SPEED + 1,MAX_BURST_SIZE + 1,MAX_BULLET_SIZE + 1, MAX_WAIT_TIME + 1};

void setup() {
  size(1500, 725);           // Set size of window
  background(4, 118, 189);    // Set background of window to blue
  stroke(0);                  // Sets color of line to black
  strokeWeight(3);            // Set stroke weight to 5
  frameRate(60);              // Sets framerate to 20
  textSize(16);
  
  for(int j = 0; j < 2; j++) {
    for(int i = 0; i < GUN_CHOICES; i++) {
      guns[j][i][0] = (int)random(LEAST_0,MAX_BURST_ANGLE + 1);    // Burst angle
      guns[j][i][1] = (int)random(LEAST_1,MAX_BURST_AMOUNT + 1);   // Burst amount
      guns[j][i][2] = (int)random(LEAST_1,MAX_BULLET_SPEED + 1);   // Bullet speed
      guns[j][i][3] = (int)random(LEAST_1,MAX_BURST_SIZE + 1);     // Burst size
      guns[j][i][4] = (int)random(LEAST_1,MAX_BULLET_SIZE + 1);    // Bullet size
      guns[j][i][5] = (int)random(LEAST_1,MAX_WAIT_TIME + 1);      // Wait time
      guns[j][i][6] = 0;                                           // Wait counter
      guns[j][i][7] = 0;                                           // Usage frequency
    }
  }
}

void draw() {
  background(4, 118, 189);    // Set background of window to blue
  
  drawGun(20,70, selectedGunA, true, 0);
  drawGun(750,70, selectedGunB, false, 1);
  for(int j = 0; j < 2; j++) {
    for(int i = 0; i < GUN_CHOICES; i++) {
      strokeWeight(5);
      if((selectedGunA == i && j == 0) || (selectedGunB == i && j == 1)) {
        stroke(255,223,0);
      }
      fill(0, 35);
      rect(35 + i * 175 + j * 750, 510, 165, 150, 15, 15, 15, 15);
      strokeWeight(3);
      fill(255);
  
      text("Option: " + (i + 1), 45 + i * 175 + j * 750, 530);
      text("Burst Amount: " + guns[j][i][BURST_AMOUNT_INDEX], 45 + i * 175 + j * 750, 550);
      text("Burst Angle: " + guns[j][i][BURST_ANGLE_INDEX], 45 + i * 175 + j * 750, 570);
      text("Bullet Speed: " + guns[j][i][BULLET_SPEED_INDEX], 45 + i * 175 + j * 750, 590);
      text("Rate of Fire: " + (10 - guns[j][i][WAIT_TIME_INDEX] + 1),45 + i * 175 + j * 750, 610);
      text("Bullet Size: " + guns[j][i][BULLET_SIZE_INDEX], 45 + i * 175 + j * 750, 630);
      text("Usage Frequncy: " + guns[j][i][USAGE_FREQ_INDEX], 45 + i * 175 + j * 750, 650);
      stroke(3);
    }
  }
}

void drawGun(int translateX, int translateY, int index, boolean selectedA, int playerIndex) {
  int bulletX = translateX + 142;
  int bulletY = translateY + 107;
  
  int burstAngle = guns[playerIndex][index][BURST_ANGLE_INDEX];
  int burstAmount = guns[playerIndex][index][BURST_AMOUNT_INDEX];
  int bulletSpeed = guns[playerIndex][index][BULLET_SPEED_INDEX];
  int bulletSize = guns[playerIndex][index][BULLET_SIZE_INDEX];
  int waitCounter = guns[playerIndex][index][WAIT_COUNTER_INDEX];
  int waitTime = guns[playerIndex][index][WAIT_TIME_INDEX];
  
  translate(translateX + 70, translateY + 110);
  float tempAngle = atan2(mouseY - (translateY + 110), mouseX - (translateX + 70));
  rotate(tempAngle);
  translate(-1 * (translateX + 70), -1 * (translateY + 110));

  if(mousePressed && (mouseButton == LEFT)) {
    if(waitCounter % waitTime == 0) {
      gunFire(bulletX, bulletY, burstAmount, burstAngle, bulletSpeed, bulletSize, selectedA);
    } else {
       guns[playerIndex][index][WAIT_COUNTER_INDEX]++;
    }
  }
  ArrayList<int[]> bulletPos;
  if(selectedA) {
    bulletPos = bulletPosA;
  } else {
    bulletPos = bulletPosB;
  }

  for(int i = 0; i < bulletPos.size(); i++) {
    int[] bullet = bulletPos.get(i);
    if (bullet[0] - translateX > 300) {
      bulletPos.remove(i);
      i--;
    } else {
      bulletPos.set(i, new int[]{bullet[0] + bullet[3], bullet[1], bullet[2], bullet[3], bullet[4]});
      translate(bulletX, bulletY);
      rotate(bulletPos.get(i)[2] * PI / 180);
      
      rect(bulletPos.get(i)[0] - bulletX, bulletPos.get(i)[1] - bulletY, 7 * bullet[4], 5 * bullet[4], 0, 18, 18, 0);
      rotate(-1 * bulletPos.get(i)[2] * PI / 180);
      
      translate(-1 * bulletX, -1 * bulletY);
    }
  }
  
  fill(4, 118, 189);  // Sets fill in for trigger guard to be background
  rect(translateX + 80, translateY + 120, 20, 20, 0, 0, 18, 0);  // Draws trigger guard of gun
  fill(255);  // Makes body of gun white
  rect(translateX + 130, translateY + 106, 14, 8); // gun muzzle tiny part
  rect(translateX + 130, translateY + 103, 5, 14); // gun muzzle larger part
  rect(translateX + 40, translateY + 100, 90, 25);  // Draws barrel of gun
  rect(translateX + 66, translateY + 132, 16, 40);  // magazine
  rect(translateX + 63, translateY + 125, 22, 40);  // Draws handle of gun
  
  translate(translateX + 70, translateY + 110);
  rotate(-1 * tempAngle);
  translate(-1 * (translateX + 70), -1 * (translateY + 110));
  
  strokeWeight(5);
  fill(0, 25);
  rect(translateX + 315, translateY + 10, 150, 130, 15, 15, 15, 15);
  strokeWeight(3);
  fill(255);
  text("Option: " + (index + 1), translateX + 325, translateY + 30);
  text("Burst Amount: " + burstAmount, translateX + 325, translateY + 50);
  text("Burst Angle: " + burstAngle, translateX + 325, translateY + 70);
  text("Bullet Speed: " + bulletSpeed, translateX + 325, translateY + 90);
  text("Rate of Fire: " + (10 - waitTime + 1), translateX + 325, translateY + 110);
  text("Bullet Size: " + bulletSize, translateX +325, translateY + 130); 
}

void gunFire(int bulletX, int bulletY, int burstAmount, int burstAngle, int bulletSpeed, int bulletSize, boolean selectedA) {
  for(int i = 0; i < burstAmount; i++) {
    if(selectedA) {
      bulletPosA.add(new int[]{bulletX, bulletY, (int)random(-1 * burstAngle, burstAngle), bulletSpeed, bulletSize});
    } else {
      bulletPosB.add(new int[]{bulletX, bulletY, (int)random(-1 * burstAngle, burstAngle), bulletSpeed, bulletSize});
    }
  }
}

void keyPressed() {
  switch(key) {
    case '1':
    case '2':
    case '3':
    case '4':
      selectedGunA = key - '1';
      guns[0][selectedGunA][USAGE_FREQ_INDEX]++;
      break;
    case '6':
    case '7':
    case '8':
    case '9':
      selectedGunB = key - '6';
      guns[1][selectedGunB][USAGE_FREQ_INDEX]++;
      break;
    case ENTER:
      int temp;
      for(int j = 0; j < 2; j++) {
        int maxIndex1 = 0;
        int maxIndex2 = 0;
        int max1 = -1;
        int max2 = -1;
        for(int i = 0; i < GUN_CHOICES; i++) {
          temp = guns[j][i][USAGE_FREQ_INDEX];
          if(max2 < temp) {
            maxIndex2 = i;
            max2 = temp;
            maxIndex1 = maxIndex2;
          } else if(max1 < temp) {
            maxIndex1 = i;
            max1 = temp;
          }
        }
        guns[j][0][0] = guns[j][maxIndex2][0];   // Burst angle
        guns[j][0][1] = guns[j][maxIndex2][1];   // Burst amount
        guns[j][0][2] = guns[j][maxIndex2][2];   // Bullet speed
        guns[j][0][3] = guns[j][maxIndex2][3];   // Burst size
        guns[j][0][4] = guns[j][maxIndex2][4];   // Bullet size
        guns[j][0][5] = guns[j][maxIndex2][5];   // Wait time
        guns[j][0][6] = 0;                       // Wait counter
        guns[j][0][7] = 0;                       // Usage frequency
        
        guns[j][1][0] = guns[j][maxIndex1][0];   // Burst angle
        guns[j][1][1] = guns[j][maxIndex1][1];   // Burst amount
        guns[j][1][2] = guns[j][maxIndex1][2];   // Bullet speed
        guns[j][1][3] = guns[j][maxIndex1][3];   // Burst size
        guns[j][1][4] = guns[j][maxIndex1][4];   // Bullet size
        guns[j][1][5] = guns[j][maxIndex1][5];   // Wait time
        guns[j][1][6] = 0;                       // Wait counter
        guns[j][1][7] = 0;                       // Usage frequency
        
        for(int i = 2; i < GUN_CHOICES; i++) {
          for(int k = 0; k < 6; k++) {
            temp = (int)random(1,11);
            if(temp <= 2) {
              guns[j][i][k] = (int)random(least[k], max[k]);
            } else if(temp <= 5) {
              guns[j][i][k] = guns[j][0][k];
            } else {
              guns[j][i][k] = guns[j][1][k];
            }
            
          }
          guns[j][i][6] = 0;                                           // Wait counter
          guns[j][i][7] = 0;                                           // Usage frequency
        }
      }
      selectedGunA = 0;
      selectedGunB = 0;
      break;
    default:
  }
}

//void keyPressed() {
//    switch(key) {
//      case 'q':
//        if(burstAmount < MAX_BURST_SIZE) {
//           burstAmount++;
//        }
//        break;
//      case 'a':
//        if(burstAmount > LEAST_1) {
//          burstAmount--;
//        }
//        break;
//      case 'w':
//        if(burstAngle < MAX_BURST_ANGLE) {
//          burstAngle++;
//        }
//        break;
//      case 's':
//        if(burstAngle > LEAST_0) {
//          burstAngle--;
//        }
//        break;
//      case 'e':
//        if(bulletSpeed < MAX_BULLET_SPEED) {
//          bulletSpeed++; 
//        }
//        break;
//      case 'd':
//        if(bulletSpeed > LEAST_1) {
//          bulletSpeed--; 
//        }
//        break;
//      case 'r':
//        if(waitTime < MAX_WAIT_TIME) {
//          waitTime++; 
//        }
//        break;
//      case 'f':
//        if(waitTime > LEAST_1) {
//          waitTime--; 
//        }
//        break;
//      case 't':
//        if(bulletSize < MAX_BURST_SIZE) {
//          bulletSize++; 
//        }
//        break;
//      case 'g':
//        if(bulletSize > LEAST_1) {
//          bulletSize--; 
//        }
//        break;
//      default:
//    }
//}
