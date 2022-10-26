class View{
    Model m;
    float[][] aniFrame = new float[3][3];
    float gridscale;
    float scale;
    int ngrid;
    View(Model m){
        this.m = m;
        this.gridscale = m.getGridScale();
        this.ngrid = m.getGrid();
        this.scale = m.getScale();
        this.aniFrame = new float[this.ngrid][this.ngrid];
    }
    
    float tanh(float x){ // hyperbolic tan
        return (exp(x)-exp(-x))/(exp(x)+exp(-x));
    }
    
    float bell(float x){ // bell curve
        return exp(-pow(x,2));
    }

    float anifunc(float x,float f){ // function for animation. anifunc(60,f) = f
        return f*(tanh(0.04*x)+0.2*bell(0.04*x-1));
    }
    
    void drawgrid(int bg,int R,int G,int B){ // drawing a 3*3 grid
        background(bg); // background color
        int i;
        int j = 0;
        while (j < this.ngrid){
            i = 0;
            while (i < this.ngrid){
                fill(40);
                stroke(R,G,B); // grid's stroke color
                strokeWeight(this.gridscale/15); // thickness
                rect(this.gridscale*i,this.gridscale*j+this.scale/2,this.gridscale,(this.scale*4-this.scale)/this.ngrid,15); // create grid
                i = i + 1;
            }
            j = j + 1;
        }
    }
    
    void drawmessage(float x,float y,float size,String text,float fillR,float fillG,float fillB){ // create message
        textAlign(CENTER); // alignment
        fill(fillR,fillG,fillB); // text color
        textSize(size); // text size
        text(text,x,y); // text
    }
    
    void drawmessagebox(float x,float y,float sizeX,float sizeY,String text,float fillR,float fillG,float fillB,float fillTextR,float fillTextG,float fillTextB){ // create text box
        fill(fillR,fillG,fillB); // color for box
        stroke(255,255,255); // box's stroke color
        strokeWeight(min(sizeX,sizeY)/10); // box thickness
        rect(x,y,sizeX,sizeY,15); // create box
        textAlign(CENTER,CENTER); // text alignment
        textSize(min(sizeX,sizeY)/2); // text size
        fill(fillTextR,fillTextG,fillTextB); // text color
        text(text,x+sizeX/2,y+sizeY/2.3); // create text
    }
    
    void drawturn(){ // decision turn text prompt
        if (m.getTurn() == 1){ // if it is turn x
            drawmessage(width/2,this.scale/5,this.scale/4,"X turn",255,255,255);
        }
        if (m.getTurn() == -1){ // if it is turn o
            drawmessage(width/2,this.scale/5,this.scale/4,"O turn",255,255,255);
        }
    }
    
    void drawhint(){ // hint text prompt
        if (m.checkhint() && m.getMove() != 8){ // check condition for hint
            drawmessage(width/2,this.scale/2.5,this.scale/8,"Someone is gonna win. Do something.",255,10,0); // create hint text prompt
        }
    }
    
    void display(){ // display inGame
        drawgrid(40,255,215,0); // grid
        drawturn(); // turn prompt
        drawhint(); // hint prompt
        drawmessagebox(this.scale*0.25,3*this.scale+2*this.scale/3,this.scale/2,this.scale/4,"SAVE",255,215,0,40,40,40); // save box
        drawmessagebox(this.scale*1.25,3*this.scale+2*this.scale/3,this.scale/2,this.scale/4,"LOAD",255,215,0,40,40,40); // load box
        drawmessagebox(this.scale*2.25,3*this.scale+2*this.scale/3,this.scale/2,this.scale/4,"RESET",255,215,0,40,40,40); // reset box
    }
    
    void displayendgame(){ // endGame
        background(40); // background color
        int turn = -m.getTurn(); // reverse turn
        if ( m.checkwin() ){ // for win
            if (turn == 1){ // x win
                drawmessage(width/2,height/2,this.scale/2,"X Win!",255,255,255);
            }
            if (turn == -1){ // o win
                drawmessage(width/2,height/2,this.scale/2,"O Win!",255,255,255);
            }
        }
        if ( m.checktie() ){ // for tie
            drawmessage(width/2,height/2,this.scale/2,"Tie!",255,255,255);
        }
        drawmessagebox(this.scale*0.25,3*this.scale+2*this.scale/3,this.scale/2,this.scale/4,"LOAD",255,215,0,40,40,40); // load box
        drawmessagebox(this.scale*2.25,3*this.scale+2*this.scale/3,this.scale/2,this.scale/4,"START",255,215,0,40,40,40); // start box
    }
   
    void x(int i,int j,float frame,int fillR,int fillG,int fillB){
        float c = 4; // constant to divide scale
        float x = j*this.gridscale+this.gridscale/2;
        float y = i*this.gridscale+this.scale/2+this.gridscale/2;
        stroke(fillR,fillG,fillB); // stroke color of x
        strokeWeight(this.gridscale/15); // thickness
        strokeCap(ROUND); // cap
        line(x-anifunc(frame,this.gridscale/c),y-anifunc(frame,this.gridscale/c),x+anifunc(frame,this.gridscale/c),y+anifunc(frame,this.gridscale/c)); // \
        stroke(fillR,fillG,fillB); // stroke color of x
        strokeWeight(this.gridscale/15); // thickness
        strokeCap(ROUND); // cap
        line(x-anifunc(frame,this.gridscale/c),y+anifunc(frame,this.gridscale/c),x+anifunc(frame,this.gridscale/c),y-anifunc(frame,this.gridscale/c)); // /
    }
    
    void o(int i,int j,float frame,int fillR,int fillG,int fillB){
        float c = 4; // constant to divide scale
        float x = j*this.gridscale+this.gridscale/2;
        float y = i*this.gridscale+this.scale/2+this.gridscale/2;
        stroke(fillR,fillG,fillB); // stroke color of o
        strokeWeight(this.gridscale/15); // thickness
        ellipse(x,y,anifunc(frame,this.gridscale/c*2),anifunc(frame,this.gridscale/c*2)); // o
    }
    
    void show(){
        if ( !( this.m.checkwin() || this.m.checktie() ) ){
            display();
            if ((this.m.inReset_inGame() || this.m.inLoad_inGame()) && mousePressed){
                this.aniFrame = new float[this.ngrid][this.ngrid];
            }
            int i = 0;
            int j = 0;
            while (i < this.ngrid){
                j = 0;
                while (j < this.ngrid){
                    if ( this.m.getPos(i,j) == 1){
                        x(i,j,aniFrame[i][j],255,255,255);
                        if (this.aniFrame[i][j] < 60){
                            this.aniFrame[i][j] = this.aniFrame[i][j] + 2;
                        }
                    }
                    if ( this.m.getPos(i,j) == -1){
                        o(i,j,aniFrame[i][j],255,255,255);
                        if (this.aniFrame[i][j] < 60){
                            this.aniFrame[i][j] = this.aniFrame[i][j] + 2;
                        }
                    }
                    j = j + 1;
                }
                i = i + 1;
            }
        }
        if (this.m.checkwin() || this.m.checktie()){
            displayendgame();
            this.aniFrame = new float[this.ngrid][this.ngrid];
        }
    }
}
