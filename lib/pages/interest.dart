import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../widgets/loader.dart';
import 'home.dart';
final storage = new FlutterSecureStorage();

class Interest extends StatefulWidget {
  @override
  _InterestState createState() => _InterestState();
}

class _InterestState extends State<Interest> {
  bool _validateU = false;
   bool isUpdate = false;
   List<dynamic> _tags;
   bool isSuccess = false;
   bool isFetching = false;



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
    setState(() {
      isFetching = true;
    });
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
  setState(() {
    isFetching = false;
  });
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
    setState(() {
      isFetching = true;
    });
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
  setState(() {
    isFetching = false;
  });
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
    
            child: Text(
                "For Organiation's or student's who wants to use opensource  dataset's \n  please update your tags \n Visit: \"Developers.scrapshut.com\"\n For more INFO ",
          textAlign: TextAlign.center,
    
        ),
            padding: new EdgeInsets.all(50.0),
              height: 200,
              width: 200,
             
),
            Padding(
              padding: const EdgeInsets.only(top: 40,left:30 ,right: 20),
              child: Container(
              //color: Colors.red,
                height: _tags.isEmpty? 100 : 50,
                width: 200,
                child: _tags.isEmpty ? loader(100, 100) : 
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
            SizedBox(height: 40,),
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
                child: isFetching ? loader(200, 200)  : RaisedButton(
                  
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
              
          ],
        ),
      
    );
  }
}