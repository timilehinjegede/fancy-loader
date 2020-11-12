import 'package:fancy_loader/fancy_loader.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Fancy Loader Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FancyLoader _fancyLoader = FancyLoader(
    child: FlutterLogo(),
    duration: Duration(milliseconds: 750),
    blurValue: 2.0,
    isLoaderDismissible: false,
    backgroundColor: Colors.black.withOpacity(0.4),
    transitionType: TransitionType.scale,
  );

  void _showFancyLoader() {
    _fancyLoader.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFancyLoader,
        tooltip: 'Show Fancy Loader',
        child: Icon(Icons.add),
      ),
    );
  }
}
