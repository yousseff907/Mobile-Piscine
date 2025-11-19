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
  @override
  Widget build(BuildContext context)
  {
    return (Scaffold(
      appBar: AppBar(),
      body: ));
  }
}