


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sssocial/pages/home.dart';
import 'package:flutter/cupertino.dart';
// import fit_image;

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sssocial/pages/img.dart';
import 'package:sssocial/pages/interest.dart';
import 'package:sssocial/pages/interestAfterSignIn.dart';
import 'package:sssocial/pages/url.dart';


import 'msg.dart';
// declaring storage varaibles
final storage = new FlutterSecureStorage();
String auth="https://backend.scrapshut.com/a/google/";


// declaring signing
final googlesignin= GoogleSignIn();
class Home extends StatefulWidget{ 
 
// this method is called  from scree folder which calls logout function to logout user
  method() => createState().logout();

// login function present in home.dart  
  login() => createState().login();

  @override
_HomeState createState() =>  _HomeState();
  
  

 
}

// class _HomeState {
// }

class _HomeState extends State<Home>{
 
bool isAuth =false;
String token ='';
String value='';
String gtoken='';
@override
// initial state checking if user is authenticated or not 
void initState(){
super.initState();
googlesignin.onCurrentUserChanged.listen((account){
if (account != null){
  print("user signed in ");
  setState(() {
    

   isAuth=true;
  });
}
else{
  setState(() {
    
    //isAuth=false;
  });
}
},onError:(err){
  print("eror signing in $err");
});
googlesignin.signInSilently(suppressErrors:false)
.then((account){
  if (account != null){
  print("user signed ");
  setState(() {
    
    isAuth=true;
  });
}
else{
  setState(() {
    
    //isAuth=false;
  });
}
});
}
// this function is  triggered when ever user uses google to signin
 login()  {
  googlesignin.signIn().then((result){
        result.authentication.then((googleKey) async {
          var gtoken = googleKey.accessToken;
          // print(gtoken);
          await storage.write(key: 'token', value: gtoken);
          String value = await storage.read(key: 'token');
          print(value);
          print("sucess post");
     
          Map<String,String> headers = {'Content-Type':'application/json'};
          final msg = jsonEncode({"token":"$value"});
          print(msg);

          var response = await http.post(auth ,body:msg,

          headers: headers

          );
 if(response.statusCode == 200) {
      String responseBody = response.body;
      print(responseBody);
     Map<String, dynamic> responseJson = jsonDecode(response.body);
     String btoken=responseJson['access_token'];
      await storage.write(key: 'btoken', value: btoken);
      String bvalue = await storage.read(key: 'btoken');
      print(bvalue);
      print("sucess");
      
      
     
      
    }
   else{
     print("not success");
   } 
          });
  });
}
// this function is troggered whenever user clicks logout from scree.dart in screens 
 Future logout() async {
    try {
      //await _fireBaseAuthInstance.signOut();
      await googlesignin.signOut();
    } catch (e) {
      print('Failed to signOut' + e.toString());
    }
   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}


//   Scaffold buildAuthScreen(context){
// return      Scaffold(

//   body: Container(
//     height: MediaQuery.of(context).size.height,
//     width: double.infinity,
//     child: DefaultTabController(
//       child: Scaffold(
//          appBar: AppBar(
//                   elevation: 0.0,
//                   backgroundColor: Colors.blue[100],
//                   bottom: PreferredSize(
//                     preferredSize: Size.fromHeight(25),
//                     child: Container(
//                       color: Colors.transparent,
//                       child: SafeArea(
//                         child: Column(
//                           children: <Widget>[
//                             TabBar(
//                                 indicator: UnderlineTabIndicator(
//                                     borderSide: BorderSide(
//                                         color: Colors.red
//                                         , width: 6.0),
//                                     insets: EdgeInsets.fromLTRB(
//                                         40.0, 20.0, 40.0, 0)),
//                                 indicatorWeight: 15,
//                                 indicatorSize: TabBarIndicatorSize.label,
//                                 labelColor: Colors.white,
//                                 labelStyle: TextStyle(
//                                     fontSize: 12,
                                   
//                                     fontWeight: FontWeight.bold),
//                                 unselectedLabelColor: Colors.white,
//                                 tabs: [
//                                   Tab(
//                                     text: "URL",
                                    
//                                   ),
//                                   Tab(
//                                     text: "MESSAGE",
                                   
//                                   ),
//                                   Tab(
//                                     text: "IMAGE",
                                  
//                                   ),
//                                 ])
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
                  
//                 ),
//                 drawer: Drawer(
//                  child: ListView(
//     // Important: Remove any padding from the ListView.
//     padding: EdgeInsets.zero,
//     children: <Widget>[
//       DrawerHeader(
//         child: Text('Scrashut For Deeptech'),
//         decoration: BoxDecoration(
//           color: Colors.blue,
//         ),
//       ),
//       ListTile(
//         title: Text('Logout'),
//         onTap: () {
//           logout();
//           // Update the state of the app.
//           // ...
//         },
//       ),
//       ListTile(
//         title: Text('Interests'),
//         onTap: () {
//            Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => Interest()),
//   );
//         },
//       ),
//     ],
//   ),
//                 ),
//                   body: TabBarView(
//                   children: <Widget>[
//                     URL(),
//                     Msg(),  
//                     Img(),
                    
//                   ],
//                 )
//                 ), 
//                 length: 3,
//                 )
//                 )
                
//       );
      
      
  
  

// }
// whenever isAuth=False i.e if user isnt authenticated this screen is showed to him
 Scaffold buildUnAuthScreen(){
 return Scaffold(
body: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin:Alignment.topRight,
      end:Alignment.bottomLeft, colors: <Color>[
        Colors.blue,
        Colors.white,
      ],
        ),
  ),
alignment: Alignment.center,
  child:Column(
      mainAxisAlignment:MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

    children: <Widget>[
            Container(
                height:300,
                width: 800,
                 decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage(
              'assets/images/scrap_withoutbg.png'),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.rectangle,
      ),
               
              ),
    // Text("Scrapshut",style:TextStyle(
    //   fontFamily:"Signatra",
    //    fontSize:40.0,
    //    color:Colors.lightBlue,
    //    ),
    //    ),


       RaisedButton(   
        //  whenever this button is  pressed then the login function which is present in home.dart will be triggered       
         onPressed: login(),
         child: Container(
           width:450.0,
           height:60.0,
           decoration:BoxDecoration(
             image:DecorationImage(image: AssetImage('assets/images/download.png'),
             fit : BoxFit.cover,
              ),
           ),   
         ),
       ),


  ],),
),
 );
}
@override

  Widget  build(BuildContext context){
    print("is auth in build");
    print(isAuth);
// if isAuth value is true then it will call IntrestA which will trigger intrestaftersignin page 
// else it will show the buildUnAuthScreen()
    return isAuth ? InterestA() : buildUnAuthScreen();
  
  }
}