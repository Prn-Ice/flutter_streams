import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamController<int> streamController = StreamController<int>.broadcast();
  StreamSubscription streamSubscription;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Stream stream = streamController.stream;
                    streamSubscription = stream.listen((value) {
                      print("Value in stream controller is $value");
                    });
                  },
                  child: Text('Subscribe'),
                  color: Colors.green,
                ),
                MaterialButton(
                  onPressed: () {
                    streamController.add(1);
                  },
                  child: Text('Emit Value'),
                  color: Colors.lightBlueAccent,
                ),
                MaterialButton(
                  onPressed: () {
                    streamSubscription.cancel();
                  },
                  child: Text('Un-Subscribe'),
                  color: Colors.redAccent,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RandomNumberScreen(),
                    ),
                  );
                },
                color: Colors.yellowAccent,
                child: Text('Next Page'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RandomNumberScreen extends StatefulWidget {
  @override
  _RandomNumberScreenState createState() => _RandomNumberScreenState();
}

class _RandomNumberScreenState extends State<RandomNumberScreen> {
  int randomValue;
  StreamSubscription streamSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '$randomValue',
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MaterialButton(
                onPressed: () {
                  streamSubscription = gerRandomInt().listen((value) {
                    print('Getting Value $value');
                    setState(() {
                      randomValue = value;
                    });
                  });
                },
                color: Colors.indigo,
                child: Text('Get Value'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MaterialButton(
                onPressed: () {
                  streamSubscription.cancel();
                  print('Stop Getting Value');
                },
                color: Colors.deepOrangeAccent,
                child: Text('Cancel Sub'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<int> gerRandomInt() async* {
    Random random = Random(2);

    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield random.nextInt(200);
    }
  }
}
