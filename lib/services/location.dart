//import 'dart:html';

import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Location {
   late double latitude;
   late double longitude;
   Future <void> getCurrentLocation() async{
     bool serviceEnabled;
     LocationPermission permission;
     serviceEnabled=await Geolocator.isLocationServiceEnabled();
     if(!serviceEnabled){
       Fluttertoast.showToast(msg:'Location service is disabled');
     }
     permission= await Geolocator.checkPermission();
     if(permission==LocationPermission.denied){
       permission= await Geolocator.requestPermission();
       if(permission==LocationPermission.denied)
         {
           Fluttertoast.showToast(msg: 'You denied the permission!');

         }
     }
     if(permission==LocationPermission.deniedForever)
       {
         Fluttertoast.showToast(msg:'You denied the permission forever');
       }
     try{
       Position position= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
       longitude=position.longitude;
       latitude=position.latitude;
     }
     catch(exception)
     {
       print(exception);
     }
   }
}
