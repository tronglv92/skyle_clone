import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skyle_clone/constants/strings.dart';
import 'package:skyle_clone/models/local/contact.dart';
import 'package:skyle_clone/models/local/message.dart';

class ChatApi{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
   CollectionReference userCollection(){
      return _firestore.collection(USERS_COLLECTION);
  }
  CollectionReference messageCollection(){
    return _firestore.collection(MESSAGES_COLLECTION);
  }


  DocumentReference getContactsDocument({String of, String forContact}) =>
      userCollection()
          .doc(of)
          .collection(CONTACTS_COLLECTION)
          .doc(forContact);

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();
    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContacts( String senderId,
      String receiverId,
      Timestamp currentTime,) async
  {
      DocumentSnapshot senderSnapshot =
    await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toJson(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }
  Future<void> addToReceiverContacts(
      String senderId,
      String receiverId,
      currentTime,
      ) async {
    DocumentSnapshot receiverSnapshot =
    await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toJson(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }
  Future<void> addMessageToDb(Message message) async{
    var messageJson=message.toJson();
    await messageCollection().doc(message.senderId).collection(message.receiverId).add(messageJson);
    addToContacts(senderId: message.senderId, receiverId: message.receiverId);
    return await messageCollection()
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(messageJson);

  }
  Stream<QuerySnapshot> fetchMessagesBetween({
     String senderId,
    String receiverId,
  }) {
    return messageCollection()
        .doc(senderId)
        .collection(receiverId)
        .orderBy(TIMESTAMP_FIELD, descending: true)
        .snapshots();
  }
  Future<void> setImagesMsg(List<String> urls, String receiverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrls: urls,
        timestamp: Timestamp.now(),
        type: 'image');

    // create imagemap
    var map = message.toImageJson();


    // var map = Map<String, dynamic>();
    await messageCollection()
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);

    await messageCollection()
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }


  Stream<QuerySnapshot> fetchContacts({String userId}) => userCollection()
      .doc(userId)
      .collection(CONTACTS_COLLECTION)
      .snapshots();
}
