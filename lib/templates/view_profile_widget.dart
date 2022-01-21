import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ViewProfileWidget extends StatefulWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;
  const ViewProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
    this.isEdit = false,
  }) : super(key: key);

  @override
  _ViewProfileWidgetState createState() => _ViewProfileWidgetState();
}

late String _imagePath;

class _ViewProfileWidgetState extends State<ViewProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        buildImage(),
      ]),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(widget.imagePath);
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(
            onTap: widget.onClicked,
          ),
        ),
      ),
    );
  }
}
