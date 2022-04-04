import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess my number',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Guess my number'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int number = 0;
  late int generatedNumber;
  String hint = "";

  final textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    generateRandom();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  void generateRandom() {
    Random random = Random();
    generatedNumber = random.nextInt(101);
    generatedNumber = 12;
  }

  String getHint(int number) {
    String suggestion;
    if (number == 0) {
      return "";
    } else if (number > generatedNumber) {
      suggestion = "Try lower";
    } else if (number < generatedNumber) {
      suggestion = "Try higher";
    } else {
      suggestion = "You guessed right";
    }
    return '  You tried $number \n$suggestion';
  }

  showAlertDialog(BuildContext context) {
    if (generatedNumber == number) {
      // Create button
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      Widget tryAgainButton = TextButton(
        child: const Text("Try again! "),
        onPressed: () {
          generateRandom();
          setState(() {
            hint = "";
            number = 0;
          });
          Navigator.of(context).pop();
        },
      );

      // Create AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("You guessed right"),
        content: Text("It was $number"),
        actions: [tryAgainButton, okButton],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  void handleGuess() {
    int? parsedNumber = int.tryParse(textFieldController.text);
    number = parsedNumber ?? 0;
    setState(() {
      hint = getHint(number);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title), centerTitle: true,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(16),
              child: const Text('I\'m thinking of a number between 1 and 100', style: TextStyle(fontSize: 18)),
            ),
            Container(
              margin: const EdgeInsets.all(24),
              child: const Text('It is your turn to guess my number', style: TextStyle(fontSize: 18.0)),
            ),
            Text(
              hint,
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(
              width: 400,
              height: 200,
              padding: const EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Try a number! ',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    TextField(
                      controller: textFieldController,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Enter number',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(25),
                      child: ElevatedButton(
                        child: const Text(
                          'Guess',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () {
                          handleGuess();
                          showAlertDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
