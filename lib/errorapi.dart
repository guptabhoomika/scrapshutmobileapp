import 'package:http/http.dart' as http;
class ErrorApi
{
    error(int code) async
    {

      Map<String,String> headers ={
        "API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"
      };
      print("https://backend.scrapshut.com/api/report/error/$code");

      http.Response response = await http.get("https://backend.scrapshut.com/api/report/error/$code",headers: headers);
      print("error api");
      print(response.statusCode);
      print(response.body);
      return response;
    }
}