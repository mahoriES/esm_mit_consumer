import 'dart:io';

import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
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
      height: AppSizes.profileImageSize.toWidth,
      width: AppSizes.profileImageSize.toWidth,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: CustomTheme.of(context).colors.placeHolderColor,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  (AppSizes.profileImageSize / 2).toWidth),
              child: FadeInImage(
                image: imageurl == null
                    ? NetworkImage(imageurl)
                    : AssetImage(ImagePathConstants.profilePlaceHolder),
                fit: BoxFit.cover,
                placeholder: AssetImage(
                  ImagePathConstants.profilePlaceHolder,
                ),
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
                              final PickedFile _file = await ImagePicker()
                                  .getImage(source: ImageSource.camera);
                              updateImage(File(_file.path));
                              Navigator.pop(context);
                            },
                          ),
                          new ListTile(
                            leading: new Icon(Icons.photo_album),
                            title: new Text('Gallery'),
                            onTap: () async {
                              final PickedFile _file = await ImagePicker()
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
                  borderRadius: BorderRadius.circular(
                      (AppSizes.profileImageEditIconSize / 2).toWidth),
                ),
                child: Container(
                  height: AppSizes.profileImageEditIconSize.toWidth,
                  width: AppSizes.profileImageEditIconSize.toWidth,
                  padding: EdgeInsets.all(15.toWidth),
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
