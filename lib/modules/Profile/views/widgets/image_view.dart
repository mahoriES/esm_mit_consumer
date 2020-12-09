import 'dart:io';

import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageView extends StatelessWidget {
  final String imageurl;
  final Function(File) updateImage;
  const ProfileImageView({
    @required this.imageurl,
    @required this.updateImage,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156.toFont,
      width: 156.toFont,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: CustomTheme.of(context).colors.placeHolderColor,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(156.toFont),
              child: Image.network(
                imageurl ?? "",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext bc) {
                    return Container(
                      child: new Wrap(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(child: Text("Image Upload From ?")),
                          ),
                          new ListTile(
                            leading: new Icon(Icons.photo_camera),
                            title: new Text('Camera'),
                            onTap: () async {
                              PickedFile _file = await ImagePicker()
                                  .getImage(source: ImageSource.camera);
                              updateImage(File(_file.path));
                              Navigator.pop(context);
                            },
                          ),
                          new ListTile(
                            leading: new Icon(Icons.photo_album),
                            title: new Text('Gallery'),
                            onTap: () async {
                              PickedFile _file = await ImagePicker()
                                  .getImage(source: ImageSource.gallery);
                              updateImage(File(_file.path));
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(48.toFont),
                ),
                child: Container(
                  height: 48.toFont,
                  width: 48.toFont,
                  padding: EdgeInsets.all(15.toFont),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: CustomTheme.of(context).colors.backgroundColor,
                  ),
                  child: Icon(
                    Icons.edit_sharp,
                    color: CustomTheme.of(context).colors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
