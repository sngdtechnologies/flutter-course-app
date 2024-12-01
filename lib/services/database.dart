// ignore_for_file: unused_import, unused_element, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:premiere/models/chat_params.dart';
import 'package:provider/provider.dart';
import 'package:premiere/models/user.dart';
import 'package:premiere/services/message_database.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("utilisateurs");
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
   final MessageDatabaseService messageService = MessageDatabaseService();

  Future<void> saveUser(String nom, int telephone) async {
    return await userCollection.doc(uid).set({'nom': nom, 'telephone': telephone});
  }

  Future<void> saveToken(String token) async {
    return await userCollection.doc(uid).update({'token': token});
  }

  AppUserData? _userFromSnapshot(DocumentSnapshot? snapshot) {
    var data = snapshot!.data() as Map;
    if (data == null) throw Exception("user not found");
    return AppUserData(
      uid: snapshot.id,
      nom: data['nom'],
      timestamps: data['timestamps'],
    );
  }

  // Stream<List<AppUserData>> getStreamOfMyModel() {
  //   // Query queryUser = userCollection.orderBy('carTimestamp', descending: false);
  //   return userCollection.snapshots().map((snapshot) => 
  //     snapshot.docs.map((doc) {
  //       AppUserData(
  //         uid: doc.id,
  //         nom: doc.get('nom'),
  //         profil: doc.get('profil'),
  //         timestamps: doc.get('timestamps'),
  //       );
  //     }).toList() 
  //   );
  // }

  // Stream<List<AppUserData>> getStreamOfMyModel() {
  //   // Query queryUser = userCollection.orderBy('carTimestamp', descending: false);
  //   return userCollection.snapshots().map((snapshot) => 
  //     snapshot.docs.map((doc) {
  //       print(doc.get('nom'));
  //       AppUserData(
  //         uid: doc.id,
  //         nom: doc.get('nom'),
  //         profil: doc.get('profil'),
  //         recentMsg: messageService.getLastMessage(doc.id)['lastMessage'],
  //         unRead: messageService.getUnRead(doc.id),
  //         timestamps: messageService.getLastMessage(doc.id)['timestamps'],
  //       );
  //     }).toList() 
  //   );
  // }

  Stream<AppUserData?>? get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  Stream<List<Map<String, dynamic>>> getStreamOfMyModel() { //                        <--- Stream
    // return Stream<String>.value('Coucou');
    List<Map<String, dynamic>> listUser = [];
    Map<String, dynamic> _appUserData;
    
    _firebaseFirestore.collection("utilisateurs").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(messageService.getLastMessage(result.id));
        _appUserData = {
          'uid': result.id,
          'nom': result.data()["nom"],
          'profil': result.data()["profil"],
          'lastMessage': messageService.getLastMessage(result.id),
          'unRead': messageService.getUnRead(result.id),
        };
        listUser.add(_appUserData);
      });
    });

    return Stream.value(listUser);
  }

  Stream<List<Map<String, dynamic>>> getListMessage() { //                        <--- Stream
    // return Stream<String>.value('Coucou');
    List<Map<String, dynamic>> listUser = [];
    Map<String, dynamic> _appUserData;

    // String groupChatId = ChatParams(FirebaseAuth.instance.currentUser.uid, peer).getChatGroupId();
    // var doc = await FirebaseFirestore.instance
    //     .collection('messages')
    //     .doc(groupChatId)
    //     .collection(groupChatId).get();
    // if(doc.docs.length > 0)
    //   setState(() {
    //     _listmsg.add(doc.docs.last.data());
    //     // print(doc.docs.last.data());
    //   });
    // else 
    //   setState(() {
    //     _listmsg.add(lastMessage);
    //   });
    
    _firebaseFirestore.collection("utilisateurs").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        // print(result.id);
        String? groupChatId = ChatParams(FirebaseAuth.instance.currentUser!.uid, result.id).getChatGroupId();
        var val, val2;
        var doc = await FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId).get();

          
          if(doc.docs.isNotEmpty)
            val = doc.docs.last.data();
          else
            val = {
              'content': '',
              'timestamp': '',
              'type': 0,
            };

        var doc2 = await FirebaseFirestore.instance
            .collection('messages')
            .doc(groupChatId)
            .collection(groupChatId)
            .where('read', isEqualTo: false)
            .where('idTo', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();

        if(doc2.docs.isNotEmpty)
          val2 = doc2.docs.length;
        else 
          val2 = 0;

        _appUserData = {
          'uid': result.id,
          'nom': result.data()["nom"],
          'profil': result.data()["profil"],
          'lastMessage': val,
          'unRead': val2,
        };
        listUser.add(_appUserData);
      });
    });

    return Stream.value(listUser);
  }

  List<Map<String, dynamic>> connection() {
    List<Map<String, dynamic>> listUser = [];
    Map<String, dynamic> _appUserData;

    _firebaseFirestore.collection("utilisateurs").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        _appUserData = result.data();
        listUser.add(_appUserData);
      });
    });
    return listUser;
  }
  Stream<List<AppUserData>> get usersList => Stream.value(connection().map((e) => AppUserData(uid: e["uid"], nom: e["nom"], profil: e["profil"], timestamps: e["timestamps"])).toList());

  List<AppUserData?>? _userListFromSnapshot(QuerySnapshot? snapshot) {
    return snapshot!.docs.map((doc) {
      return _userFromSnapshot(doc);
    }).toList();
  }

  // Stream<List<AppUserData>> get users {
  //   return userCollection.snapshots().map(_userListFromSnapshot);
  // }
}
