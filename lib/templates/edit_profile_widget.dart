import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EditProfileWidget extends StatefulWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;
  const EditProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
    this.isEdit = false,
  }) : super(key: key);

  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

late String _imagePath;

class _EditProfileWidgetState extends State<EditProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        buildImage(),
        Positioned(
          bottom: 0,
          right: 4,
          child: buildEditIcon(),
        ),
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

  Widget buildEditIcon() {
    return buildCircle(
      all: 8,
      child: Icon(
        Icons.add_a_photo,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget buildCircle({
    required Widget child,
    required double all,
  }) =>
      ClipOval(
        child: Container(
          child: child,
          padding: EdgeInsets.all(all),
          color: Colors.blueAccent,
        ),
      );
}
