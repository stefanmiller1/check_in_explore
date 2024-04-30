import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:intl/intl.dart';

Widget getVendorFormListTile(BuildContext context, DashboardModel model, int? index, VendorMerchantForm form, {required Function(VendorMerchantForm) didSelectEditCreateForm}) {
  final Widget desktopTrailing = SizedBox(
    height: 50,
    width: 230,
    child: Row(
      children: [
        TextButton(
          onPressed: () {
            // Edit form
            didSelectEditCreateForm(form);
          },
          child: Text('Edit', style: TextStyle(color:  model.paletteColor)),
        ),
        const SizedBox(width: 4),
        if (form.formStatus == FormStatus.published) TextButton(
          onPressed: () {
            // Manage form

          },
          child: Text('Manage', style: TextStyle(color:  model.paletteColor)),
        ),
        const SizedBox(width: 4),
        Container(
            decoration: BoxDecoration(
                color: getStatusColor(model, form.formStatus).withOpacity(0.15),
                borderRadius: BorderRadius.circular(30)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(form.formStatus.name, style: TextStyle(color: getStatusColor(model, form.formStatus))),
            )
        )
      ],
    ),
  );


  return SlideInTransitionWidget(
    durationTime: 300 * (index ?? 1),
      offset: Offset(0, 0.25),
      transitionWidget: ListTile(
        onTap: () {
          didSelectEditCreateForm(form);
        },
        leading: Icon(Icons.description, color: model.paletteColor),
        title: Text(form.formTitle ?? 'Vendor Form', style: TextStyle(color: model.paletteColor)),
        subtitle: Text('Last opened at: ${DateFormat.MMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(form.lastOpenedAt))}', style: TextStyle(color: model.disabledTextColor)),
          trailing: (Responsive.isDesktop(context)) ? desktopTrailing : Container(
          height: 50,
          width: 130,
          child: Row(
          children: [
              c
                const SizedBox(width: 4),
                IconButton(
                icon: Icon(Icons.more_vert, color: model.paletteColor),
                onPressed: () {
          // Show more actions
               },
              ),
            ],
          ),
        ),
      ),
    );

}

Color getStatusColor(DashboardModel model, FormStatus status) {
  switch (status) {
    case FormStatus.published:
      return Colors.green;
    case FormStatus.closed:
      return Colors.red;
    case FormStatus.inProgress:
      return model.disabledTextColor;
  }
}
