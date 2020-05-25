import 'dart:async';


import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../pages/home.dart';
import 'package:sssocial/screens/scree.dart';

import '../widgets/loader.dart';



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
  else if(statusCode==401)
  {
    Home().method();
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
      backgroundColor: Colors.white,
    
      appBar: AppBar(),
      body: 
        ListView(
          
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Container(
              height: 100,
              width: 100,
                margin: const EdgeInsets.only(left: 50.0, right: 50.0,top: 10.0),

                      decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage(
              'assets/images/kira.png'),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.rectangle,
        
      ),
          
            ),


            SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                 
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                    child: Text("KiRa OpenSource dataset's powered by ScrapShut,",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600),),
                  ) ,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                    child: Text("Opensource DataSet's for NextGenTech" ,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600)),
                  ) ,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                    child: Text("Project Kira gives you database access of scrapshut  for free ",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                    child: Text("Visit :Developers.scrapshut.com for more info",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.blue)),

                  )
                
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50,left: 50,right: 50),
              child: Container(
                //color: Colors.red,
               height: _tags.isEmpty ? 100 : 50,
               width: double.infinity,
                
                // child: _tags.isEmpty ? Text("KiRa OpenSource dataset's powered by ScrapShut\n Opensource DataSet's for every aspiring technocrat \n Project Kira gives you database access of scrapshut  For Free  \n If want this dataset's  for your organization then please add your tags in  Intrests Section  \n If you want to contribute/support this  opensource initiative you can power it up by posting content\n where your data will be seggregated based on the tags and will be used for creating future tech  " ,          textAlign: TextAlign.center,): 

                child: _tags.isEmpty ? loader(300,300): 
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  //shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _tags.length,
                  itemBuilder: (context,index){
             
                                          return Container(
                                            alignment: Alignment.center,
                  
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
       
           
                
           
                
                   
   
               
                 

                
                    SizedBox(height: 150,),
                 
              
              
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: (){
                    //Home().buildAuth(context);
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Main()));
                        Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    pageBuilder: (BuildContext context, _, __) =>
        SomeDialog(type: "url",)));
    
                    print("tap");

                  },              
                    
                                  child: Container(
                   
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      
                      children: <Widget>[
                        Text( "SKIP",style: TextStyle(fontSize: 20,color: Colors.blue),),
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
class SomeDialog extends StatelessWidget {
  final String type;

  const SomeDialog({Key key, this.type}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black.withOpacity(0.75),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.75) ,
      ),
      
      body: content(type),
    );
  }
}


Widget content(String type)
{
  if(type=="url")
  {
      return new Text("\n                   \n                \n  \n    \n                      \n               \n \n                       \n  \n                                   \n you can rate anything over the internet \n you can review them and let the world know about that ",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),);
  }
  else if(type == "img")
  {
      return new Text("\n                   \n                \n  \n    \n                      \n               \n \n                       \n  \n                                   \n           you can report Fake Images ",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),);
  }
  else if(type == "msg")
  {
      return new Text("\n                   \n                \n  \n    \n                      \n               \n \n                       \n  \n                                   \nRecived Forwarded Fake message \n Forward that message to us and prevent fake things being spread ",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),);
  }
}