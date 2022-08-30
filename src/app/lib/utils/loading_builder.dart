import 'package:flutter/material.dart';

class LoadingBuilder<M> extends StatefulWidget {
  final Future<M> loader;
  final Widget Function(M) constructor;
  final M? initialModel;

  const LoadingBuilder(this.loader, this.constructor, {super.key, this.initialModel});

  @override
  State<LoadingBuilder> createState() => LoadingBuilderState<M>();
}

class LoadingBuilderState<M> extends State<LoadingBuilder<M>> {
  M? model;

  @override
  Widget build(BuildContext context) {
    if (widget.initialModel != null) {
      return widget.constructor(widget.initialModel as M);
    } else {
      return FutureBuilder<M>(
          future: widget.loader,
          builder: ((BuildContext context, AsyncSnapshot<M> snapshot) {
            if (snapshot.hasData) {
              return widget.constructor(snapshot.data as M);
            } else if (snapshot.hasError) {
              return const Text("Something went wrong...");
            } else {
              return Container(padding: const EdgeInsets.all(30), child: const CircularProgressIndicator());
            }
          }));
    }
  }
}
