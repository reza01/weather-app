import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:weather/Model/CurrentCityDataModel.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.dark,
      primaryColor: Colors.lightBlue[800],

      // Define the default font family.
      fontFamily: 'Georgia',

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 21.0, fontStyle: FontStyle.italic),
        bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    ),
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController textEditingController = TextEditingController();
  late Future<CurrentCityDataModel> currentweatherFuture;

  var cityName = 'tehran';
  String icon = '';

  var format_sunRise;
  var sunRise;
  var format_sunSet;
  var format_sunRiseEnd;
  var format_sunSetEnd;
  var sunSet;

  // var setset;

  @override
  void initState() {
    super.initState();

    currentweatherFuture = SendRequestCurrentWeather(cityName);
  }

  Future<CurrentCityDataModel> SendRequestCurrentWeather(
      String cityName) async {
    var apiKey = '5427f61cc3cd630eb45c9e9486f91aec';

    var response = await Dio().get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'appid': apiKey,
          'q': this.cityName,
          'units': 'metric'
        });

    print(response.data);

    var dataModel = CurrentCityDataModel(
        response.data["name"],
        response.data["coord"]["lon"],
        response.data["coord"]["lat"],
        response.data["weather"][0]["main"],
        response.data["weather"][0]["description"],
        response.data["main"]["temp_min"],
        response.data["main"]["temp_max"],
        response.data["main"]["pressure"],
        response.data["main"]["humidity"],
        response.data["main"]["temp"],
        response.data["dt"],
        response.data["sys"]["country"],
        response.data["sys"]["sunrise"],
        response.data["sys"]["sunset"]);

    icon = response.data['weather'][0]['icon'];

    print(" >>>>" +
        response.data["sys"]["sunrise"].toString() +
        "---" +
        response.data["sys"]["sunset"].toString());

    return dataModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('OpenWeatherMap App'),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (_) {
              return const [
                PopupMenuItem<String>(child: Text("Rate Us")),
                PopupMenuItem<String>(child: Text("Leave a review")),
                PopupMenuItem<String>(child: Text("Share")),
                PopupMenuItem<String>(child: Text("Exit")),
              ];
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: FutureBuilder<CurrentCityDataModel>(
        future: currentweatherFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            CurrentCityDataModel? currentCityDataModel = snapshot.data;

            //https://openweathermap.org/current

            final formatter = DateFormat.jm();
            var sunRise = formatter.format(
                new DateTime.fromMicrosecondsSinceEpoch(
                    currentCityDataModel?.sunrise * 1000,
                    isUtc: true));

            // var sunRise = currentCityDataModel?.sunrise;
            // format_sunRise = DateTime.fromMillisecondsSinceEpoch(sunRise*1000,isUtc: true);
            // format_sunRiseEnd = format_sunRise.add(Duration(hours: 1));

            var sunSet = formatter.format(
                new DateTime.fromMicrosecondsSinceEpoch(
                    currentCityDataModel?.sunset * 1000,
                    isUtc: true));

            // sunSet = currentCityDataModel?.sunset;
            // format_sunSet = DateTime.fromMillisecondsSinceEpoch(sunSet*1000);
            // format_sunSetEnd = format_sunSet.add(Duration(hours: 1));

            return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('images/bg.jpg'),
                  )),
              // color: Colors.black,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text('find'),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              decoration: const InputDecoration(
                                hintText: 'enter city name',
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        currentCityDataModel!.cityname,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        currentCityDataModel.descrition,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Image.network(
                        'http://openweathermap.org/img/wn/' + icon + '@2x.png',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Text(
                        currentCityDataModel.temp.toString() + '\u00b0',
                        style: TextStyle(color: Colors.white, fontSize: 50),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'max',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                currentCityDataModel.temp_max.toString() +
                                    '\u00b0',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                              width: 1, height: 30, color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              const Text(
                                'min',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  currentCityDataModel.temp_min.toString() +
                                      '\u00b0',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        color: Colors.grey,
                        width: double.infinity,
                        height: 1,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 6,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                    width: 70,
                                    height: 50,
                                    // color: Colors.white,
                                    child: Card(
                                      color: Colors.transparent,
                                      child: Column(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'Fri,8pm',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Icon(
                                            Icons.cloud,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            '14' + '\u00b0',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ));
                              }),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        color: Colors.grey,
                        width: double.infinity,
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              children: [
                                const Text(
                                  'sunrise',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    sunRise.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Container(
                              width: 1,
                              height: 25,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              children: [
                                Text(
                                  'humidity',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    currentCityDataModel.humidity.toString() +
                                        '%',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Container(
                              width: 1,
                              height: 25,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              children: [
                                const Text(
                                  'sunset',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    sunSet.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: JumpingDotsProgressIndicator(
                color: Colors.white,
                fontSize: 60,
                dotSpacing: 2,
              ),
            );
          }
          ;
        },
      ),
    );
  }
}
