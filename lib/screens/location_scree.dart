import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/services/weather.dart';
import 'package:weather_app/utiilities/constants.dart';
import 'package:weather_app/screens/city_screen.dart';

class LocationScreen extends StatefulWidget {
  //const LocationScreen({Key? key}) : super(key: key);
  LocationScreen({this.locationWeather});
  final locationWeather;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather=WeatherModel();
  int temperature = 0;
  String weatherIcon = '0';
  String weatherDescription = '0';
  String cityName = '0';

  @override
  void initState(){
    super.initState();
    print(widget.locationWeather);
    updateUI(widget.locationWeather);
  }
  void updateUI(dynamic weatherData){
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherDescription = 'Unable to fetch data';
        cityName = '';
        return;
      }
      double temp= weatherData['main']['temp'];
      temperature=temp.toInt();
      var condition=weatherData['weather'][0]['id'];
      weatherIcon=weather.getWeatherIcon(condition);
      cityName=weatherData['name'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherDescription = weather.getMessage(temperature);
      print(temperature);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
           image: DecorationImage(
             image: const AssetImage('images/location_background.jpg'),
             fit: BoxFit.cover,
             colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
           ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    FlatButton(
                  onPressed:() async{
                    var weatherData= await weather.getLocationWeather();
                    updateUI(weatherData);
                  },
                    child: const Icon(
                    Icons.near_me,
                    size: 50.0,
                  ),
              ),
                    FlatButton(
                    onPressed: () async{
                      var typedName= await Navigator.push(context, MaterialPageRoute(builder: (context){
                         return CityScreen();
                      },
                      ),
                      );
                      if(cityName!=null){
                        var weatherData= await weather.getCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                      child:const Icon(
                      Icons.location_city,
                      size: 50.0,
                  ),
              ),
                ]
              ),
              Padding(
                  padding:const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                     Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                  padding:EdgeInsets.only(right: 15.0),
                  child: Text(
                    '$weatherDescription in $cityName',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// var temperature= decodedData['main']['temp'];
// var condition=decodedData['weather'][0]['id'];
// var cityName=decodedData['name'];