import 'package:flutter/material.dart';
import 'package:handy_men/models/tradesman_model.dart';
import 'package:handy_men/templates/tradesman_tile.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TradesmenList extends StatefulWidget {
  const TradesmenList({Key? key}) : super(key: key);

  @override
  _TradesmenListState createState() => _TradesmenListState();
}

class _TradesmenListState extends State<TradesmenList> {
  @override
  Widget build(BuildContext context) {
    final tradesmen = Provider.of<List<Tradesman>>(context);

    tradesmen.forEach((tradesman) {
      print(tradesman.name);
    });

    return ListView.builder(
      itemCount: tradesmen.length,
      itemBuilder: (context, index) {
        return TradesmanTile(tradesman: tradesmen[index]);
      },
    );
  }
}
