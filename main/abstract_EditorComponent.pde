abstract class EditorComponent{
  protected HashMap<List<Integer>,int[]> data = new HashMap<List<Integer>,int[]>();
  String displayName = "EditorComponent.displayName";
  void setData(String new_data){
    setData(new_data, this.displayName);
    log("warn","A EditorComponent displayName was not provided to setData. Using default.");
  }
  void setData(String new_data, String displayName){
    this.displayName = displayName;
    data.clear();
    try{
      for(String entry : new_data.split(";")){
        String[] def = entry.split(":");
        List<Integer> pos = Arrays
          .asList(def[0].split(","))
          .stream().map(s->Integer.parseInt(s))
          .collect(Collectors.toList()); // Get key
        int[] specs = {0,0};
        String[] specs_str;
        try{specs_str = def[1].split(",");}
        catch(ArrayIndexOutOfBoundsException e){specs_str = "".split(",");}
        for (int i=0;i<specs_str.length;i++){specs[i]=Integer.valueOf(specs_str[i]);} // Get value
        data.put(pos, specs);
      }
    }catch(NumberFormatException e){log("error",e.toString());}
  }
  String getData(){
    String data_out="";
    try{
      for (List<Integer> pos: data.keySet()){data_out+=pos.toString()+":"+Arrays.toString(data.get(pos))+";";}
      int i = data_out.lastIndexOf(";");
      return (new StringBuilder(data_out).replace(i, i+1,"").toString()).replace(" ", "").replace("[","").replace("]", "");
    }catch(StringIndexOutOfBoundsException e) {return "";}
  }
  int[] get(int[] position){return data.get(intArrToList(position));}
  protected float menu_delta = 0; // Delta value for menu stuff. Between 0 and 1.
  private boolean focused_surface = false; // If this surface is being edited.
  private int show_menu = 0; // Used for menu stuff, boolean int.
  protected void calculate_delta(){
    if(focused_surface&&show_tools&&editor_focused){show_menu = 1;}else{show_menu = 0;};
    if(menu_delta>0.99){
      menu_delta=1;
      if (show_menu==0) menu_delta = 0.99;
    }else if(menu_delta<0.01){
      menu_delta=0;
      if(show_menu==1)menu_delta = 0.01;
    }else{menu_delta = lerp(menu_delta, show_menu, 0.3);}
    show_menu=0;
  }
  public void showUI() {calculate_delta(); displayMenu(); focused_surface=false;}
  abstract void displayMenu();
  public void onEdit(){focused_surface = true; if(editing_allowed)edit();}
  abstract void edit();
  abstract void add(int[] position, int[] specs);
  abstract void remove(int[] position);
  abstract void drawLayer(int layer, color c);
}