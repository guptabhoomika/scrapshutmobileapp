import 'package:flutter/material.dart';
//will display the gif
Container loader(double height,double width)
{
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: new AssetImage('assets/images/scrapshut.gif'),
          fit: BoxFit.cover

        )
      ),
    );
}