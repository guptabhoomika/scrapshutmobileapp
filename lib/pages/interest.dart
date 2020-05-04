import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'home.dart';

class Interest extends StatefulWidget {
  @override
  _InterestState createState() => _InterestState();
}

class _InterestState extends State<Interest> {
   bool _validateU = false;
   bool isUpdate = false;
   
   TextEditingController _interest;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
   @override
  void initState() {
    // TODO: implement initState
    _interest = TextEditingController();
    _makeGetRequest();
    super.initState();
  }
  _makeGetRequest() async {
  // make GET request
  String url = 'https://backend.scrapshut.com/user/profile/';

  Map<String, String> headers = {"Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VybmFtZSI6Im1vdW5pa2VzaHRob3RhIiwiZXhwIjoxNTg4OTcxMzI0LCJlbWFpbCI6Im1vdW5pa2VzaHRob3RhQGdtYWlsLmNvbSJ9.bt8mRWeCHcrffPR5u6oOJ6l_4uCrSlpJu13nO_duoaY",
"Content-Type":"application/json"};
  Response response = await get(url,headers: headers);
  // sample info available in response
  int statusCode = response.statusCode;
  print(statusCode);
  if(statusCode==200)
  {
    String json = response.body;
  print(json);
  Map<String,dynamic> val =jsonDecode(response.body);
  List<dynamic> results = val['results'];
  print(results);
  List<dynamic> _tags = results[0]["tags"];
  if(_tags.isEmpty)
  {
    print("empty,post req");
  }  
  else
  {
    print("not empty,put req");
    setState(() {
      isUpdate = true;
    });
    // print(_tags);
  }

  

  }
  else
  {
    print("Error in getting response");
  }
 

  


  
 

  // TODO convert json to object...
}
  _makePutRequest(List<String> tags) async {
  // set up PUT request arguments
  String url = 'https://backend.scrapshut.com/user/profile/';
   Map<String, String> headers = {"Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VybmFtZSI6Im1vdW5pa2VzaHRob3RhIiwiZXhwIjoxNTg4OTcxMzI0LCJlbWFpbCI6Im1vdW5pa2VzaHRob3RhQGdtYWlsLmNvbSJ9.bt8mRWeCHcrffPR5u6oOJ6l_4uCrSlpJu13nO_duoaY",
"Content-Type":"application/json"};
  String json = jsonEncode({
			
            "tags":tags
});
  print(json);

  // make PUT request
  Response response = await put(url, headers: headers, body: json);
  // check the status code for the result
  int statusCode = response.statusCode;
  // this API passes back the updated item with the id added
  print(statusCode);
  if(statusCode==200)
    {
       final snackBar = new SnackBar(
        content: Text("Succesful"),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.black,
        action: new SnackBarAction(label: "Ok",textColor: Colors.white, onPressed: (){
          _interest.clear();
          
              
        }),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);


    }
    // setState(() {
    //   isUpdate = false;
    // });
  
}

   _makePostReq(List<String> tags) async
  {
    String bvalue = await storage.read(key: 'btoken');

  String url = 'https://backend.scrapshut.com/user/profile/';
  // Map<String, String> headers = {"Authorization":"JWT $bvalue",
  //         "Content-Type":"application/json"};
  Map<String, String> headers = {"Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VybmFtZSI6Im1vdW5pa2VzaHRob3RhIiwiZXhwIjoxNTg4OTcxMzI0LCJlbWFpbCI6Im1vdW5pa2VzaHRob3RhQGdtYWlsLmNvbSJ9.bt8mRWeCHcrffPR5u6oOJ6l_4uCrSlpJu13nO_duoaY",
"Content-Type":"application/json"};
          print(headers);
  String json = jsonEncode({
			
            "tags":tags
});
  print(json);

  // make POST request

  Response response = await post(url,headers: headers, body: json);
  print(response.body);
   int statusCode = response.statusCode;
   print(statusCode);
    if(statusCode==201)
    {
       final snackBar = new SnackBar(
        content: Text("Succesful"),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.black,
        action: new SnackBarAction(label: "Ok",textColor: Colors.white, onPressed: (){
          _interest.clear();
          
              
        }),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);


    }
   
    
   
  
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: 
        ListView(
          
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
            ),
            Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("Interest",style: TextStyle(color: Colors.grey)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 45,
                          width: 250,
                          child: TextField(
                            
                            controller: _interest,
                            textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                
                                    hintText: 'Use , to separate',
                                     errorText: _validateU ? 'Value Can\'t Be Empty' : null,

                                    hintStyle: TextStyle(color: Colors.grey,),
                                    focusedBorder: OutlineInputBorder(
                    
                        borderSide: BorderSide(color: Colors.blue),

                    ),
                     enabledBorder: OutlineInputBorder(
                     
                        borderSide: BorderSide(color: Colors.blue),
                     ),
  ),
),
                        ),
                      )
                      
                    ],
                  ),
                  Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: RaisedButton(
                  
                  color: Colors.blue,
                  child: Text(isUpdate ? "Update" : "Submit",style: TextStyle(color: Colors.white),),
                  onPressed: ()  {
                     setState(() {
                   _interest.text.isEmpty ? _validateU = true : _validateU = false;
                  
                });
                if(!_validateU&&!isUpdate)
                {
                  _makePostReq(_interest.text.toString().split(",").toList());
                }
                if(!_validateU)
                {
                   _makePutRequest(_interest.text.toString().split(",").toList());
                }
               
                 

                
                    
                  },
                ),
              )
          ],
        ),
      
    );
  }
}