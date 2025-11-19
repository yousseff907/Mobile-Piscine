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
		return (MaterialApp(debugShowCheckedModeBanner: false, title: "Exerice 02", home: MyHomePage()));
	}
}

class MyHomePage extends StatelessWidget
{
	Widget	buildButton(String str)
	{
		return (ElevatedButton(child: Text(str), onPressed: () {
		  print("pressed "+ str);
		},));
	}

	@override
	Widget build(BuildContext context)
	{
		return (Scaffold(
				appBar: AppBar(title: Text("Calculator"),
				centerTitle: true),
				body: Center(
					child: Column(
						children: [
							TextField(readOnly: true, decoration: InputDecoration(hintText: "0"), textAlign: TextAlign.right),
							TextField(readOnly: true, decoration: InputDecoration(hintText: "0"), textAlign: TextAlign.right),
							Expanded(child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								children: [
									buildButton("7"),
									buildButton("8"),
									buildButton("9"),
									buildButton("/"),
								],
							)),
							Expanded(child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								children: [
									buildButton("4"),
									buildButton("5"),
									buildButton("6"),
									buildButton("*"),
								],
							)),
							Expanded(child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								children: [
									buildButton("1"),
									buildButton("2"),
									buildButton("3"),
									buildButton("-"),
								],
							)),
							Expanded(child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								children: [
									buildButton("."),
									buildButton("0"),
									buildButton("="),
									buildButton("+"),
								],
							)),
							Expanded(child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								children: [
									buildButton("C"),
									buildButton("AC"),
								],
							))
						],
					),
				),
			)
		);
	}

}