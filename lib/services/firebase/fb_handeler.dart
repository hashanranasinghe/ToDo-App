import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo_app/models/category_model.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/utils/constraints.dart';

class FbHandler {
  static final user = FirebaseAuth.instance.currentUser;
  static final firestoreInstance = FirebaseFirestore.instance;
  static final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  static const String chatboxpath = "chatbox";

//check doc is exists
  static Future<int> checkDocStatus(String collectionpath, String docid) async {
    var a = await FirebaseFirestore.instance
        .collection(collectionpath)
        .doc(docid)
        .get();
    if (a.exists) {
      return 1;
    } else if (!a.exists) {
      print('Not exists');
      return 0;
    } else {
      return 0;
    }
  }

// create doc random id;
  static Future<int> createDocAuto(
      Map<String, dynamic> model, String collectionpath) async {
    int res = resFail;
    try {
      await firestoreInstance
          .collection(collectionpath)
          .doc()
          .set(model)
          .then((_) {
        print("create  doc");
        res = resOk;
      });
    } on Exception catch (e) {
      print(e);
      res = resFail;
    }

    return res;
  }

  // create doc manual id;
  static Future<int> createDocManual(
      Map<String, dynamic> model, String collectionpath, String docid) async {
    int res = resFail;
    try {
      await firestoreInstance
          .collection(collectionpath)
          .doc(docid)
          .set(model)
          .then((_) {
        print("create  doc");
        res = resOk;
      });
    } on Exception catch (e) {
      print(e);
      res = resFail;
    }

    return res;
  }

//update doc
  static Future<int> updateDoc(Map<String, dynamic> model,
      List<String> collection, List<String> docId) async {
    int res = resFail;
    try {
      await firestoreInstance
          .collection(collection[0])
          .doc(docId[0])
          .collection(collection[1])
          .doc(docId[1])
          .update(model)
          .then((_) {
        print("update doc");
        res = resOk;
      });
    } on Exception catch (e) {
      print(e);
      res = resFail;
    }
    return res;
  }

  //update user doc
  static Future<int> updateUserDoc(
      Map<String, dynamic> model, String docId) async {
    int res = resFail;
    try {
      await firestoreInstance
          .collection("user")
          .doc(docId)
          .update(model)
          .then((_) {
        print("update user doc");
        res = resOk;
      });
    } on Exception catch (e) {
      print(e);
      res = resFail;
    }
    return res;
  }

  //delete doc
  static Future<int> deleteDoc(
      {required List<String> collection, required List<String> docId}) async {
    int res = resFail;
    try {
      await firestoreInstance
          .collection(collection[0])
          .doc(docId[0])
          .collection(collection[1])
          .doc(docId[1])
          .delete();
      print("delete doc");
      res = resOk;
    } on Exception catch (e) {
      print(e);
      res = resFail;
    }
    return res;
  }

//get user details
  static Future<UserModel> getUserById({required String id}) async {
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(id).get();
    final data = doc.data() as Map<String, dynamic>;
    final user = UserModel.fromMap(data);
    print(user.email);
    return user;
  }

  //get a task details
  static Future<TaskModel> getTask(
      {required String userId, required String taskId}) async {
    final doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('task')
        .doc(taskId)
        .get();
    final data = doc.data() as Map<String, dynamic>;
    final task = TaskModel.fromMap(taskId, data);
    return task;
  }

  //create doc for user
  static Future<int> createOwnDoc(
      {required String id,
      required String collectionPathOwn,
      required String collectionPath,
      required Map<String, dynamic> model}) async {
    int res = resFail;
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
    CollectionReference collection =
        firebaseFireStore.collection(collectionPathOwn);
    collection.doc(id).collection(collectionPath).add(model);
    res = resOk;
    return res;
  }

  //getTaskList
  static Future<List<TaskModel>> getAllTasks({required String id}) async {
    List<TaskModel> enlist = [];
    TaskModel model;
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection("user")
        .doc(id)
        .collection("task")
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];

      model = TaskModel.fromMap(a.id, a.data() as Map<String, dynamic>);

      enlist.add(model);
    }

    return enlist;
  }

  //getCategoryList
  static Future<List<CategoryModel>> getAllCategory(
      {required String id}) async {
    List<CategoryModel> enlist = [];
    CategoryModel model;
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection("user")
        .doc(id)
        .collection("category")
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];

      model = CategoryModel.fromMap(a.data() as Map<String, dynamic>);

      enlist.add(model);
    }

    return enlist;
  }

//realtimedb
  static Future<int> checkfiledstatus(String collectionpath) async {
    final snapshot = await dbRef.child('$collectionpath').get();
    if (snapshot.exists) {
      return 0;
    } else {
      return 1;
    }
  }
}
