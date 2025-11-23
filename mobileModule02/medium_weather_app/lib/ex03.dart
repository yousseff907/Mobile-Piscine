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
  int                    	    _index = 0;
  String                 	    _text = "";
  TextEditingController  	    _controller = TextEditingController();
  PageController              _pageController = PageController();
  List<Map<String, dynamic>>  _cities = [];
  Map<String, dynamic>?       _weather;
  String?                     _errorMessage;

  String _getWeatherDescription(int code)
  {
    if (code == 0) return "Clear sky";
    if (code >= 1 && code <= 3) return "Partly cloudy";
    if (code >= 45 && code <= 48) return "Foggy";
    if (code >= 51 && code <= 55) return "Drizzle";
    if (code >= 61 && code <= 65) return "Rain";
    if (code >= 71 && code <= 75) return "Snow";
    if (code >= 80 && code <= 82) return "Rain showers";
    if (code == 95) return "Thunderstorm";
    if (code >= 96 && code <= 99) return "Thunderstorm with hail";
    return "Unknown";
  }

  void _onTextTap(String s)
  {
    setState(() {
      _text = s;
    });
  }

  void _onTabTap(int index)
  {
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
    _searchWeather(position.latitude, position.longitude);
    _onTextTap("Lat: ${position.latitude}, Lon: ${position.longitude}");
  }

  void _searchWeather(double latitude, double longitude) async
  {
    String URL = "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,windspeed_10m,weathercode&hourly=temperature_2m,windspeed_10m,weathercode&daily=temperature_2m_max,temperature_2m_min,weathercode";
    var response = await http.get(Uri.parse(URL));
    if (response.statusCode == 200)
    {
      var data = jsonDecode(response.body);
      setState(() {
        _weather = data;
      });
      print(data);  // See what the API returns
    }
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

  void _onSearchSubmit(String value) async
  {
    if (value.isEmpty) return;
    
    try
    {
      String URL = "https://geocoding-api.open-meteo.com/v1/search?name=$value";
      var response = await http.get(Uri.parse(URL));
      
      if (response.statusCode == 200)
      {
        var data = jsonDecode(response.body);
        var results = data['results'];
        
        if (results == null || results.isEmpty)
        {
          setState(() {
            _errorMessage = "City not found. Please try a different city name.";
          });
          return;
        }
        var firstCity = results[0];
        String cityName = firstCity['name'] ?? '';
        String region = firstCity['admin1'] ?? '';
        String country = firstCity['country'] ?? '';
        
        setState(() 
        {
          _text = "$cityName, $region, $country";
          _cities = [];
          _errorMessage = null;
        });
        
        _searchWeather(firstCity['latitude'], firstCity['longitude']);
        _controller.clear();
      }
      else
      {
        setState(() {
          _errorMessage = "Connection failed. Please check your internet connection.";
        });
      }
    }
    catch (e)
    {
      setState(() {
        _errorMessage = "Connection error. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return (Scaffold(
      appBar: AppBar(title: TextField(controller: _controller, onSubmitted: _onSearchSubmit , decoration: InputDecoration(hintText: "Search location..."),
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
      onPageChanged: (int index)
      {
        setState(() {
          _index = index;
        });
      },
      children: [
        _weather == null ? Center(child: Text("Search for a location or use geolocation")) : Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text("Location: $_text"),
          Text("Temperature: ${_weather!['current']['temperature_2m']}°C"),
          Text("Wind Speed: ${_weather!['current']['windspeed_10m']} km/h"),
          Text("Weather: ${_getWeatherDescription((_weather!['current']['weathercode']))}"),
        ],
      ),
    ),
        _weather == null ? Center(child: Text("Search for a location or use geolocation")) : Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Location: $_text", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _weather!['hourly']['time'].length,
              itemBuilder: (context, index) {
                String time = _weather!['hourly']['time'][index];
                double temp = _weather!['hourly']['temperature_2m'][index];
                double windSpeed = _weather!['hourly']['windspeed_10m'][index];
                int weatherCode = _weather!['hourly']['weathercode'][index];
                
                return ListTile(
                  title: Text(time),
                  subtitle: Text("$temp°C - ${_getWeatherDescription(weatherCode)} - $windSpeed km/h"),
                );
              },
            ),
          ),
        ],
      ),
      _weather == null ? Center(child: Text("Search for a location or use geolocation")) : Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Location: $_text", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _weather!['daily']['time'].length,
              itemBuilder: (context, index) {
                String time = _weather!['daily']['time'][index];
                double temp = _weather!['daily']['temperature_2m_max'][index];
                double temp_2 = _weather!['daily']['temperature_2m_min'][index];
                int weatherCode = _weather!['daily']['weathercode'][index];
                
                return ListTile(
                  title: Text(time),
                  subtitle: Text("max: $temp°C min: $temp_2°C - ${_getWeatherDescription(weatherCode)}"),
                );
              },
            ),
          ),
        ],
      ),
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
                      _searchWeather(city['latitude'], city['longitude']);
                    });
                  },
                  ));
                },),
            ),
          ),
          if (_errorMessage != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.red,
              padding: EdgeInsets.all(16),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ]),
      bottomNavigationBar: BottomNavigationBar(currentIndex: _index,
                          items: [
                            BottomNavigationBarItem(label: "Currently", icon: Icon(Icons.wb_sunny)),
                            BottomNavigationBarItem(label: "Today", icon: Icon(Icons.today)),
                            BottomNavigationBarItem(label: "Weekly", icon: Icon(Icons.calendar_month))], onTap: _onTabTap)
                            ));
  }
}
