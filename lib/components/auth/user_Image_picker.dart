import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) onImagePicker;

  UserImagePicker(this.onImagePicker);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickerImageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    var pickerImage;

    showDialog(
      context: context,
      builder:(context) =>  AlertDialog(
      title: Text('Selecionar imagem de:'),
      actions: [
        TextButton.icon(
          onPressed: () async {
               pickerImage = await picker.getImage(
                source: ImageSource.camera,
                imageQuality: 80,
                maxWidth: 300,
              ).then((value) => null);
              Navigator.of(context).pop();
          },
          icon: Icon(Icons.camera_alt_rounded),
          label: Text('Camera'),
        ),
        TextButton.icon(
          onPressed: () async {
              pickerImage = await picker.getImage(
                source: ImageSource.gallery,
                imageQuality: 80,
                maxWidth: 300,
              );
              Navigator.of(context).pop();
          },
          icon: Icon(Icons.photo),
          label: Text('Galeria'),
        ),
      
      ],
    ),
    );
    
   

    setState(() {
      _pickerImageFile = File(pickerImage.path);
    });

    widget.onImagePicker(_pickerImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundColor: Colors.grey,
          backgroundImage: _pickerImageFile != null ? FileImage(_pickerImageFile) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.add),
          label: Text('Adicionar Imagem'),
        ),
      ],
    );
  }
}
