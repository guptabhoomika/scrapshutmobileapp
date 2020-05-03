import 'dart:convert';

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
    super.initState();
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
    setState(() {
      isUpdate = false;
    });
  
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
    else if(statusCode==400)
    {
      setState(() {
        isUpdate = true;
      });
      final snackBar = new SnackBar(
        content: Text("Data Already Exists! Press Update"),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.black,
        action: new SnackBarAction(label: "Ok",textColor: Colors.white, onPressed: (){
          
          
              
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
    
            child: Text(
                " KiRa dataset's powered by ScrapShut\n Opensource DataSet's for every aspiring technocrat \n The data you give = The data you get \n Submit your tags \ E.g: ML,AI,OpenCV,Marketing \n Based on your Interest\n visit \"Developers.scrapshut.com\" ",
          textAlign: TextAlign.center,
    
        ),
            padding: new EdgeInsets.all(30.0),
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
               
                  _makePutRequest(_interest.text.toString().split(",").toList());

                
                    
                  },
                ),
              )
          ],
        ),
      
    );
  }
}