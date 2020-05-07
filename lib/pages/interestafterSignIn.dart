import 'dart:async';


import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../pages/home.dart';
import 'package:sssocial/screens/scree.dart';



class InterestA extends StatefulWidget {
  @override
  _InterestAState createState() => _InterestAState();
}

class _InterestAState extends State<InterestA> {
 bool _validateU = false;
   bool isUpdate = false;
   List<dynamic> _tags;
   bool isSuccess = false;
  


   TextEditingController _interest;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
   @override
  void initState() {
    // TODO: implement initState
    _tags = new List<dynamic>();
    _interest = TextEditingController();
    
    _makeGetRequest();
    super.initState();
  }
  _makeGetRequest() async {
    String bvalue = await storage.read(key: 'btoken');
  // make GET request
  String url = 'https://backend.scrapshut.com/user/profile/';
   Map<String, String> headers = {"Authorization":"JWT $bvalue",
          "Content-Type":"application/json"};

//   Map<String, String> headers = {"Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VybmFtZSI6Im1vdW5pa2VzaHRob3RhIiwiZXhwIjoxNTg4OTcxMzI0LCJlbWFpbCI6Im1vdW5pa2VzaHRob3RhQGdtYWlsLmNvbSJ9.bt8mRWeCHcrffPR5u6oOJ6l_4uCrSlpJu13nO_duoaY",
// "Content-Type":"application/json"};
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
  setState(() {
    _tags = results[0]["tags"];
  });
 
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
    String bvalue = await storage.read(key: 'btoken');
  // set up PUT request arguments
  String url = 'https://backend.scrapshut.com/user/profile/';
    Map<String, String> headers = {"Authorization":"JWT $bvalue",
          "Content-Type":"application/json"};
//    Map<String, String> headers = {"Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VybmFtZSI6Im1vdW5pa2VzaHRob3RhIiwiZXhwIjoxNTg4OTcxMzI0LCJlbWFpbCI6Im1vdW5pa2VzaHRob3RhQGdtYWlsLmNvbSJ9.bt8mRWeCHcrffPR5u6oOJ6l_4uCrSlpJu13nO_duoaY",
// "Content-Type":"application/json"};
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
    setState(() {
      isSuccess = true;
    });
    
    


    }
    // setState(() {
    //   isUpdate = false;
    // });
    setState(() {
      _makeGetRequest();
    });
   
  
}

   _makePostReq(List<String> tags) async
  {
    String bvalue = await storage.read(key: 'btoken');

  String url = 'https://backend.scrapshut.com/user/profile/';
  Map<String, String> headers = {"Authorization":"JWT $bvalue",
          "Content-Type":"application/json"};
//   Map<String, String> headers = {"Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VybmFtZSI6Im1vdW5pa2VzaHRob3RhIiwiZXhwIjoxNTg4OTcxMzI0LCJlbWFpbCI6Im1vdW5pa2VzaHRob3RhQGdtYWlsLmNvbSJ9.bt8mRWeCHcrffPR5u6oOJ6l_4uCrSlpJu13nO_duoaY",
// "Content-Type":"application/json"};
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
    setState(() {
      isSuccess = true;
    });


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
              height: 100,
              width: 100,
              
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50,left: 80,right: 20),
              child: Container(
                //color: Colors.red,
                height: 50,
                width: 200,
                child: _tags.isEmpty ? Text("Getting your data") : 
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _tags.length,
                  itemBuilder: (context,index){
                    return Container(
                      height: 3,
                      
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: (BorderRadius.circular(40)),
                        color: index%2==0 ? Colors.orangeAccent : Colors.greenAccent,
                        
      
                      ),
                      
                        
                        
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(_tags[index].toString().toUpperCase(),textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w800,),),
                        ),
                      );
                  } ),
              ),
            ),
            SizedBox(height: 20,),
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
              ),
              SizedBox(height: 200,),
              
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Main()));
                  },              
                    
                                  child: Container(
                   
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      
                      children: <Widget>[
                        Text( isSuccess ? "CONTINUE" :"SKIP",style: TextStyle(fontSize: 20,color: Colors.blue),),
                        Icon(Icons.arrow_forward_ios,color: Colors.blue)
                      ],
                    )),
                ),
              )
          ],
        ),
      
    );
  }
}