import 'package:flutter/material.dart';
import 'package:sssocial/pages/home.dart';
import 'package:sssocial/pages/img.dart';
import 'package:sssocial/pages/interest.dart';
import 'package:sssocial/pages/interestafterSignIn.dart';
import 'package:sssocial/pages/msg.dart';
import 'package:sssocial/pages/scrapcoin.dart';
import 'package:sssocial/pages/url.dart';
class Main extends StatefulWidget {
  //bool isAuth;
  @override
  _MainState createState() => _MainState();
}
TabController _tabController;
bool img = false; 
//these bool values check whether the full screen dialog have been shown in the msg and img tab they will be true if the dialog is shown

bool msg = false;

class _MainState extends State<Main> with SingleTickerProviderStateMixin{
  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(length: 3,initialIndex: 0, vsync: this);
    _tabController.addListener(move);
    super.initState();
  }
  //to show the full screen dialog called by listener on the tab controller
  move()
  {
    print("Tab change");
    if(_tabController.index>0)
    {
      if(_tabController.index == 1 && !msg)
      {
          Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    pageBuilder: (BuildContext context, _, __) =>
        SomeDialog()));
    
    setState(() {
      msg = true;
    });
      }
    }
    if(_tabController.index == 2 && !img)
    {
        Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    pageBuilder: (BuildContext context, _, __) =>
        SomeDialog()));
        setState(() {
          img = true;

        });
    }
  }

  @override
  Widget build(BuildContext context) {
    
return Scaffold(
  appBar: AppBar(
  
    bottom: TabBar(
      controller: _tabController,
      indicatorColor: Colors.white,
     

       tabs: [
        Tab(
          text: "URL",
        ),
        Tab(
          text: "Message",
        ),
        Tab(
          text: "Image",
        )
      ],
    ),
  ),


                  
                
                drawer: Drawer(
                 child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        child: Text('Scrashut For Deeptech'),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
      ListTile(
        title: Text('Logout'),
        onTap: () {
          print("Trying to logout");
          print("Unauth screen should be built");
          Home().method();

         
         
          
         
        
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        title: Text('Interests'),
        onTap: () {
           Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Interest()),
  );
        },
      ),
      ListTile(
        title: Text("Scrapcoins"),
        onTap: (){
           Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ScrapCoin()),
  );

        },
      )
    ],
  ),
                ),
                  body: TabBarView
                  (
                    
                    controller: _tabController,
                  children: <Widget>[
                    URL(),
                    Msg(),  
                    Img(),
                    
                  ],
                                 )
                
               
                
      );
      
      
  
  

  }
}