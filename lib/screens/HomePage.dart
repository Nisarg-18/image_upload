import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  File? _finalImage;

  //function to pick a image from gallery
  pickImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _finalImage = File(image.path);
      });
    }
  }

//function to upload the image to server
  uploadImage(filepath) async {
    String imageName = basename(filepath.path);

    try {
      var formData = FormData.fromMap({
        "file":
            await MultipartFile.fromFile(filepath.path, filename: imageName),
      });
      var response = await Dio()
          .post('https://codelime.in/api/remind-app-token', data: formData);
      print(response);
    } catch (e) {
      print('error-$e');
    }
  }

//to show a success message after image is uploaded
  showMessage(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(fontSize: 17),
                  ))
            ],
            title: Text('Successfully Uploaded'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Upload Image'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
                padding: EdgeInsets.all(30.0),
                child: _finalImage != null
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Center(child: Image.file(_finalImage!)),
                      )
                    : Container(
                        color: Colors.grey[400],
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Center(
                            child: Text(
                          'Add a image to upload',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17),
                        )),
                      )),
          ),
          _finalImage != null
              ? Center(
                  child: FloatingActionButton(
                    tooltip: 'Upload',
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () async {
                      await uploadImage(_finalImage);
                      showMessage(context);
                      setState(() {
                        _finalImage = null;
                      });
                    },
                    child: Icon(Icons.done),
                  ),
                )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Image',
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          pickImage();
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
