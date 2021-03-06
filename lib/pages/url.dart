import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:sssocial/errorapi.dart';
import 'package:sssocial/services.dart';
import 'package:url_launcher/url_launcher.dart';
 
import  '../pages/home.dart';
import '../widgets/loader.dart';
import 'monetizePage.dart';

class URL extends StatefulWidget {
  @override
  _URLState createState() => _URLState();
}
final storage = new FlutterSecureStorage();

class _URLState extends State<URL> {
 
  
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
  showSnackBarURL() {
    print("Show Snackbar here !");
    final snackBar = new SnackBar(
        content: Text("Ebter a valid url"),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.black,
       
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
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
  var resp = jsonDecode(response.body);
  setState(() {
    isFetching = false;
  });
 
   int statusCode = response.statusCode;
   if(statusCode == 201)
   {
       print("statusCode");
     print(statusCode);
     _showSnackBar(statusCode);

   }
   else {
     print("Status code");
     //Services.sendmail(response.body);
     print(statusCode);
     print(response.body);
     if(statusCode==400)
     {
       String msg = "";
       if(resp.toString().contains("url"))
       {
         msg = resp["url"].toString().replaceAll("[", " ").replaceAll("]", " ");
          final snackBar = new SnackBar(
        content: Text(msg),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.black,
        action: new SnackBarAction(label: "Ok",textColor: Colors.white, onPressed: (){}),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
       }
       else if(resp.toString().contains("details"))
       {
         msg = resp["details"].toString();
          final snackBar = new SnackBar(
        content: Text(msg),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.black,
        action: new SnackBarAction(label: "Ok",textColor: Colors.white, onPressed: (){}),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
       }
       else
       {
         Services.sendmail(response.body);
       }
         
  
       

     }else
     {
       Services.sendmail(response.body);
     }
   
   }
  
    
  }
  double avg;
getdetails(String url) async
{
  
   Map<String, String> headers = {
"Content-Type":"application/json","API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"};

  Response _response = await http.get("https://backend.scrapshut.com/api/post?search=$url",headers: headers);
  //print(_response.body);
  Map<String,dynamic> map = jsonDecode(_response.body);
  //print(map);
  List<dynamic> _list = map['results'];
  double sum =0;
  if(_list.length==0)
  {
    setState(() {
      avg =0;
    });
  }
  else
  {
      for(int i=0;i<_list.length;i++)
  {
    sum= sum + _list[i]["rate"];
   
  }
  // avg = (avg/_list.length) as int;
  // print(avg);
  int n = _list.length;
  
  setState(() {
    avg = sum/n;
  });
  print(avg);

  }


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
   onRatingUpdate: ( rating) async {
     if(rating<=1)
     {
      if(validator.url(_url.text))
      {
        await  getdetails(_url.text);
        
         if(avg!=null)
         {
            showAlertDialog(context, avg);
           print(avg.toString() + "in rating");
           
         }

      }
     else
      {
       showSnackBarURL();
       rating = 0;
      }
      

     }
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

 showAlertDialog(BuildContext context,double avg) {  
   
   
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog( 

    title: avg!=0 ? Center(child: Text("This post has a rating of $avg")) : Text("This url is not rated yet"),  
    content: avg!=0 ? GestureDetector(
      onTap: (){
        _launchURL();
      },
      child: Text("See the ratings and review at https://wiringbridge.com/",style: TextStyle(color: Colors.blue),)) : Text(""),  
    actions: [
      Text("               Tap anywhere to continue",style: TextStyle(color:Colors.grey),)
    ],
  );  
  
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  
_launchURL() async {
  const url = 'https://wiringbridge.com/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
