import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skyle_clone/utils/app_log.dart';
import 'package:file_picker/file_picker.dart';
class AppUpload {
  static Future<List<File>> pickImage({@required ImageSource source}) async {
    List<File> results=[];
    try {
      if(source==ImageSource.camera)
      {
        final picker = ImagePicker();
        PickedFile selectedImage = await picker.getImage(source: source);
        if(selectedImage!=null)
        {
          File file= await compressImage(File(selectedImage.path));
          results.add(file);

        }

      }
      else
      {

        List<PlatformFile> files= (await FilePicker.platform.pickFiles(type: FileType.image,allowMultiple: true)).files;
        logger.d("files length ${files.length} 123");
        await Future.wait(files.map((PlatformFile platformFile) async{
          File fileConvert=File(platformFile.path);
          File file=  await compressImage(fileConvert);
          results.add(file);
        }));


      }


    } catch (e) {
      logger.e(e.toString());

    }
    return results;
    // try {
    //
    //   FilePickerResult selectedImage = await FilePicker.platform.pickFiles(type: FileType.image,);
    //   if(selectedImage!=null)
    //   {
    //     return await compressImage(selectedImage);
    //   }else
    //   {
    //     return null;
    //   }
    //
    // } catch (e) {
    //   logger.e(e.toString());
    //   return null;
    // }
  }
  // static Future<File> pickMultiImage({@required ImageSource source}) async {
  //   try {
  //     final picker = ImagePicker();
  //     PickedFile selectedImage = await picker.;
  //     if(selectedImage!=null)
  //     {
  //       return await compressImage(selectedImage);
  //     }else
  //     {
  //       return null;
  //     }
  //
  //   } catch (e) {
  //     logger.e(e.toString());
  //     return null;
  //   }
  // }
  static Future<File> compressImage(File imageToCompress) async {
    if (imageToCompress != null) {
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;
      int rand = Random().nextInt(10000);


      Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
      Im.copyResize(image, width: 500, height: 500);

      return new File('$path/img_$rand.jpg')
        ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
    }
    return null;
  }
}
