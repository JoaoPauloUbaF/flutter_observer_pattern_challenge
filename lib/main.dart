import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Main application class
///
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'setState() Grid Demo - Observer Pattern';
    return MaterialApp(
      title: 'Grid Demo - Observer Pattern',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(
        title: appTitle,
      ),
    );
  }
}

/// Root widget for our application
///
class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// In this widget we will create a grid with black/gray tiles which will
/// change their pattern with each button press.
///
/// The update of the grid state will be done through a setState() {...} block
/// of code so that each time the user presses the button the whole UI Widget
/// will be refreshed and new (random) tile pattern will be drawn on the screen.
///
class _MyHomePageState extends State<MyHomePage> {
  /// our random generator
  Random rnd = Random();
  StreamController<bool> flipController = StreamController<bool>.broadcast();
  StreamSink<bool> get _flipSink => flipController.sink;
  Stream<bool> get flipStream => flipController.stream;

  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      debugPrint("Timer ticked");
      _flipSink.add(true);
    });
    super.initState();
  }

  @override

  /// We need to dispose of the Controller and all the streams when the Widget
  /// is being disposed of.
  ///
  void dispose() {
    /// this triggers our 'actua' dispose code in the controller
    flipController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      /// Column layout with a grid of 8x8 tiles
      ///
      body: Column(
        children: [
          GridView.count(
            crossAxisCount: 8,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            shrinkWrap: true,
            padding: EdgeInsets.zero,

            ///
            /// Generation of all the grid tiles. We generate exactly
            /// 64 tiles and we also have each tile work with [AnimatedOpacity]
            /// which shows the tile by animating the opacity transition with
            /// the opacity being controlled by a randomly generated bool value
            ///
            ///
            children: List.generate(
              8,
              (index) => StreamBuilder<bool>(
                  stream: flipStream,
                  initialData: false,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return AnimatedOpacity(
                      /// If the widget is visible, animate to 0.2 (barely visible).
                      /// If the widget is hidden, animate to 1.0 (fully visible).
                      opacity: rnd.nextBool() ? 1.0 : 0.2,
                      duration: const Duration(milliseconds: 200),

                      /// This is the child of the AnimatedOpacity widget, which is
                      /// basically a [Container] with a black color and which
                      /// represents the whole single tile
                      ///
                      child: Container(
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              color: Colors.black,
                              child: Text(
                                'Tile ${rnd.nextInt(max(1, 100)).toString()}',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /// Call setState. This tells Flutter to rebuild the
          /// UI with the changes.
          setState(() {
            /// do nothing except trigger the UI repaint
          });
        },
        tooltip: 'Toggle Opacity',
        child: const Icon(Icons.flip),
      ),
    );
  }
}
