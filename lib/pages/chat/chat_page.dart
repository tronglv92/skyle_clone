import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skyle_clone/models/local/db_user.dart';
import 'package:skyle_clone/models/local/message.dart';
import 'package:skyle_clone/pages/chat/views/receiver_layout.dart';
import 'package:skyle_clone/pages/chat/views/sender_layout.dart';
import 'package:skyle_clone/services/app/auth_provider.dart';
import 'package:skyle_clone/services/app/chat_provider.dart';
import 'package:skyle_clone/services/safety/page_stateful.dart';
import 'package:skyle_clone/utils/app_colors.dart';
import 'package:skyle_clone/utils/app_log.dart';
import 'package:skyle_clone/utils/app_permission.dart';
import 'package:skyle_clone/utils/app_upload.dart';
import 'package:skyle_clone/widgets/appbar.dart';
import 'package:provider/provider.dart';
import 'chat_controls.dart';

class ChatPage extends StatefulWidget {
  final DBUser receiver;

  ChatPage({this.receiver});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends PageStateful<ChatPage> {
  bool isWriting = false;
  bool showEmojiPicker = false;
  DBUser currentUser;
  TextEditingController textFieldController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();

  AuthProvider _authProvider;
  ChatProvider _chatProvider;

  ScrollController _listController;
  final picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listController=ScrollController();
  }

  @override
  void initDependencies(BuildContext context) {
    super.initDependencies(context);
    _authProvider = Provider.of(context, listen: false);
    _chatProvider= Provider.of(context, listen: false);

  }

  @override
  Future<void> afterFirstBuild(BuildContext context) async {
    super.afterFirstBuild(context);
    currentUser = _authProvider.user;
  }

  // chat control
  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  void pickImage({@required ImageSource source}) async {
      List<File> files=  await AppUpload.pickImage(source: ImageSource.gallery);
      logger.d('files length ${files.length}');
      await _chatProvider.uploadMultiPhoto(senderId:currentUser?.uid,receiverId: widget.receiver?.uid,imageFiles:files);

    // File selectedImage=await AppUpload.pickImage(source: source);
    //
    // // File selectedImage = await AppUpload.pickImage(source: source);
    //
    // if(selectedImage!=null)
    //   {
    //     await _chatProvider.uploadPhoto(imageFile: selectedImage,senderId:currentUser?.uid,receiverId: widget.receiver?.uid );
    //   }


  }

  addMediaModal() {}

  onChangeMessage(val) {
    (val.length > 0 && val.trim() != "")
        ? setWritingTo(true)
        : setWritingTo(false);
  }

  setWritingTo(bool val) {
    setState(() {
      isWriting = val;
    });
  }

  onPressEmoji() {
    if (!showEmojiPicker) {
      // keyboard is visible
      hideKeyboard();
      showEmojiContainer();
    } else {
      //keyboard is hidden
      showKeyboard();
      hideEmojiContainer();
    }
  }

  sendMessage() async{
    if (currentUser != null && widget.receiver != null) {

      var text = textFieldController.text;
      Message _message = Message(
          senderId: currentUser.uid,
          message: text,
          type: 'text',
          receiverId: widget.receiver.uid,
          timestamp: Timestamp.now());

      textFieldController.text='';
      setWritingTo(false);
      await _chatProvider.addMessageToDb(_message);

    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: [
          Flexible(child: messageList()),
          ChatControls(
            isWriting: isWriting,
            pickImage: pickImage,
            addMediaModal: addMediaModal,
            onChangedMessage: onChangeMessage,
            onPressEmoji: onPressEmoji,
            onPressHideEmoji: hideEmojiContainer,
            onPressSendMessage: sendMessage,
            focusNode: textFieldFocus,
            textEditingController: textFieldController,
          ),
          showEmojiPicker==true?Container(child: emojiContainer()):Container()
        ],
      ),
    );
  }

  Widget messageList(){
    return StreamBuilder(
        stream: _chatProvider.fetchMessagesBetween(senderId: authProvider.user?.uid,receiverId:widget.receiver?.uid ),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.data==null)
            {
              return Center(child:  CircularProgressIndicator(),);
            }

          var docsList=snapshot.data.docs;
          return ListView.builder(
              padding: EdgeInsets.all(10),
              controller:_listController ,
              reverse: true,
              itemCount: docsList.length,
              itemBuilder: (context,index){
                return chatMessageItem(docsList[index]);
          });
        });
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromJson(snapshot.data());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == currentUser?.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == currentUser?.uid
            ? SenderLayout(message: _message,)
            : ReceiverLayout(message: _message),
      ),
    );
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiver!=null?widget.receiver.name:'',
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
          ),
          onPressed: () {
            // await AppPermission.cameraAndMicrophonePermissionsGranted()
            //     ? CallUtils.dial(
            //   from: sender,
            //   to: widget.receiver,
            //   context: context,
            // )
          },
        ),
        IconButton(
          icon: Icon(
            Icons.phone,
          ),
          onPressed: () {},
        )
      ],
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: AppColors.separatorColor,
      indicatorColor: AppColors.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        textFieldController.text = textFieldController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }


}
