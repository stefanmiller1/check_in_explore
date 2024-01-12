import 'dart:typed_data';

import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

class ImageSelectorWithPreview extends StatelessWidget {

  final DashboardModel model;
  final List<ImageUpload> currentImageList;
  final Function(List<ImageUpload>) imagesToUpLoad;

  const ImageSelectorWithPreview({super.key, required this.currentImageList, required this.imagesToUpLoad, required this.model});


  void _handleImageSelection(BuildContext context) async {

    final file = await ImagePickerWeb.getMultiImagesAsBytes();
    late List<ImageUpload> currentImages = [];
    currentImages.addAll(currentImageList);


      if (file != null && (file.isNotEmpty)) {
        if ((file.length + currentImages.length) <= 6 && currentImages.length <= 6) {
          for (Uint8List dataImage in file) {

            currentImages.add(ImageUpload(
                key: dataImage.first.toString(),
                imageToUpload: dataImage
              )
            );
          }
          imagesToUpLoad(currentImages);
          // context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityProfileImagesChanged(currentImages));
        } else {
          final snackBar = SnackBar(
              elevation: 4,
              backgroundColor: model.paletteColor,
              content: Text('Sorry, only 6 Images can be added. Please try again', style: TextStyle(color: model.webBackgroundColor))
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return mainTopContainer(
        context: context,
        model: model,
        numberOfImages: ['1','2','3','4','5','6'],
        currentImages: currentImageList,
        didSelectImage: () {
            _handleImageSelection(context);
        },
        activityProfileImagesChanged: (images) {
          imagesToUpLoad(images);
        }
    );
  }

}