import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';

class ActivityVendorConfirmationPopOver extends StatelessWidget {

  final DashboardModel model;
  final int numberOfConfirmed;
  final Function() didSelectSave;

  const ActivityVendorConfirmationPopOver({super.key, required this.model, required this.didSelectSave, required this.numberOfConfirmed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: model.paletteColor,
        title: Text(
          'Confirmations', style: TextStyle(color: model.accentColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.cancel, color: model.accentColor, size: 40,),
          tooltip: 'Cancel',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_rounded, size: 80),
                    Text((numberOfConfirmed != 1) ? 'Send ${numberOfConfirmed} Confirmations Out' : 'Send 1 Confirmation Out', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                    Text('applicants will be filtered by what you select once your\'re done.'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                    color: model.paletteColor,
                    borderRadius: BorderRadius.all(Radius.circular(30.5))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      didSelectSave();
                    },
                    child: Text('   Send   ', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize))),
                ),
              )
          /// list tile of what they will be reminded of - show disclaimers on confirmation?
            ],
          ),
        ),
      ),
    );
  }

}