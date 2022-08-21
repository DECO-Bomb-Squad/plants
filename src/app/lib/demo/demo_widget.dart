import 'package:flutter/material.dart';

class DemoWidget extends StatefulWidget {
  // Things that will not change after the widget is made are put here. Anything that can be changed by buttons, an API
  // updating the widget, etc. should be contained in the state. Any variables put in the widget should be final
  final String demoTitle;

  // This is the constructor for the widget - if you want to instantiate this widget you call this, with the required
  // arguments
  // use 'this.varname' in the constructor to automatically assign the arg to a class parameter :)
  // https://dart.dev/guides/language/language-tour#constructors
  const DemoWidget(this.demoTitle, {Key? key}) : super(key: key);

  // Any StatefulWidget must override createState by calling the constructor for the state you define
  // You can use this arrow => to quickly return something instead of doing {return _DemoWidgetState();}
  @override
  State<DemoWidget> createState() => _DemoWidgetState();
}

class _DemoWidgetState extends State<DemoWidget> {
  int counter;

  _DemoWidgetState() : counter = 0;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.amber,
              // this is how you can format strings :)
              // access data from the parent widget like widget.demoTitle!
              child: Text("${widget.demoTitle} : ${counter.toString()}"),
            ),
          ),
          spacer,
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink,
              child: IconButton(
                icon: const Icon(Icons.add),
                // when this button is pressed, it increments a counter which will display in the container above it
                // setState triggers a rebuild of the widget (will cause "build" to be called again)
                // In general, wrap any changes that might change how the widget is displayed, in the setState.
                onPressed: () => setState(() {
                  counter++;
                }),
              ),
            ),
          ),
        ],
      );

  // Can use getters like these to potentially do pretty complex operations, but still call it like its a class param!
  // class functions with no arguments are often better used as getters!
  // you can also define setters
  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
