import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return (MaterialApp(debugShowCheckedModeBanner: false, title: "Weather App", home: MyHomePage()));
  }
}

class MyHomePage extends StatefulWidget
{
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
{
  int                    	 _index = 0;
  String                 	 _text = "";
  TextEditingController  	 _controller = TextEditingController();
  PageController           _pageController = PageController();
  List<Map<String, dynamic>> _cities = [];

  void _onTextTap(String s)
  {
    setState(() {
      _text = s;
    });
  }

  void _onTabTap(int index)
  {
    setState(() {
      _index = index;
    });
    _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeOutCubic);
  }

  void _getLocation() async
  {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) 
    {
      _onTextTap("Location services are disabled");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) 
    {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) 
      {
        _onTextTap("Location permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) 
    {
      _onTextTap("Location permission denied forever");
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    _onTextTap("Lat: ${position.latitude}, Lon: ${position.longitude}");
  }

  void _searchCity(String value) async
  {
    if (value.isEmpty)
    {
      setState(() {
        _cities = [];
      });
      return;
    }
    String URL = "https://geocoding-api.open-meteo.com/v1/search?name=$value";
    var response = await http.get(Uri.parse(URL));
    if (response.statusCode == 200)
    {
      var data = jsonDecode(response.body);
      var results = data['results'];
      if (results != null)
      {
        List<Map<String, dynamic>> newCities = [];

        for (var city in results)
        {
          newCities.add(city);
        }
        
        setState(() {
          _cities = newCities;
        });
      }
    }
    else
      print("Failed to load cities");
  }

  @override
  Widget build(BuildContext context)
  {
    return (Scaffold(
      appBar: AppBar(title: TextField(controller: _controller, onSubmitted: _onTextTap , decoration: InputDecoration(hintText: "Search location..."),
      onChanged: (String value)
      {
        _searchCity(value);
      },),
      actions: [IconButton(onPressed: ()
      {
        _getLocation();
        print("Geolocation pressed");
      },
        icon: Icon(Icons.location_on))],
      ),
      body: Stack( children: [ PageView(controller: _pageController,
      onPageChanged: _onTabTap,
      children: [
        Center(child: Text("Currently $_text")),
        Center(child: Text("Today $_text")),
        Center(child: Text("Weekly $_text"))
      ],),
      if (_cities.isNotEmpty)
        Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              color: Colors.white,
              height: 200,
              child: ListView.builder(
                itemCount: _cities.length,
                itemBuilder: (context, index)
                {
                  var city = _cities[index];
                  String cityName = city['name'] ?? '';
                  String region = city['admin1'] ?? '';
                  String country = city['country'] ?? '';
                  return (ListTile(title: Text(cityName),
                  subtitle: Text("$region, $country"),
                  onTap: ()
                  {
                    setState(()
                    {
                      _text = "$cityName, $region, $country";
                      _cities = [];
                      _controller.clear();
                    });
                  },
                  ));
                },),
            ),
          )
        ]),
      bottomNavigationBar: BottomNavigationBar(currentIndex: _index,
                          items: [
                            BottomNavigationBarItem(label: "Currently", icon: Icon(Icons.wb_sunny)),
                            BottomNavigationBarItem(label: "Today", icon: Icon(Icons.today)),
                            BottomNavigationBarItem(label: "Weekly", icon: Icon(Icons.calendar_month))], onTap: _onTabTap)
                            ));
  }
}