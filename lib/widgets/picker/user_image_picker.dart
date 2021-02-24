import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class USerImagePicker extends StatefulWidget {
  USerImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;
  @override
  _USerImagePickerState createState() => _USerImagePickerState();
}

class _USerImagePickerState extends State<USerImagePicker> {
  File _pickedImage;
  void _pickImage() async{
    final pickedImageFile = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

  //To be completed
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select an Option'),
          actions: <Widget>[
            Row(children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.camera_alt),),
              IconButton(onPressed: (){}, icon: Icon(Icons.image)),
            ],)

          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 40, backgroundColor: Colors.grey, backgroundImage: _pickedImage != null ? FileImage(_pickedImage) : null,),
        FlatButton.icon(onPressed: _pickImage, icon: Icon(Icons.image), label: Text('Add Picture'), textColor: Theme.of(context).primaryColor,),
      ],
    );
  }
}
