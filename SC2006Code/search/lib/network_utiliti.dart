import 'package:http/http.dart' as http;

class NetworkUtil{
  Future<String>? fetchUrl(Uri uri,{Map<String,String>? headers}) {
    try{
      final response = await http.get(uri,headers:headers);
      
    } catch(e){

    }
  }

}