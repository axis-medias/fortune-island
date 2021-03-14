//globals.dart file
library my_prj.globals;

String id_membre="";
String token;
num credits=0;
num gems=0;
String OneSignal_ID="";

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}
