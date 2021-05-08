import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  final Image initImage;
  ImageInput(this.onSelectImage, this.initImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  Image _image;
  final picker = ImagePicker();

  @override
  void initState() {
    if (widget.initImage != null) {
      _image = widget.initImage;
    }

    super.initState();
  }

  Future<void> _selectImage() async {
    final imageFile = await picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 700,
    );
    _saveImage(imageFile);
  }

  Future<void> _getImage() async {
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 500,
      maxHeight: 700,
    );
    _saveImage(imageFile);
  }

  Future<void> _saveImage(PickedFile imageFile) async {
    setState(() {
      if (imageFile != null) {
        _image = Image.file(
          File(imageFile.path),
          fit: BoxFit.cover,
          width: double.infinity,
        );
      }
    });
    final appDirectory = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);
    final savedImage =
        await File(imageFile.path).copy('${appDirectory.path}/$fileName');

    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black12),
          ),
          child: _image != null
              ? _image
              : Text(
                  'No image selected',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  TextButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text(
                      'Take Picture',
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _getImage,
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.photo),
                    label: Text(
                      'Select Picture',
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _selectImage,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Expanded(
        //   child: TextButton.icon(
        //     icon: Icon(Icons.photo),
        //     label: Text(
        //       'Take Picture',
        //       textAlign: TextAlign.center,
        //     ),
        //     onPressed: _getImage,
        //   ),
        // ),
      ],
    );
  }
}
