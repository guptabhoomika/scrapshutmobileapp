import 'package:flutter/material.dart';
import 'package:sssocial/pages/home.dart';
import 'package:sssocial/pages/img.dart';
import 'package:sssocial/pages/interest.dart';
import 'package:sssocial/pages/msg.dart';
import 'package:sssocial/pages/scrapcoin.dart';
import 'package:sssocial/pages/url.dart';
class Main extends StatefulWidget {
  //bool isAuth;
  @override
  _MainState createState() => _MainState();
}
TabController _tabController;

class _MainState extends State<Main> with SingleTickerProviderStateMixin{
  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(length: 3,initialIndex: 0, vsync: this);
    super.initState();
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
                  body: TabBarView(
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