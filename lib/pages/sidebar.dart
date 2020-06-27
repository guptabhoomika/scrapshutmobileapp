import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sssocial/pages/scrapcoin.dart';

import 'home.dart';
import 'interest.dart';


class SideBar extends StatefulWidget {
  final String name;
  SideBar({this.name});
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data ? 0 : screenWidth - 45,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  color:  Colors.blue,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                      ),
                      ListTile(
                        title: Text(
                          widget.name,
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                       
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.perm_identity,
                            color: Colors.white,
                          ),
                          radius: 40,
                        ),
                      ),
                      Divider(
                        height: 64,
                        thickness: 0.5,
                        color: Colors.white,
                        indent: 32,
                        endIndent: 32,
                      ),
                      // MenuItem(
                      //   icon: Icons.home,
                      //   title: "Home",
                      //   onTap: () {
                      //     onIconPressed();
                      //     BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HomePageClickedEvent);
                      //   },
                      // ),
                      GestureDetector(
                        onTap: (){
                                             
             Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScrapCoin()),
    );
                        },
                         child: ListTile(
                           
                           title:  Text(
                          "ScrapStats",
                          style:  TextStyle(fontWeight: FontWeight.w300, fontSize: 15, color: Colors.white),
                        ), 
                          
                        ),
                      ),
                        GestureDetector(
                          onTap: (){
                           
             Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Interest()),
    );
                          },
                         child: ListTile(
                           
                           title:  Text(
                          "Interests",
                          style:  TextStyle(fontWeight: FontWeight.w300, fontSize: 15, color: Colors.white),
                        ), 
                          
                        ),
                      ),
                      // MenuItem(
                      //   icon: Icons.person,
                      //   title: "My Account",
                      //   onTap: () {
                      //     onIconPressed();
                      //     BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyAccountClickedEvent);
                      //   },
                      // ),
                      // MenuItem(
                      //   icon: Icons.shopping_basket,
                      //   title: "My Orders",
                      //   onTap: () {
                      //     onIconPressed();
                      //     BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyOrdersClickedEvent);
                      //   },
                      // ),
                      // MenuItem(
                      //   icon: Icons.card_giftcard,
                      //   title: "Wishlist",
                      // ),
                      Divider(
                        height: 64,
                        thickness: 0.5,
                        color: Colors.white,
                        indent: 32,
                        endIndent: 32,
                      ),
                      // MenuItem(
                      //   icon: Icons.settings,
                      //   title: "Settings",
                      // ),
                      GestureDetector(
                        onTap: (){
                          Home().method();
                        },
                          child: ListTile(
                          leading: Icon(Icons.exit_to_app,size: 30,color: Colors.white,),
                          title: Text("Logout",style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.7),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Colors.blue,
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 10);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}