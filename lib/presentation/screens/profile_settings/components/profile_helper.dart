import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jumping_dot/jumping_dot.dart';

enum ProfilePaymentMarker {paymentMethods, pastPayments, payouts, taxes, transactionHistory}
enum ProfileNotificationMarker {tipsAndOffers, reservationPlanning, newsAndPrograms, feedback, cICOUpdates, unsubscribeFromOffers, accountActivity, listingActivity, reservationActivity, directMessages}
enum ProfileNotificationSectionMarker {insights, updates, unsubscribe, accountActivity, messages}

class ProfilePaymentSettingListModel {

  final String title;
  final IconData icon;
  final ProfilePaymentMarker marker;

  ProfilePaymentSettingListModel({
    required this.title,
    required this.icon,
    required this.marker
  });
}


List<ProfilePaymentSettingListModel> paymentSettingsList() {
  return [
    ProfilePaymentSettingListModel(title: 'Payment Methods', icon: Icons.payments_outlined, marker: ProfilePaymentMarker.paymentMethods),
    ProfilePaymentSettingListModel(title: 'Past Payments', icon: Icons.receipt_long_rounded, marker: ProfilePaymentMarker.pastPayments),
  ];
}

List<ProfilePaymentSettingListModel> payoutSettingsList() {
  return [
    ProfilePaymentSettingListModel(title: 'Payout Methods', icon: Icons.clean_hands_outlined, marker: ProfilePaymentMarker.payouts),
    // ProfilePaymentSettingListModel(title: 'Tax Info', icon: Icons.calculate_outlined, marker: ProfilePaymentMarker.taxes),
    // ProfilePaymentSettingListModel(title: 'Transaction History', icon: Icons.history_toggle_off_outlined, marker: ProfilePaymentMarker.transactionHistory),
  ];
}


class ProfileNotificationSettingModel {

  final String title;
  final String subTitle;
  final ProfileNotificationMarker marker;
  final ProfileNotificationSectionMarker sectionMarker;

  ProfileNotificationSettingModel({required this.title, required this.subTitle, required this.marker, required this.sectionMarker});

}

List<ProfileNotificationSettingModel> offersNotificationList() {

  return [
    // insights
    ProfileNotificationSettingModel(title: 'Insights and Tips', subTitle: 'on', marker: ProfileNotificationMarker.tipsAndOffers, sectionMarker: ProfileNotificationSectionMarker.insights),
    ProfileNotificationSettingModel(title: 'Planning Reservations', subTitle: 'on', marker: ProfileNotificationMarker.reservationPlanning, sectionMarker: ProfileNotificationSectionMarker.insights),

    // updates
    ProfileNotificationSettingModel(title: 'News and Programs', subTitle: 'on', marker: ProfileNotificationMarker.newsAndPrograms, sectionMarker: ProfileNotificationSectionMarker.updates),
    ProfileNotificationSettingModel(title: 'Feedback', subTitle: 'on', marker: ProfileNotificationMarker.feedback, sectionMarker: ProfileNotificationSectionMarker.updates),
    ProfileNotificationSettingModel(title: 'CICO Updates', subTitle: 'on', marker: ProfileNotificationMarker.cICOUpdates, sectionMarker: ProfileNotificationSectionMarker.updates),

    /// unsubscribe
    ProfileNotificationSettingModel(title: 'All Updates and Offers', subTitle: 'on', marker: ProfileNotificationMarker.unsubscribeFromOffers, sectionMarker: ProfileNotificationSectionMarker.unsubscribe),
  ];
}

List<ProfileNotificationSettingModel> accountNotificationsList() {
  return [
    // accountActivity
    ProfileNotificationSettingModel(title: 'Account Activity', subTitle: 'on', marker: ProfileNotificationMarker.accountActivity, sectionMarker: ProfileNotificationSectionMarker.accountActivity),
    ProfileNotificationSettingModel(title: 'Listing Activity', subTitle: 'on', marker: ProfileNotificationMarker.listingActivity, sectionMarker: ProfileNotificationSectionMarker.accountActivity),
    ProfileNotificationSettingModel(title: 'Reservation Activity', subTitle: 'on', marker: ProfileNotificationMarker.reservationActivity, sectionMarker: ProfileNotificationSectionMarker.accountActivity),

    // messages
    ProfileNotificationSettingModel(title: 'Messages', subTitle: 'on', marker: ProfileNotificationMarker.directMessages, sectionMarker: ProfileNotificationSectionMarker.messages),
  ];
}

Widget profilePaymentSettingItemWidget(DashboardModel model, ProfilePaymentSettingListModel item,{ required Function(ProfilePaymentMarker marker) didSelectItem}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkWell(
        onTap: () {
          didSelectItem(item.marker);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(item.icon, color: model.paletteColor),
                    const SizedBox(width: 18.0),
                    Text(item.title, style: TextStyle(color: model.paletteColor)),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_right_rounded, color: model.paletteColor)
            ],
          ),
        ),
      ),
      Divider(color: model.disabledTextColor)
    ],
  );
}

