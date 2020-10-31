class Publisher implements Comparable<Publisher> {
  String name;
  int size, closed, oa;
  boolean draw = false;
  float hsize, hsizeOa, posx;


  Publisher(String _n, int oatype) {
    name = _n;
    size = 1;
    if (oatype != 0) oa+=1;
    else closed += 1;
    //getSize()
  }

  Publisher(String _n, int _s, int _closed, int _oa) {
    name = _n;
    size = _s;
    closed = _closed; 
    oa = _oa;
  }

  @Override
    int compareTo(Publisher other) {
    return this.size - other.size;
  }

  void update(int oatype) {
    size +=1;
    if (oatype != 0) oa+=1;
    else closed +=1;
  }

  
  
  void drawLine() {
    strokeWeight(3);
    stroke(c_closed);
    line(posx, height-margin, posx, (height-margin - hsize) );
    stroke(c_oa);
    strokeWeight(4);
    line(posx, height-margin, posx, (height-margin - hsizeOa) );
  }

  void addLabel() {
    textSize(13);
    if (draw) {
      textAlign(LEFT, CENTER);
      fill(90);
      pushMatrix();
      float y = height - margin - hsize ;
      translate(posx+5, y);
      rotate(-PI/4);
      text(name, 0, 0);
      popMatrix();
    }
  }
}
