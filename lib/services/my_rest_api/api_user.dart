
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skyle_clone/constants/strings.dart';
import 'package:skyle_clone/models/local/db_user.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skyle_clone/utils/app_colors.dart';
import 'package:skyle_clone/utils/app_log.dart';
import 'package:skyle_clone/utils/helper/user_helper.dart';
const String TAG_API_USER="ApiUser ";
class ApiUser{
   final FirebaseAuth _auth=FirebaseAuth.instance;
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   GoogleSignIn _googleSignIn;


  ApiUser(){
    print("Create Api User");
    _googleSignIn=GoogleSignIn();
  }

  CollectionReference userCollection(){
    return _firestore.collection(USERS_COLLECTION);
  }
   User getCurrentUser()  {
    User currentUser= _auth.currentUser;
    return currentUser;
  }
  Future<DBUser> getUserDetails() async {
    User currentUser =  getCurrentUser();

    DocumentSnapshot documentSnapshot =
    await userCollection().doc(currentUser.uid).get();
    return DBUser.fromJson(documentSnapshot.data());
  }
  Future<DBUser> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
      await userCollection().doc(id).get();
      return DBUser.fromJson(documentSnapshot.data());
    } catch (e) {
      logger.e(TAG_API_USER+"getUserDetailsById error");
      logger.e(e.toString());
      return null;
    }
  }
  Future<User> loginByGoogle() async {

    try{
      GoogleSignInAccount _signInAccount=await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication=await _signInAccount.authentication;
      final AuthCredential credential=GoogleAuthProvider.credential(idToken:_signInAuthentication.idToken ,accessToken: _signInAuthentication.accessToken);
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    }
    catch(e){
      logger.e(TAG_API_USER+"signIn error");
      logger.e(e.toString());

      return null;

    }
  }
   Future<bool> userExits(User user) async {
     QuerySnapshot result = await _firestore
         .collection(USERS_COLLECTION)
         .where(EMAIL_FIELD, isEqualTo: user.email)
         .get();

     final List<DocumentSnapshot> docs = result.docs;

     //if user is registered then length of list > 0 or else less than 0
     return docs.length == 0 ? true : false;
   }
  Future<void> addUserToFirebaseDb(User currentUser) async {
    String username = UserHelper.getUsername(currentUser.email);

    DBUser user = DBUser(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoURL,
        username: username);

    _firestore
        .collection(USERS_COLLECTION)
        .doc(currentUser.uid).set(user.toJson(user))
       ;
  }
   Future<List<DBUser>> fetchAllUsers(DBUser currentUser) async {
     List<DBUser> userList =[];

     QuerySnapshot querySnapshot =
     await _firestore.collection(USERS_COLLECTION).get();
     for (var i = 0; i < querySnapshot.docs.length; i++) {
       if (querySnapshot.docs[i].id != currentUser.uid) {
         userList.add(DBUser.fromJson(querySnapshot.docs[i].data()));
       }
     }
     return userList;
   }
  Future<bool> logOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      logger.e(TAG_API_USER+"signOut error");
      logger.e(e.toString());
      return false;
    }
  }
}
