class Type {
  String typeName, label;
  color c;
  int typeNumber, percent;
  float size, rectSize, posx; 
  int alpha = 170;

  Type(String _n, int _tn, color _c, String _label) {
    typeName = _n ; 
    typeNumber = _tn;
    c = _c;
    label = _label;
    getSize();
    calcRectSize();

    if (label == "suspicious journal") alpha = 240;
  }


  void getSize() {
    for (TableRow row : table.findRows(str(typeNumber), "oaType")) {
      size +=1 ;
    }
    percent = round(size/ allpub  * 100);
  }

  void calcRectSize() {
    rectSize = map(size, 0, allpub, 0, width);
  }

  void graph() {
    noStroke();
    fill(c);
    rect(posx, 0, rectSize, height);
  }

  void addLabel(float ylabel) {
    textAlign(CENTER, CENTER);
    fill(255, alpha);
    pushMatrix();
    translate( posx+rectSize/2, ylabel);
    rotate(-HALF_PI);
    textSize(15);
    text(label, 0, 0);
    popMatrix();
  }

  void addPercent(float ypercent) {
    fill(255);
    textSize(20);
    text(str(percent) + "%", posx+rectSize/2, ypercent);
  }


  void printVal() {
    println(typeName);
    println(size, '\t', round(rectSize), '\t', round(posx));
  }
}
