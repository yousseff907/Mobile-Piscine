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
		return (MaterialApp(debugShowCheckedModeBanner: false, title: "Exerice 00", home: MyHomePage()));
	}
}

class MyHomePage extends StatelessWidget
{
	@override
	Widget build(BuildContext context)
	{
		return (Scaffold(
				body: Center(
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [Text("Hello world!"),
									ElevatedButton(onPressed: ()
									{
										print("Button pressed");
									},
									child: Text("Click me"))],
									),
							),
						)
				);
	}
}