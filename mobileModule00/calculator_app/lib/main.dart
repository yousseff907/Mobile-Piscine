import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main()
{
	runApp(MyApp());
}

class MyApp extends StatelessWidget
{
	@override
	Widget build(BuildContext context)
	{
		return (MaterialApp(debugShowCheckedModeBanner: false, title: "Calculator app", home: MyHomePage()));
	}
}

class MyHomePage extends StatefulWidget
{
	@override
	MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
{
	String	result = "0";
	String	expression = "";

	TextEditingController resultController = TextEditingController();
	TextEditingController expressionController = TextEditingController();

	String	calculate(String exp)
	{
		try
		{
		Parser p = Parser();
		Expression expr = p.parse(exp);
		ContextModel context = ContextModel();
		double res = expr.evaluate(EvaluationType.REAL, context);
		if (res.isInfinite || res.isNaN)
			return ("Error");
		return (res.toString());
		}
		catch (e)
		{
			return ("Error");
		}
	}

	Widget	buildButton(String str)
	{
		return (ElevatedButton(child: Text(str), onPressed: ()
		{
			setState(()
			{
				if (str == "=")
					result = calculate(expression);
				else if (str == "AC")
				{
					expression = "";
					result = "0";
				}
				else if (str == "C")
				{
					if (expression.length >= 1)
						expression = expression.substring(0, expression.length - 1);
				}
				else
					expression += str;
			});
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
							TextField(controller: resultController, readOnly: true, decoration: InputDecoration(hintText: expression), textAlign: TextAlign.right),
							TextField(controller: expressionController, readOnly: true, decoration: InputDecoration(hintText: result), textAlign: TextAlign.right),
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