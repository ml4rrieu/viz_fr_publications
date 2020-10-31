import java.util.Collections;

ArrayList<Publisher> items = new ArrayList<Publisher>();
Table table, output;
IntList allsize = new IntList();
int allpub, margin;

color c_oa, c_closed;

void setup() {
  size(1000, 600);

  String step = "2nd"; //1st

  // __00__  if first step produce publisher table
  if (step.equals("1st")) {
    table = loadTable("../../data/2018_FR_Doi_oatype_202010.csv", "header");
    allpub = table.getRowCount();

    int i = 0;
    for (TableRow row : table.rows()) {
      Boolean finded = false;
      for (Publisher item : items) {
        if (item.name.equals(row.getString("publisher"))) {
          item.update( row.getInt("oaType"));
          finded = true;
        }
      }
      if ( !finded) items.add(new Publisher( row.getString("publisher"), row.getInt("oaType")));
      i+= 1;
    }
    //export publisher csv
    output = new Table();
    output.setColumnTitles(new String [] {"publisher", "size", "closed", "oa"});
    for (Publisher item : items) {
      TableRow newRow = output.addRow();
      newRow.setString("publisher", item.name);
      newRow.setInt("size", item.size);
      newRow.setInt("closed", item.closed);
      newRow.setInt("oa", item.oa);
    }
    saveTable(output, "publisher.csv");
    exit();
  }

  // __00__ if 2nd setp
  if (step.equals("2nd")) {
    table = loadTable("publisher.csv", "header");
    for (TableRow row : table.rows()) {
      items.add(new Publisher(
        row.getString("publisher"), row.getInt("size"), row.getInt("closed"), row.getInt("oa") 
        ));
    }
  }

  println("nb publisher", items.size());
  // but all size in allsize 
  for (Publisher item : items)allsize.append(item.size); 
  allsize.sort();
  println("max paper per publisher ", allsize.max());

  // sort arraylist by size
  Collections.sort(items);
}

void draw() {
  noLoop();
  background(255);

  int minimumDoc = 500;
  int publisherInclude = 0;
  margin = 70;
  c_oa = #665191;
  c_closed =#ffa701;

  for (int i = 0; i < items.size(); i++) {
    Publisher item = items.get(i);
    if (item.size <= minimumDoc) continue;
    item.draw = true;
    item.hsize = map(item.size, allsize.min(), allsize.max(), 0, height-margin*2);
    item.hsizeOa = map(item.oa, allsize.min(), allsize.max(), 0, height-margin*2);
    publisherInclude +=1;
  }

  int iter = 0;
  for (Publisher item : items ) {
    if (!item.draw) continue;
    item.posx = map(iter, 0, publisherInclude, width-margin, margin);
    iter +=1;
  }

  // draw lines
  for (Publisher item : items) item.drawLine();
  // draw legend
  for (Publisher item : items) item.addLabel();

  float ypos;
  int legendColor = 120;
  fill(legendColor);
  stroke(legendColor);
  strokeWeight(0);
  textSize(10);
  textAlign(CENTER, CENTER);

  for (int i = 0; i <= allsize.max(); i++) {
    if (i < minimumDoc) continue;
    if (i % 5000 != 0) continue ;
    ypos = map(i, 0, allsize.max(), 0, height-margin*2);
    text(str(i), margin/2, height-margin-ypos);

    line(margin-2, height-margin-ypos, margin+2, height-margin-ypos);
  }

  
  //axes
   textAlign(LEFT, CENTER);
   text("0", margin/2, height-margin);
   line(margin, height-margin, width-margin, height-margin);
   line(margin, height-margin, margin, margin);
   
   text("Nb of publishers found: " + items.size(), width-200, 120);
   //text("Minimum number of publications: "+ minimumDoc, width-200, 120);
   
   //title
   textSize(20);
   textAlign(CENTER);
   fill(0);
   text(publisherInclude+ " first publishers of French publications in 2018", width/2, 50);
   
   textSize(14);
   fill(c_oa);
   text("open access publications", width/2, 80);
   fill(c_closed);
   text("closed publications", width/2, 100);
   
   save("publisher.png");
   
}
