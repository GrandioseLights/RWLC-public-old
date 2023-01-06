static final String RED = "\u001B[31m";
static final String GREEN = "\u001B[32m";
static final String BLUE = "\u001B[34m";
static final String YELLOW = "\u001B[33m";
static final String PURPLE = "\u001B[35m";
static final String CYAN = "\u001B[36m";
static final String WHITE = "\u001B[37m";
static final String BLACK = "\u001B[30m";

static final String bg_RED = "\u001B[41m";
static final String bg_GREEN = "\u001B[42m";
static final String bg_BLUE = "\u001B[44m";
static final String bg_YELLOW = "\u001B[43m";
static final String bg_PURPLE = "\u001B[45m";
static final String bg_CYAN = "\u001B[46m";
static final String bg_BLACK = "\u001B[40m";
static final String bg_WHITE = "\u001B[47m";

static final String RESET = "\u001B[0m ";


void log(String msg){
  println(bg_WHITE+BLACK+"[LOG]:"+RESET+msg);
}

void log(String type, String msg){
  switch (type){
    case "write":
      println(bg_WHITE+BLACK+"[LOG]:"+RESET+msg);
    break;
    case "warn":
      println(YELLOW+"[WARN]:"+RESET+msg);
    break;
    case "error":
      println(bg_RED+BLACK+"[ERR]:"+RESET+msg);
    break;
    case "fatal":
      println(bg_BLACK+RED+"[FATAL ERR]:"+RESET+msg);
    break;
    case "debug":
      println(bg_BLUE+WHITE+"[DEBUG]:"+RESET+msg);
    break;
  }
}
void log(int i){
  println(bg_BLUE+WHITE+"[DEBUG]:"+RESET+i);
}