import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/profile_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectorWithPreview extends StatefulWidget {

  final DashboardModel model;
  final List<ImageUpload> currentImageList;
  final Function(List<ImageUpload>) imagesToUpLoad;

  ImageSelectorWithPreview({super.key, required this.model, required this.currentImageList, required this.imagesToUpLoad});

  @override
  State<ImageSelectorWithPreview> createState() => _ImageSelectorWithPreviewState();
}

class _ImageSelectorWithPreviewState extends State<ImageSelectorWithPreview> {
  final ImagePicker _imagePicker = ImagePicker();
  late List<ImageUpload> currentImages = [];

  @override
  void initState() {
    // TODO: implement initState
    currentImages.addAll(widget.currentImageList);
    super.initState();
  }

  void _handleImageSelection(BuildContext context) async {
    final images = await _imagePicker.pickMultiImage();

    if (images != null && (images.isNotEmpty)) {
      if ((images.length + images.length) <= 6 && images.length <= 6) {

        for (XFile dataImage in images) {

          final imageFile = await dataImage.readAsBytes();
          currentImages.add(ImageUpload(
              key: imageFile.first.toString(),
              imageToUpload: imageFile
            )
          );
        }
        widget.imagesToUpLoad(currentImages);
      } else {
        final snackBar = SnackBar(
            elevation: 4,
            backgroundColor: widget.model.paletteColor,
            content: Text('Sorry, only 6 Images can be added. Please try again', style: TextStyle(color: widget.model.webBackgroundColor))
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return mainTopContainer(
        context: context,
        model: widget.model,
        numberOfImages: ['1','2','3','4','5','6'],
        currentImages: currentImages,
        didSelectImage: () {
            _handleImageSelection(context);
        },
        activityProfileImagesChanged: (images) {
          currentImages.clear();
          currentImages.addAll(images);
          widget.imagesToUpLoad(images);
        }
    );
  }
}