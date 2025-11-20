import 'package:flutter/material.dart';

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
  int                     _index = 0;
  String                  _text = "";
  TextEditingController   _controller = TextEditingController();
  PageController          _pageController = PageController();

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

  @override
  Widget build(BuildContext context)
  {
    return (Scaffold(
      appBar: AppBar(title: TextField(controller: _controller, onSubmitted: _onTextTap , decoration: InputDecoration(hintText: "Search location..."),), actions: [IconButton(onPressed: (){_onTextTap("Geolocation"); print("Geolocation pressed");}, icon: Icon(Icons.location_on))],),
      body: PageView(controller: _pageController,
      onPageChanged: _onTabTap,
      children: [
        Center(child: Text("Currently $_text")),
        Center(child: Text("Today $_text")),
        Center(child: Text("Weekly $_text"))
      ],),
      bottomNavigationBar: BottomNavigationBar(currentIndex: _index,
                          items: [
                            BottomNavigationBarItem(label: "Currently", icon: Icon(Icons.wb_sunny)),
                            BottomNavigationBarItem(label: "Today", icon: Icon(Icons.today)),
                            BottomNavigationBarItem(label: "Weekly", icon: Icon(Icons.calendar_month))], onTap: _onTabTap)
                            ));
  }
}
