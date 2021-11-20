import 'package:cloud_firestore/cloud_firestore.dart';

class Tradesman {
  final String name;
  final String id;

  Tradesman({
    required this.name,
    required this.id,
  });

    factory Tradesman.fromMap(DocumentSnapshot doc) {
      return Tradesman(
        id: doc.id,
        name: doc.get('name') ?? '',
    );
  }
}
