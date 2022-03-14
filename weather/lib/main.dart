//import 'dart:html';
//import 'package:weather/main.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int temperature=0;
  String location="San Francisco"; 
  int woeid=2487956;
  String searchApiUrl='https://www.metaweather.com/api/location/search/?query=';
  String locationApiUrl='https://www.metaweather.com/api/location/';
  String weather='clear';
  String abbrevation =' ';

   void fetchSearch(String input) async{
    var searchResult=await http.get(Uri.parse('https://www.metaweather.com/api/location/search/?query='+input
    ),);
        var result =json.decode(searchResult.body)[0];

        setState(() {
          location=result["title"];
          woeid=result["woeid"]; 

        });


       initState(){
        super.initState();
        fetchLocation();
      }

  }
  
  void fetchLocation() async{
    var locationResult= await http.get(Uri.parse('https://www.metaweather.com/api/location/'+woeid.toString()));  
    var result=json.decode(locationResult.body);
    var consolidatedWeather=result["consolidated_weather"];
    var data=consolidatedWeather[0];
    setState(() {
         temperature=data["the_temp"].round(); 
         weather=data["weather_state_name"].replaceAll('','').toLowerCase();
         abbrevation=data['weather_state_abbr'];
    });
  }

  void onTextFieldSubmitted(String input){
    fetchSearch(input);
    fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:AssetImage('images/$weather.png'),
              fit: BoxFit.cover,),
          ),

        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Column(
                  children: [
                    Center(child: Image.network("https://www.metaweather.com/static/img/weather/png/c.png",width: 100,),),
                    Center(
                      child: Text(
                      temperature.toString()+' °C',
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white),
                     ),
                      ),
                    Center(
                      child: Text(location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30),),),
                  ],
                ),
                Column(children:  [
                     SizedBox(
                    width: 300,
                    child:  TextField(
                      onSubmitted: (String input){
                        onTextFieldSubmitted(input);
                      },
                      style: const TextStyle(color: Colors.white,fontSize: 25),
                      decoration:const  InputDecoration(
                        hintText: "Search for another location...",
                        hintStyle: TextStyle(color: Colors.white,fontSize: 15),
                        prefixIcon: Icon(Icons.search,color: Colors.white,size: 26,),
                      ),
                    ),
                  ),
                ],),
          ],),
        ),
      ),
    );
  }
}