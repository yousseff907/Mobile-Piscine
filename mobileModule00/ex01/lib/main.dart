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
		return (MaterialApp(debugShowCheckedModeBanner: false, title: "Exerice 01", home: MyHomePage()));
	}
}

class MyHomePage extends StatefulWidget
{
	@override
    MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
{
	String	message = "A simple text";
	bool	HelloWorld = false;
	void	toggleText()
	{
		setState(()
		{
			if (HelloWorld)
			{
				message = "A simple text";
			}
			else
			{
				message = "Hello world";
			}
			HelloWorld = !HelloWorld;
		});
	}

	@override
	Widget build(BuildContext context)
	{
		return (Scaffold(
				body: Center(
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [Text(message),
									ElevatedButton(onPressed: ()
									{
										toggleText();
										print("Button pressed");
									},
									child: Text("Click me"))],
									),
							),
						)
				);
	}

}