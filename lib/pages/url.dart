import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sssocial/errorapi.dart';
import 'package:sssocial/services.dart';
 
import  '../pages/home.dart';
import '../widgets/loader.dart';
import 'monetizePage.dart';

class URL extends StatefulWidget {
  @override
  _URLState createState() => _URLState();
}
final storage = new FlutterSecureStorage();

class _URLState extends State<URL> {
 
   final String email = "ayushagr2000@gmail.com";
   final String email2 = "guptabhoomika2000@gmail.com";
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _url;
  TextEditingController _review;
  TextEditingController _tags;
  int ratings;
  bool _validateU = false;
   bool _validateR = false;
    bool _validateT = false;
    bool isfake = false;
    bool isanonymous = false;
    bool isFetching = false;
    List<String> _monteizedata = List<String>();
    Map<String,String> _advertisement = Map<String,String>();
  

 
  @override
  void initState() {
    _url = TextEditingController();
    _review = TextEditingController();
    _tags = TextEditingController();
   

  
    // TODO: implement initState
    super.initState();
  }
  
  

_showSnackBar(int stauscode) {
    print("Show Snackbar here !");
    final snackBar = new SnackBar(
        content: stauscode == 201 ? new Text("Succesful") : new Text("There is some error"),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.black,
        action: new SnackBarAction(label: stauscode == 201 ? 'Ok' : "Try Again",textColor: Colors.white, onPressed: (){
         _review.clear();_tags.clear();_url.clear();ratings=0;
        }),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  _makePostReq(String urlC,List<String> tags,int rating,String review) async
  {
    setState(() {
      isFetching = true;
    });
    String bvalue = await storage.read(key: 'btoken');

  String url = 'https://backend.scrapshut.com/api/post/';
  // Map<String, String> headers = {"Authorization":"JWT $bvalue",
  //         "Content-Type":"application/json"};
  Map<String, String> headers = {"Authorization":"JWT ${bvalue}",
"Content-Type":"application/json","API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"};
//  Map<String, String> headers = {"Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VybmFtZSI6Im1vdW5pa2VzaHRob3RhIiwiZXhwIjoxNTg4OTcxMzI0LCJlbWFpbCI6Im1vdW5pa2VzaHRob3RhQGdtYWlsLmNvbSJ9.bt8mRWeCHcrffPR5u6oOJ6l_4uCrSlpJu13nO_duoaY",
// "Content-Type":"application/json"};
          print(headers);
  String json = jsonEncode({
			"rate": rating,
            "content": "content",
            "review": review,
            "url": urlC,
            "tags":tags,
            "fake": isfake,
            "anonymous":isanonymous,
            "advertisement" : _advertisement
            

});
  //print(json);

  // make POST request

  Response response = await post(url,headers: headers, body: json);
  print(response.body);
  setState(() {
    isFetching = false;
  });
  print(response.statusCode);
   int statusCode = response.statusCode;
   if(statusCode == 201)
   {
       print("statusCode");
     print(statusCode);
     _showSnackBar(statusCode);

   }
   else {
     print("Status code");
     Services.sendmail(response.body);
   }
  //  else if(statusCode == 401)
  //  {
  //    final snackBar = new SnackBar(
  //       content: Text("Unauthorized access"),
  //       duration: new Duration(seconds: 3),
  //       backgroundColor: Colors.black,
  //       action: new SnackBarAction(label: "LogOut",textColor: Colors.white, onPressed: (){
              
  //             Home().method();
  //       }),
  //   );
  //   //How to display Snackbar ?
  //   _scaffoldKey.currentState.showSnackBar(snackBar);

  //  }
  //    else if(statusCode == 500)
  //  {
  //    final snackBar = new SnackBar(
  //       content: Text("Server error please contact team@scrapshut.com"),
  //       duration: new Duration(seconds: 3),
  //       backgroundColor: Colors.black,
  //       action: new SnackBarAction(label: "Ok",textColor: Colors.white, onPressed: (){
  //         _review.clear();_tags.clear();_url.clear();ratings=0;
              
  //       }),
  //   );
  //   //How to display Snackbar ?
  //   _scaffoldKey.currentState.showSnackBar(snackBar);

  //  }
  // else if(statusCode == 400)
  //  {
  //    Map<String,dynamic> err = jsonDecode(response.body);
  //    print(err);
    
   
  //    final snackBar = new SnackBar(
  //       content: Text(response.body.substring(response.body.indexOf(":")+2,response.body.length-2)),
  //       duration: new Duration(seconds: 3),
  //       backgroundColor: Colors.black,
  //       action: new SnackBarAction(label: "Ok",textColor: Colors.white, onPressed: (){
  //         _review.clear();_tags.clear();_url.clear();ratings=0;
              
  //       }),
  //   );
  //   //How to display Snackbar ?
  //   _scaffoldKey.currentState.showSnackBar(snackBar);

  //  }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: ListView(
      padding: EdgeInsets.all(8),
          
      
           
            children: <Widget>[
              Container(
                height: 220,
                width: 150,
                 decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage(
              'assets/images/scrap_withoutbg.png'),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.rectangle,
      ),
               
              ),
              // Text("The More data you give = the more data you get",style: TextStyle(color: Colors.red),),
              // Text("developers.scrapshut.com",style: TextStyle(color: Colors.red)),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("URL*",style: TextStyle(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 45,
                      width: 250,
                      child: TextFormField(
                        keyboardType: TextInputType.url,
                        controller: _url,
                        textAlign: TextAlign.center,
                              decoration: InputDecoration(
                            
                                hintText: 'URL',
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
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                   Text("Rating*",style: TextStyle(color: Colors.grey)),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: RatingBar(
                    
   initialRating: 0,
   minRating: 1,
   direction: Axis.horizontal,
   allowHalfRating:false,
   itemCount: 5,
    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
   itemBuilder: (context, _) => Icon(
     Icons.star,
     color: Colors.amber,
   ),
   onRatingUpdate: ( rating) {
    ratings = rating.toInt();
   },
),
                   )

                ],
              ),
               SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Review*",style: TextStyle(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      width: 250,
                      child: TextField(
                        controller: _review,
                        textAlign: TextAlign.center,
                              decoration: InputDecoration(
                              
                                hintText: "Review helps others identify false comments",
                                errorText: _validateR ? 'Value Can\'t Be Empty' : null,

                                hintStyle: TextStyle(color: Colors.grey,fontSize: 10),
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
               SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Tags*",style: TextStyle(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 45,
                      width: 250,
                      child: TextField(
                        controller: _tags,
                        textAlign: TextAlign.center,
                              decoration: InputDecoration(
                              
                                hintText: 'Use , to seperate tags ',
                                errorText: _validateT ? 'Value Can\'t Be Empty' : null,

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
            
               
               
               
              CheckboxListTile(
                 dense: true,
                 value: isfake, 
               onChanged: (val){
                 setState(() {
                   isfake = val;
                 });
               },
               title: Text("Might be Fake"),
               controlAffinity: ListTileControlAffinity.leading
               ),
                CheckboxListTile(
                 dense: true,
                 value: isanonymous, 
               onChanged: (val){
                 setState(() {
                   isanonymous = val;
                 });
               },
               title: Text(" Make this Anonymous"),
               controlAffinity: ListTileControlAffinity.leading
               ),
             

              Container(
                height: isFetching == true ? 200 : 100,
                width: isFetching == true ? 200 :100,
                alignment: Alignment.center,
                child:  isFetching == true ? loader(200, 200) : RaisedButton(
                  
                  color:  isFetching == true? Colors.white:  Colors.blue,
                  child: Text("Submit",style: TextStyle(color: Colors.white),),
                  onPressed: ()  {
                    setState(() {
                  _url.text.isEmpty ? _validateU = true : _validateU = false;
                  _review.text.isEmpty ? _validateR = true : _validateR = false;
                  _tags.text.isEmpty ? _validateT = true : _validateT = false;
                });
                
                if(!_validateR&&!_validateU&&!_validateT)
                {

                   _makePostReq(_url.text, _tags.text.toString().split(",").toList(),ratings, _review.text);
                }
              
              
                   
                  },
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  
                  //height: 200,
                  //width: 300,
                  alignment: Alignment.center,
                  child: RaisedButton(
                    elevation: 3.0,
                    color: Colors.red,
                    onPressed: () async{
                   final result =    await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Monetize()));
                       setState(() {
                         
                         _monteizedata = result;
                       });
                         _advertisement = {
                           "title" : _monteizedata.elementAt(0),
                           "url" :  _monteizedata.elementAt(1),
                           "advertizing_content" : _monteizedata.elementAt(2),

                         };

                      
                    },
                    child: Text("Monetize This post",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                ),

              ),
              
            ],
            
          ),
      
      
    );
  }

}