import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handy_men/models/tradesman_model.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference

  final CollectionReference normalUserCollection =
      FirebaseFirestore.instance.collection('normalUsers');
  final CollectionReference tradesmanCollection =
      FirebaseFirestore.instance.collection('tradesmen');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('userData');

  // Query q = FirebaseFirestore.instance
  //     .collection('tradesmen')
  //     .where('name', isEqualTo: 'Jims');

  Future updateNormalUserData(String? name, String? address) async {
    return await normalUserCollection.doc(uid).set({
      'name': name,
      'address': address,
    });
  }

  // tradesmen list from snapshot
  List<Tradesman> _tradesmenListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return Tradesman(
          name: doc.get('name') ?? "",
          id: doc.get('id') ?? "",
        );
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Stream<List<Tradesman>> get tradesmen {
    return tradesmanCollection.snapshots().map(_tradesmenListFromSnapshot);
  }
}
