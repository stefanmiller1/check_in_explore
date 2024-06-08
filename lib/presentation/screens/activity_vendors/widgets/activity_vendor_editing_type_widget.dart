import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';

class ActivityVendorEditingTypePopOver extends StatefulWidget {

  final DashboardModel model;
  final List<AvailabilityStatus> editingOptions;
  final AvailabilityStatus? editingMode;
  final Function(AvailabilityStatus?) didSelectSave;

  const ActivityVendorEditingTypePopOver({super.key, required this.model, required this.didSelectSave, this.editingMode, required this.editingOptions});

  @override
  State<ActivityVendorEditingTypePopOver> createState() => _ActivityVendorEditingTypePopOverState();
}

class _ActivityVendorEditingTypePopOverState extends State<ActivityVendorEditingTypePopOver> {

  late AvailabilityStatus? currentEditingMode = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: widget.model.paletteColor,
        title: Text(
          'Editing Mode', style: TextStyle(color: widget.model.accentColor),
        ),
        centerTitle: true,
        leadingWidth: 200,
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.cancel, color: widget.model.accentColor, size: 40,),
              tooltip: 'Cancel',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 8),
            Center(
              child: InkWell(
                onTap: () {
                  if (currentEditingMode != null) {
                    widget.didSelectSave(null);
                    Navigator.of(context).pop();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(' Clear ', style: TextStyle(color: (currentEditingMode != null) ? widget.model.accentColor : widget.model.accentColor.withOpacity(0.4), fontSize: widget.model.secondaryQuestionTitleFontSize),),
                ),
              ),
            ),
          ],
        ),
        actions: [
          const SizedBox(width: 8),
          Center(
            child: Container(
              decoration: (currentEditingMode != null) ? BoxDecoration(
                  color: widget.model.accentColor,
                  borderRadius: BorderRadius.circular(20)
              ) : null,
              child: InkWell(
                onTap: () {
                  if (currentEditingMode == null) {
                      widget.didSelectSave(null);
                    } else {
                      widget.didSelectSave(currentEditingMode!);
                      Navigator.of(context).pop();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text('Save', style: TextStyle(color: (currentEditingMode != null) ? widget.model.paletteColor : widget.model.accentColor.withOpacity(0.4), fontSize: widget.model.secondaryQuestionTitleFontSize),),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  
              ],
            ),
          ),
        ),
      ),
    );
  }
}