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

    //pega da CAMERA OU GALERIA (faça uma pergunta para o usuário escolher)
    final pickerImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 160,
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
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickerImageFile != null ? FileImage(_pickerImageFile) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.camera_alt_outlined),
          label: Text('Adicionar Imagem'),
        ),
      ],
    );
  }
}
