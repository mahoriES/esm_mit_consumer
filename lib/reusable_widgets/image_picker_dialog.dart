import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// This is a temperory component.
// Will be modified later for new designs.

class ImagePickerDialog extends StatelessWidget {
  final Function(ImageSource) onSelect;
  const ImagePickerDialog(this.onSelect, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Wrap(
        children: <Widget>[
          new ListTile(
            leading: new Icon(Icons.photo_camera),
            title: new Text(tr("common.camera")),
            onTap: () {
              Navigator.pop(context);
              onSelect(ImageSource.camera);
            },
          ),
          new ListTile(
            leading: new Icon(Icons.photo_album),
            title: new Text(tr("common.gallery")),
            onTap: () {
              Navigator.pop(context);
              onSelect(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
