ArrayList<Type> items = new ArrayList<Type>();

Table table;
IntDict data;
float allpub;

void setup() {
  data = new IntDict();
  size(900, 700);
  background(240);
  int margin = 5;

  table = loadTable("../../data/2018_FR_Doi_oatype_202010.csv", "header");
  allpub = table.getRowCount();

  items.add(new Type("archive", 4, #665191, "archive and not OA journal"));
  items.add(new Type("archivePlusJournal", 5, #a05195, "archive plus OA journal"));
  items.add(new Type("journalOnly", 6, #d45287, "OA journal only"));
  items.add(new Type("hybrid", 3, #ff7c43, "not OA journal but licence"));
  items.add(new Type("bronz", 2, #ffa701, "not OA journal and no licence"));
  items.add(new Type("suspicious", 1, #7E7A7A, "suspicious journal"));
  items.add(new Type("closed", 0, #D1D1D1, "closed"));


  // __x___ calcule posx de tous les rectangles
  for (int i = 1; i < items.size(); i ++) {
    Type current = items.get(i);

    for (int j = 0; j < i; j++) {
      Type precedent = items.get(j);
      current.posx += precedent.rectSize;
    }
  }

  println("allpub", allpub);
  int sum = 0 ; 
  for(Type me : items) sum+= me.size;
  println("publi concernés", sum);
  println('\n');
  for (Type me : items) me.printVal();
}

void draw() {
  noLoop();
  for (Type me : items) me.graph();

  for (int i=0; i < items.size(); i++) {
    float ylabel, ypercent ; 

    if (i % 2 == 0 ) {
      ylabel = height/4 - height/12;
      ypercent = height-height*0.05;
    } else {
      ylabel = height/4 + height/12;
      ypercent = height-height*0.1;
    }

    Type me = items.get(i);
    me.addLabel(ylabel);
    if (me.typeName != "suspicious") me.addPercent(ypercent);
  }


  textAlign(CENTER, CENTER); 
  textSize(200); 
  fill(255, 40); 
  text("2018", width/2, 2.0/3*height);
  save("oatype2018.png");
}
