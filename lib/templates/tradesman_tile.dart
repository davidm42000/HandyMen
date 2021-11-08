import 'package:flutter/material.dart';
import 'package:handy_men/models/tradesman_model.dart';

class TradesmanTile extends StatelessWidget {
  final Tradesman tradesman;

  const TradesmanTile({required this.tradesman});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.orange,
          ),
          title: Text(tradesman.name),
          subtitle: Text(tradesman.name),
          trailing: Text("5km"),
        ),
      ),
    );
  }
}
