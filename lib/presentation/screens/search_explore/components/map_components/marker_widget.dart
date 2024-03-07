import 'package:avatar_stack/avatar_stack.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';

class ClusterMarkerWidget extends StatelessWidget {

  final String markerFee;
  final String? imageIcon;
  final Color textColor;
  final Color clusterColor;

  const ClusterMarkerWidget({super.key, required this.markerFee, this.imageIcon, required this.textColor, required this.clusterColor});


  @override
  Widget build(BuildContext context) {
    print(imageIcon);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: clusterColor
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(markerFee, style: TextStyle(color: textColor),),
          ),
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Positioned(
              left: 5,
              bottom: 5,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    color: textColor,
                    borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            SizedBox(
                height: 80,
                width: 80,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(imageIcon ?? '', fit: BoxFit.cover), )
            ),
          ],
        )
      ],
    );
  }
}


class SingleMarkerWidget extends StatelessWidget {

  final String markerFee;
  final String? imageIcon;
  final Color textColor;
  final Color clusterColor;

  const SingleMarkerWidget({super.key, required this.markerFee, this.imageIcon, required this.textColor, required this.clusterColor});


  @override
  Widget build(BuildContext context) {
    print(imageIcon);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: clusterColor
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(markerFee, style: TextStyle(color: textColor),),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
              child: Image.network(imageIcon ?? '', fit: BoxFit.cover,),)
        ),
      ],
    );
  }
}
