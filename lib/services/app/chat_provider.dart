import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:skyle_clone/models/local/message.dart';
import 'package:skyle_clone/services/my_rest_api/chat_api.dart';
import 'package:skyle_clone/services/my_rest_api/storage_api.dart';
import 'package:skyle_clone/services/safety/change_notifier_safety.dart';
import 'package:skyle_clone/utils/app_log.dart';

class ChatProvider extends ChangeNotifierSafety {
  ChatApi _chatApi;
  StorageApi _strorageApi;

  ChatProvider() {
    _chatApi = ChatApi();
    _strorageApi=StorageApi();
  }

  @override
  void resetState() {
    // TODO: implement resetState
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) {
    return _chatApi.fetchContacts(userId: userId);
  }

  Future<void> addMessageToDb(Message message)  {
    return _chatApi.addMessageToDb(message);
  }
  Stream<QuerySnapshot> fetchMessagesBetween({
    @required String senderId,
    @required String receiverId,
  })
  {
    return _chatApi.fetchMessagesBetween(senderId: senderId,receiverId: receiverId);
  }

  // Future<void> uploadPhoto( {File imageFile,@required String receiverId,
  //   @required String senderId}) async
  // {
  //    _strorageApi.uploadImageToStorage(imageFile, (url) async{
  //        // await _chatApi.setImagesMsg(url, receiverId, senderId);
  //        logger.d("vao trong nay");
  //    }
  //
  //   );
  // }
  Future<void> uploadMultiPhoto( {@required List<File> imageFiles,@required String receiverId,
    @required String senderId}) async
  {
     List<String> urls= await _strorageApi.uploadMultiImages(files: imageFiles);
     logger.d("urls length "+urls.length.toString());

     await _chatApi.setImagesMsg(urls, receiverId, senderId);



  }
}
