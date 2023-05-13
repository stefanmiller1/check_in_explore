import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
import 'package:check_in_presentation/check_in_presentation.dart';


Widget selectedCancelOption(BuildContext context, DashboardModel model, ListK<DetailOption> detailOptionList,{required Function(ListK<DetailOption>) updateCancelOption}) {
  return Padding(
    padding: const EdgeInsets.only(left: 20.0, right: 8),
    child: Column(
      children: predefinedCancellationOptions(context).map(
              (e) => Container(
            height: 50,
            child: Row(
              children: [
                Expanded(child: Text(e.detail ?? '', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize))),
                TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                            )
                        )
                    ),
                    onPressed: () {

                      if (detailOptionList.getOrCrash().contains(
                          detailOptionList.getOrCrash().where((element) => element.uid == e.uid).isNotEmpty
                              ? detailOptionList.getOrCrash().where((element) => element.uid == e.uid).first : [])) {

                        detailOptionList.getOrCrash().remove(detailOptionList.getOrCrash().where((element) => element.uid == e.uid).isNotEmpty
                            ? detailOptionList.getOrCrash().where((element) => element.uid == e.uid).first : []);

                      }

                      updateCancelOption(detailOptionList);


                    },
                    child: Icon((detailOptionList.getOrCrash().contains(
                        detailOptionList.getOrCrash().where((element) => element.uid == e.uid).isNotEmpty
                            ? detailOptionList.getOrCrash().where((element) => element.uid == e.uid).first : [])) ? Icons.cancel_outlined : Icons.cancel, size: 50, color: model.paletteColor,)),
                SizedBox(width: 8),
                Container(
                  child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                              )
                          )
                      ),
                      onPressed: () {
                        if (!detailOptionList.getOrCrash().contains(
                            detailOptionList.getOrCrash().where((element) => element.uid == e.uid).isNotEmpty
                                ? detailOptionList.getOrCrash().where((element) => element.uid == e.uid).first : [])) {

                          detailOptionList.getOrCrash().add(DetailOption(uid: e.uid));

                        }

                        updateCancelOption(detailOptionList);

                      },
                      child: Icon((detailOptionList.getOrCrash().contains(
                          detailOptionList.getOrCrash().where((element) => element.uid == e.uid).isNotEmpty
                              ? detailOptionList.getOrCrash().where((element) => element.uid == e.uid).first : [])) ?  Icons.check_circle : Icons.check_circle_outlined, size: 50, color: model.paletteColor)),
                )
              ],
            ),
          )
      ).toList(),
    ),
  );
}