void presentSelectPictureOptions(BuildContext context, DashboardModel model, {required Function(ImageSource source) imageSource}) {
  showDialog(context: context, builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.all(12.0),
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        imageSource(ImageSource.camera);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text('Take a Photo', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),),
                      ),
                    ),
                    Divider(color: model.disabledTextColor),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        imageSource(ImageSource.gallery);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text('Choose From Library', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Center(child: Text('Cancel', style: TextStyle(color: model.paletteColor))),
              ),
            )
          ],
        ),
      );
    }
  );
}

void presentAddPhotoIdentification(BuildContext context, DashboardModel model, {required Function(ImageSource source) imageSource}) {
  showDialog(context: context, builder: (contexts) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(12.0),
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: model.accentColor,
              borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Icon(Icons.verified_user, size: 35, color: model.paletteColor),
                  const SizedBox(height: 15),
                  Text('Types of government-issued ID\'s', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10),
                  Text('In order for us to make sure everyone using CICO can feel safe and trusting we require everyone looking to reserve or make space availble for reservations provide one photo copy of their government-issued ID and one photo copy of you.', style: TextStyle(color: model.paletteColor)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const SizedBox(height: 35),
                            Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: model.paletteColor),
                                const SizedBox(width: 15),
                                Text('National identity Card', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: model.paletteColor),
                                const SizedBox(width: 15),
                                Text('Driver\'s Licence', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: model.paletteColor),
                                const SizedBox(width: 15),
                                Text('Passport', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          color: model.accentColor,
          borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(contexts).pop();
                      imageSource(ImageSource.gallery);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text('Upload Photo ID', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                    )
                  ),
                  Divider(color: model.disabledTextColor),
                  InkWell(
                    onTap: () {
                      Navigator.of(contexts).pop();
                      imageSource(ImageSource.camera);
                      },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text('Take A Photo', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                    )
                  ),
                  Divider(color: model.paletteColor),
                  InkWell(
                    onTap: () {
                      Navigator.of(contexts).pop();
                    },
                  child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('Cancel', style: TextStyle(color: model.paletteColor))))
                ],
              ),
            ),
          )

        ],
      ),
    );
  });
}

void presentAddSelfieIdentification(BuildContext context, DashboardModel model, {required Function(ImageSource source) imageSource}) {
  showDialog(context: context, builder: (contexts) {
      return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.all(12.0),
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: model.accentColor,
                    borderRadius: BorderRadius.circular(15)
                    ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child:  Column(
                    children: [
                      Icon(Icons.photo_camera_rounded, color: model.paletteColor, size: 35),
                      const SizedBox(height: 15),
                      Text('We ask that you provide a selfie to match your government-issued ID, this will allow us to confirm you are who you say you are.', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: model.accentColor,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.of(contexts).pop();
                            imageSource(ImageSource.gallery);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text('Take A Selfie', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                          )
                      ),
                      Divider(color: model.paletteColor),
                      InkWell(
                          onTap: () {
                            Navigator.of(contexts).pop();
                          },
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text('Cancel', style: TextStyle(color: model.paletteColor))))
                    ],
                  ),
                ),
              )
            ],
          ),
      );
  });
}

void presentRemovePhotoIdentification(BuildContext context, DashboardModel model, bool isSaving, {required Function() didSelectRemove}) {
  showDialog(context: context, builder: (contexts) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(12.0),
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: model.accentColor,
                borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text('Remove ID', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
                  const SizedBox(height: 10),
                  Text('After selecting Remove, all reservations will be cancelled and the next time you book you will need to submit a new ID', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 25),
                  if (!isSaving) Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(contexts).pop();
                        didSelectRemove();
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(color: Colors.red, width: 0.5)
                        ),
                        child: const Center(child: Text('Remove', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                      ),
                    ),
                  ),
                 if (isSaving) JumpingDots(color: model.paletteColor, numberOfDots: 3),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          InkWell(
            onTap: () {
              Navigator.of(contexts).pop();
            },
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Center(child: Text('Cancel', style: TextStyle(color: model.paletteColor))),
            ),
          ),
        ],
      ),
    );
  });
}

String getGenderTitle(BuildContext context, String title) {

  if (title.contains('Male')) {
    return AppLocalizations.of(context)!.profileAccountGenderMale;
  }
  if (title.contains('Female')) {
    return AppLocalizations.of(context)!.profileAccountGenderFemale;
  }
  if (title.contains('Non-Binary')) {
    return AppLocalizations.of(context)!.profileAccountGenderTrans;
  }
  if (title.contains('Prefer')) {
    return AppLocalizations.of(context)!.profileAccountGenderNo;
  }

  return '';
}
