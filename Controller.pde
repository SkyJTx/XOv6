class Controller{
    int xcoor;
    int ycoor;
    Controller(){
    }
    
    void updateX(int posX){
        this.xcoor = posX;
    }
    
    void updateY(int posY){
        this.ycoor = posY;
    }
    
    void press(int posX,int posY){
        updateX(posX);
        updateY(posY);
    }
    
    int getX(){
        return this.xcoor;
    }
    
    int getY(){
        return this.ycoor;
    }    
}
