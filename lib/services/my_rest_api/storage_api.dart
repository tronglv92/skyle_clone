import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:skyle_clone/utils/app_log.dart';

class StorageApi {

  final FirebaseStorage _storage=FirebaseStorage.instance;
  Future<List<String>> uploadMultiImages(
      { @required List<File> files}) async {
    List<String> uploadUrls = [];

    await Future.wait(files.map((File imageFile) async {


     await uploadImageToStorage(imageFile, (url)  {


        uploadUrls.add(url);
     });
    }));

    return uploadUrls;
  }
  Future<void> uploadImageToStorage(File imageFile,Function(String url) onComplete) async {
    if(imageFile!=null)
      {
        try {
          Reference _storageReference=_storage.ref().child('${DateTime.now().millisecondsSinceEpoch}');


          UploadTask uploadTask= _storageReference.putFile(imageFile);
          await uploadTask.then((res) async{
            String downloadUrl=await res.ref.getDownloadURL();
            onComplete(downloadUrl);
          });


        } catch (e) {
          logger.e("uploadImageToStorage error "+e.toString());

        }
      }


  }
}
