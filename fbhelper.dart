// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'model.dart';

// class FirebaseHelper {
//   static final _firestore = FirebaseFirestore.instance;
//   static final _collection = _firestore.collection('todos');

//   static Future<void> addTodo(My_model todo) async {
//     await _collection.add(todo.toJson());
//   }

//   static Future<List<My_model>> getTodos() async {
//     final snapshot = await _collection.get();
//     return snapshot.docs.map((doc) => My_model.frommap(doc.data())).toList();
//   }

//   static Future<void> deleteTodo(String docId) async {
//     await _collection.doc(docId).delete();
//   }
// }
