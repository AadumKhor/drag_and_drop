import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// boilerPlate Code for initial app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: new Scaffold(
        body: App(),
      ),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Color caughtColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Dragbox(
          initPos: Offset(0.0, 0.0),
          label: 'Box One',
          itemColor: Colors.lime,
        ),
        Dragbox(
          initPos: Offset(100.0, 0.0),
          label: 'Box two',
          itemColor: Colors.orangeAccent,
        ),
        Positioned(
          left: 100.0,
          bottom: 0.0,
          child: DragTarget(
            onAccept: (Color color){
              caughtColor = color;
            },
            builder: (
              BuildContext context, // the context
              List<dynamic> accepted, // the items that are accepted by the target
              List<dynamic> rejected, // the items that are rejected
            ) {
              return Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                  // checks if the container has accepted anything
                  color: accepted.isEmpty ? caughtColor : Colors.grey.shade200
                ),
                child: Center(child: Text('Drag Here!')),
              );
            },
          ),
        )
      ],
    );
  }
}

// this class represents the box that is to be dragged
// across the screen.
class Dragbox extends StatefulWidget {
  final Offset initPos;
  final String label;
  final Color itemColor;

  Dragbox({this.initPos, this.label, this.itemColor});

  @override
  DragBoxState createState() => DragBoxState();
}

class DragBoxState extends State<Dragbox> {
  Offset position = new Offset(0.0, 0.0);

  void initState() {
    super.initState();
    position = widget.initPos;
  }

  @override
  Widget build(BuildContext context) {
    // Positioned widget because we are using Stack
    return Positioned(
      left: position.dx,
      top: position.dy,
      // Draggable Widget is used to create an object
      // that can be dragged around the sCreen. It
      // takes in a child and the data that is being dragged.
      child: Draggable(
        data: widget.itemColor,
        child: Container(
          color: widget.itemColor,
          width: 100.0,
          height: 100.0,
          child: Center(
            child: Text(widget.label,
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
          ),
        ),
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            position =
                offset; // to ensure it does not come back to it's position
          });
        },
        //when the widget is being dragged around the state of it is defined
        // by the feedback property
        feedback: Container(
          // we change the opacity to make it look as if
          // the item got blurred.
          color: widget.itemColor.withOpacity(0.5),
          // we change the width and height in order to make it obvious
          // that an object is being moved.
          width: 120.0,
          height: 120.0,
          child: Center(
            child: Text(widget.label,
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
          ),
        ),
      ),
    );
  }
}
