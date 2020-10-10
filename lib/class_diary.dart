import 'package:cloud_firestore/cloud_firestore.dart';

class Diary {
  final DateTime date;
  final String message;
  final int level;
  final String image;
  final DocumentReference reference;

  Diary.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['message'] != null),
        assert(map['level'] != null),
        assert(map['date'] != null),
        assert(map['image'] != null),
        message = map['message'],
        image = map['image'],
        date = map['date'].toDate(),
        level = map['level'];

  Diary.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$message:$level>";
}
