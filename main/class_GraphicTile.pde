ArrayList<GraphicTile> array_graphicTiles = new ArrayList<GraphicTile>();

class GraphicTile{
  String category, name;
  color colour;
  int w, h;
  int[] geo_1, geo_2, slices;
  int padding, variants;
  String[] tags;
  String pack;
  String[] authors;
  PImage sheet_image, editor_image;
  GraphicTile(File file){ // Create a graphic tile from file.
    String[] data=loadStrings(file);
    category =              data[0];
    colour = color(parseInt(data[1]));
    name =                  data[2];
    w =            parseInt(data[3]);
    h =            parseInt(data[4]);
    padding =      parseInt(data[5]);
    geo_1 =stringToIntArray(data[6]);
    geo_2 =stringToIntArray(data[7]);
    slices=stringToIntArray(data[8]);
    variants =     parseInt(data[9]);
    tags =            split(data[10],',');
    pack =                  data[11];
    authors =         split(data[12],',');
    sheet_image =imageFromString(data[13]);
    editor_image=imageFromString(data[14]);
    array_graphicTiles.add(this);

    TableRow row = graphic_table.addRow();
    row.setInt   ("id", graphic_table.lastRowIndex());
    row.setString("Category", category);
    row.setInt   ("Colour", colour);
    row.setString("Name", name);
    row.setInt   ("Width", w);
    row.setInt   ("Height", h);
    row.setInt   ("Padding", padding);
    row.setInt   ("Variants", variants);
    row.setString("Pack", pack);
  }
}