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
  final Stream<QuerySnapshot> _tradesmanStream =
      FirebaseFirestore.instance.collection('tradesmen').snapshots();

  @override
  Widget build(BuildContext context) {
    // final tradesmen = Provider.of<List<Tradesman>>(context);

    // tradesmen.forEach((tradesman) {
    //   print(tradesman.name);
    // });

    // return ListView.builder(
    //   itemCount: tradesmen.length,
    //   itemBuilder: (context, index) {
    //     return TradesmanTile(tradesman: tradesmen[index]);
    //   },
    // );

    return StreamBuilder<QuerySnapshot>(
      stream: _tradesmanStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Card(
                margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.orange,
                  ),
                  title: Text(data['name']),
                  subtitle: Text(data['name']),
                  trailing: Text("5km"),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
