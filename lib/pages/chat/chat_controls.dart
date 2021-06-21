import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skyle_clone/utils/app_colors.dart';

class ChatControls extends StatelessWidget {
  final bool isWriting;

  final Function({@required ImageSource source}) pickImage;

  final Function addMediaModal;
  final Function(String message) onChangedMessage;
  final Function onPressEmoji;
  final Function onPressSendMessage;
  final Function onPressHideEmoji;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  ChatControls(
      {this.isWriting = false,
      this.pickImage,
      this.addMediaModal,
      this.onChangedMessage,
      this.onPressEmoji,
      this.onPressSendMessage,
      this.onPressHideEmoji,
      this.focusNode,
      this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: AppColors.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add,color: Colors.white,),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onTap: onPressHideEmoji,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: onChangedMessage,
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: AppColors.greyColor,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: AppColors.separatorColor,
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: onPressEmoji,
                  color: Colors.white,
                  icon: Icon(Icons.face,color: Colors.white),
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over,color: Colors.white),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  child: Icon(Icons.camera_alt,color: Colors.white),
                  onTap: () => pickImage(source: ImageSource.gallery),
                ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: AppColors.fabGradient, shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15,
                        color: Colors.white
                    ),
                    onPressed: onPressSendMessage,
                  ))
              : Container()
        ],
      ),
    );
  }
}
