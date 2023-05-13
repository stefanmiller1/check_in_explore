import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';

/// CURRENT LOCATION
Widget searchSettingsButton(DashboardModel model, {required Function() didSelectButton, required IconData iconItem, required String buttonTitle, required bool isSelected}) {
  return Container(
    decoration: BoxDecoration(
        color: (isSelected) ? model.paletteColor : model.accentColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: model.disabledTextColor)
    ),
    child: InkWell(
      onTap: () {
        didSelectButton();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 1),
            Container(
                decoration: BoxDecoration(
                  color: model.disabledTextColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(iconItem, color: model.disabledTextColor),
                )
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(buttonTitle, style: TextStyle(color: (isSelected) ? model.accentColor : model.paletteColor, fontWeight: FontWeight.normal, decoration: TextDecoration.none, fontSize: model.secondaryQuestionTitleFontSize), maxLines: 1,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
