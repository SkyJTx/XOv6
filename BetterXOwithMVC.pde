void setup(){
    size(600,800);
}

float w = 600; //width
int n = 3; //n*n grid

//XO with MVC (Class Inheritance)
Controller c = new Controller();
Model m = new Model(c,n,w);
View v = new View(m);

void mousePressed(){
    c.press(mouseX,mouseY);
    m.process();
}

void draw(){
    v.show();
}
