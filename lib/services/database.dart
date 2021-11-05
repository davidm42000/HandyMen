import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference

  final CollectionReference normalUserCollection =
      FirebaseFirestore.instance.collection('normalUsers');
  final CollectionReference tradesmanCollection =
      FirebaseFirestore.instance.collection('tradesmen');

  Future updateNormalUserData(String? name, String address) async {
    return await normalUserCollection.doc(uid).set({
      'name': name,
      'address': address,
    });
  }

  Stream<QuerySnapshot> get tradesmen {
    return tradesmanCollection.snapshots();
  }
}
