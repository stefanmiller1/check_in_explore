import 'dart:collection';
import 'dart:ui';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/form/merchant_vendor/custom_availability/mv_custom_availability.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_facade/check_in_facade.dart';
import '../../web_screens/focused_main_container_widgets/activity_vendor_form_manage_widget/actvity_vendor_form_manager_helper.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:intl/intl.dart';
import 'package:check_in_domain/domain/misc/attendee_services/form/merchant_vendor/booth_payments/mv_booth_payments.dart';
import 'package:check_in_domain/domain/misc/filter_services/vendor_contact_filter_model.dart';
import 'package:badges/badges.dart' as badges;
import 'package:dartz/dartz.dart' as dart;
import 'package:check_in_domain/domain/misc/filter_services/vendor_contact_filter_model.dart';
import 'activity_vendors_results_helper.dart';
import 'widgets/helpers.dart';
import 'package:check_in_application/auth/update_services/listing_update_create_services/attendee_update_create_services/listing_attendee_form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ActivityVendorApplicationsResultMain extends StatefulWidget {

  final DashboardModel model;
  final VendorMerchantForm selectedForm;
  final ReservationItem reservationItem;
  final UserProfileModel activityOwnerProfile;
  final ActivityManagerForm activityManagerForm;

  const ActivityVendorApplicationsResultMain({super.key, required this.model, required this.selectedForm, required this.reservationItem, required this.activityOwnerProfile, required this.activityManagerForm});

  @override
  State<ActivityVendorApplicationsResultMain> createState() => _ActivityVendorApplicationsResultMainState();
}

class _ActivityVendorApplicationsResultMainState extends State<ActivityVendorApplicationsResultMain> {

  late TextEditingController _textController;
  List<VendorContactDetail> selectedVendors = [];
  late String querySearch = '';
  late String? currentEditingMode = null;
  late VendorContactFilterModel? selectedFilterItems = null;

  final widthResponsive = 1340;

  @override
  void initState() {
    selectedVendors = [];
    _textController = TextEditingController();
    super.initState();
  }


  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: widget.model.webBackgroundColor
          ),
          child: BlocProvider(create: (_) => getIt<AttendeeFormBloc>()..add(AttendeeFormEvent.initializeAttendeeForm(
              dart.optionOf(AttendeeItem.empty()),
              dart.optionOf(widget.reservationItem),
              dart.optionOf(widget.activityManagerForm),
              dart.optionOf(widget.activityOwnerProfile))
          ),
              child: BlocConsumer<AttendeeFormBloc, AttendeeFormState>(
                  listenWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.attendeeItem != c.attendeeItem,
                  listener: (context, state) {

                    state.authRefundFailureOrSuccessOption.fold(
                            () => {},
                            (either) => either.fold(
                                (failure) {
                              final snackBar = SnackBar(
                                  backgroundColor: Colors.red.shade100,
                                  content: failure.maybeMap(
                                    paymentServerError: (e) => Text(e.failedValue ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: Colors.red)),
                                    orElse: () => Text('A Problem Happened', style: TextStyle(color: Colors.red)),
                                  ));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                                (_) => null
                        )
                    );

                    state.authVendorPaymentFailureOrSuccessOption.fold(
                            () => {},
                            (either) => either.fold(
                                (failure) {
                              final snackBar = SnackBar(
                                  backgroundColor: Colors.red.shade100,
                                  content: failure.maybeMap(
                                    paymentServerError: (e) => Text(e.failedValue ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: Colors.red)),
                                    orElse: () => Text('A Problem Happened', style: TextStyle(color: Colors.red)),
                                  ));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                          (_) => null
                        )
                    );


                    state.authFailureOrSuccessOption.fold(
                            () {},
                            (either) => either.fold((failure) {
                          final snackBar = SnackBar(
                              backgroundColor: widget.model.webBackgroundColor,
                              content: failure.maybeMap(
                                attendeeWaitingForPaymentConfirmation: (e) => Text('waiting for payment confirmation', style: TextStyle(color: widget.model.disabledTextColor)),
                                attendeeServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                                attendeePermissionDenied: (e) => Text('Sorry, you don\'t have permission to do that', style: TextStyle(color: widget.model.disabledTextColor)),
                                orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        }, (_) {

                              setState(() {
                                ActivityVendorHelperCore.isLoading = true;
                              });

                              Future.delayed(const Duration(seconds: 2), () {
                                setState(() {
                                  ActivityVendorHelperCore.isLoading = false;
                                });
                              });

                          final snackBar = SnackBar(
                              elevation: 4,
                              backgroundColor: widget.model.paletteColor,
                              content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        }));
                  },
                  buildWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.attendeeItem != c.attendeeItem,
                  builder: (context, state) {
                    if (state.isSubmitting == true) {
                      selectedVendors.clear();
                      return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
                    }
                    return BlocProvider(create: (context) => getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.vendor.toString(), widget.reservationItem.reservationId.getOrCrash())),
                        child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
                            builder: (context, state) {
                              return state.maybeMap(
                                  attLoadInProgress: (_) => getLoadingForOverviewFooter(context),
                                  /// earnings from all vendors
                                  loadAllAttendanceSuccess: (allAttendees) {
                                    if (ActivityVendorHelperCore.isLoading == true) {
                                      selectedVendors.clear();
                                      return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
                                    }
                                    // getAllVendorApplicationDetails(allAttendees.item);
                                    return getAttendeeUserProfiles(context, allAttendees.item.where((element) => element.vendorForm?.formId == widget.selectedForm.formId).toList());
                                  },
                                  /// no earnings yet.
                                  orElse: () {


                                    if (ActivityVendorHelperCore.isLoading == true) {
                                      selectedVendors.clear();
                                      return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
                                    }

                                    // retrieveVendorList(placeholder);
                                    // getAllVendorApplicationDetails(placeholder);
                                    return  getAttendeeUserProfiles(context, []);
                      }
                    );
                  }
                )
              );
            }
          )
        )
      ),
    );
  }

  Widget getAttendeeUserProfiles(BuildContext context, List<AttendeeItem> attendees) {
    return BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchAllProfileFromUserIdsStarted(attendees.map((e) => e.attendeeOwnerId.getOrCrash()).toList())),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
          builder: (context, authState) {
            return authState.maybeMap(
                loadAllProfileFromIdsSuccess: (items) {
                  return getAttendeeVendorMerchProfiles(context, attendees, items.profiles);
                },
                orElse: () => getAttendeeVendorMerchProfiles(context, attendees, [])
          );
        }
      ),
    );
  }

  Widget getAttendeeVendorMerchProfiles(BuildContext context, List<AttendeeItem> attendees, List<UserProfileModel> userProfile) {
    return BlocProvider(create: (context) => getIt<VendorMerchProfileWatcherBloc>()..add(VendorMerchProfileWatcherEvent.watchAllEventMerchProfileFromIds(attendees.map((e) => (e.eventMerchantVendorProfile != null) ? e.eventMerchantVendorProfile!.getOrCrash() : '').toList())),
      child: BlocBuilder<VendorMerchProfileWatcherBloc, VendorMerchProfileWatcherState>(
          builder: (context, authState) {
            return authState.maybeMap(
                loadAllMerchVendorFromIdsSuccess: (items) {
                  return getSearchedMainContainer(context, attendees, userProfile, items.items);
                },
             orElse: () => getSearchedMainContainer(context, attendees, userProfile, [])
          );
        }
      ),
    );
  }

  Widget getSearchedMainContainer(BuildContext context, List<AttendeeItem> attendees, List<UserProfileModel> userProfiles, List<EventMerchantVendorProfile> vendorProfiles) {

    Map<AttendeeItem, List<VendorContactDetail>> queriedAttendees = HashMap<AttendeeItem, List<VendorContactDetail>>();

        for (AttendeeItem attendee in attendees.where((element) =>  filterProfileName(userProfiles, element.attendeeOwnerId, querySearch) || filterProfileLastName(userProfiles, element.attendeeOwnerId, querySearch) || filterProfileFirstLastName(userProfiles, element.attendeeOwnerId, querySearch) || filterByVendorName(vendorProfiles, element.attendeeOwnerId, querySearch))) {

          final EventMerchantVendorProfile? vendorProfile = vendorProfiles.where((element) => element.profileOwner == attendee.attendeeOwnerId).isNotEmpty ? vendorProfiles.where((element) => element.profileOwner == attendee.attendeeOwnerId).first : null;
          final UserProfileModel? userProfile = userProfiles.where((element) => element.userId == attendee.attendeeOwnerId).isNotEmpty ? userProfiles.where((element) => element.userId == attendee.attendeeOwnerId).first : null;

        if (vendorProfile != null && userProfile != null) {
            for (MVBoothPayments booth in attendee.vendorForm?.boothPaymentOptions?.where((element) => filterByAvailability(element, selectedFilterItems) == true)
                .where((element) => filterByBoothItem(element, selectedFilterItems) == true)
                .where((element) => filterByByBoothStatus(element, selectedFilterItems) == true)
                .where((element) => filterByVendorType(vendorProfile, selectedFilterItems) == true).toList() ?? [MVBoothPayments(uid: attendee.attendeeOwnerId, boothTitle: 'Booth')]) {
              // if (queriedAttendees.entries.where((element) => element.key.attendeeOwnerId == attendee.attendeeOwnerId).isNotEmpty && queriedAttendees.entries.where((element) => element.key.attendeeOwnerId == attendee.attendeeOwnerId).first.value.map((e) => e.boothItem.uid).contains(booth.uid) == false) {
              queriedAttendees.putIfAbsent(attendee, () => []).add(VendorContactDetail(
                  vendorProfile: vendorProfile,
                  uid: (booth.selectedId != null) ? booth.selectedId! : UniqueId.fromUniqueString('${booth.uid.getOrCrash()} ${attendee.attendeeOwnerId.getOrCrash()}'),
                  userProfile: userProfile,
                  attendee: attendee,
                  boothItem: booth,
            )
          );
        }
      }
    }

    return getMainContainer(context, queriedAttendees);
  }


  Widget getMainContainer(BuildContext context, Map<AttendeeItem, List<VendorContactDetail>> attendees) {

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              /// filter...what you are filtering by...show vendor form with available and booth types (multi select)....filter by status (confirmed, denied..) vendor type,

              SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
                    child: Row(
                      children: [

                        Flexible(
                          child: Center(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 900),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  const SizedBox(height: 180),


                                         // for (var entry in getAllVendorApplicationDetails(placeholder).entries.toList(growable: false))

                                          /// option to export to cvs. format list
                                          /// current earnings (filter of all confirmed)
                                          /// potential additional earnings (filter of all requested)
                                          /// filter by search
                                          /// filter by...date or booth type...vendor type
                                          /// select all

                                          /// ordered by latest to submit?

                                          /// confirmed
                                         Column(
                                           children: attendees.entries.toList(growable: true).map((entry) {

                                             final EventMerchantVendorProfile? profile = entry.value.where((element) => element.attendee.attendeeOwnerId == entry.key.attendeeOwnerId).isNotEmpty ? entry.value.where((element) => element.attendee.attendeeOwnerId == entry.key.attendeeOwnerId).first.vendorProfile : null;
                                             final UserProfileModel? userProfile = entry.value.where((element) => element.attendee.attendeeOwnerId == entry.key.attendeeOwnerId).isNotEmpty ? entry.value.where((element) => element.attendee.attendeeOwnerId == entry.key.attendeeOwnerId).first.userProfile : null;

                                            return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    if (MediaQuery.of(context).size.width >= widthResponsive) Container(
                                                        height: 80,
                                                        decoration: BoxDecoration(
                                                          color: widget.model.accentColor,
                                                          borderRadius: BorderRadius.circular(18),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [

                                                             Padding(
                                                              padding: const EdgeInsets.only(left: 8.0),
                                                              child: Row(
                                                                children: [
                                                                  if (MediaQuery.of(context).size.width <= widthResponsive && profile != null) Row(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            backgroundImage: Image.network(profile.uriImage?.uriPath ?? '').image,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(width: 8),
                                                                      Text(profile.brandName.getOrCrash(), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize))
                                                                    ],
                                                                  ),
                                                                  if (userProfile != null) SizedBox(
                                                                    height: 67,
                                                                    width: 340,
                                                                    child: ListTile(
                                                                      onTap: () {
                                                                        // selectedItem(user);
                                                                      },
                                                                      leading: Container(
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.transparent,
                                                                            borderRadius: BorderRadius.circular(30),
                                                                          ),
                                                                          child: Padding(
                                                                              padding: const EdgeInsets.all(1.75),
                                                                              child: CircleAvatar(backgroundImage: userProfile.profileImage?.image ?? Image.asset('assets/profile-avatar.png').image))),
                                                                      title: Text('${userProfile.legalName.getOrCrash()} ${userProfile.legalSurname.value.fold((l) => '', (r) => r)}', style: TextStyle(color: widget.model.paletteColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                                                                      subtitle: (entry.key.vendorForm?.lastOpenedAt != null) ? Text('Submitted: ${DateFormat.MMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(entry.key.vendorForm!.lastOpenedAt))}', style: TextStyle(color: widget.model.disabledTextColor)) : null,
                                                                    )
                                                                  ),
                                                                  const SizedBox(width: 8),
                                                                  if (entry.key.vendorForm != null && isDocumentsOptionValid(entry.key.vendorForm!)) Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Container(
                                                                          decoration: BoxDecoration(
                                                                            color: widget.model.disabledTextColor.withOpacity(0.38),
                                                                            borderRadius: BorderRadius.circular(30),
                                                                          ),
                                                                          child: InkWell(
                                                                            onTap: () {
                                                                              showSelectedDocumentButton(context, widget.model, getDocumentsList(entry.key.vendorForm!)?.toList() ?? []);
                                                                            },
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text('Uploaded Documents', style: TextStyle(color: widget.model.paletteColor)),
                                                                          ),
                                                                        )
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            selectAllStatusHeader(entry.value, entry.key)
                                                        ],
                                                      )
                                                    ),
                                                    if (MediaQuery.of(context).size.width <= widthResponsive) Container(
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                        color: widget.model.accentColor,
                                                        borderRadius: BorderRadius.circular(18),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            if (userProfile != null && profile != null) Row(
                                                              children: [
                                                                CircleAvatar(
                                                                  backgroundImage: Image.network(profile.uriImage?.uriPath ?? '').image,
                                                                ),
                                                                SizedBox(
                                                                    height: 67,
                                                                    width: 200,
                                                                    child: ListTile(
                                                                      onTap: () {
                                                                        // selectedItem(user);
                                                                      },
                                                                      leading: Container(
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.transparent,
                                                                            borderRadius: BorderRadius.circular(30),
                                                                          ),
                                                                          child: Padding(
                                                                              padding: const EdgeInsets.all(1.75),
                                                                              child: CircleAvatar(backgroundImage: userProfile.profileImage?.image ?? Image.asset('assets/profile-avatar.png').image))),
                                                                      title: Text('${userProfile.legalName.getOrCrash()} ${userProfile.legalSurname.value.fold((l) => '', (r) => r)}', style: TextStyle(color: widget.model.paletteColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                                                                      subtitle: Text(profile.brandName.getOrCrash(), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1,)
                                                                    )
                                                                ),
                                                              ],
                                                            ),
                                                            selectAllStatusHeader(entry.value, entry.key)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        /// vendor profile
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            /// show documents uploaded
                                                            /// show when applied.
                                                            if (MediaQuery.of(context).size.width >= widthResponsive && profile != null) Container(
                                                              width: 340,
                                                              child: getActivityVendorProfileTile(
                                                                  widget.model,
                                                                  profile,
                                                                  false,
                                                                  didSelectAttendee: (attendee) {
                                                                    setState(() {

                                                                    });
                                                                  }),
                                                                ),

                                                          ],
                                                        ),
                                                        ///  divider horizontal


                                                        const SizedBox(width: 8),
                                                        if (entry.value.isNotEmpty == true) Expanded(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: entry.value.toList().asMap().map(
                                                                    (j, vendorDetail) {

                                                                  late bool isSelected = selectedVendors.map((e) => e.uid).contains(vendorDetail.uid);

                                                                  /// get date for selected booth..if null booth applies to all dates
                                                                  final MCCustomAvailability? availability = (vendorDetail.boothItem.availabilityId != null && entry.key.vendorForm?.availableTimeSlots?.where((element) => element.uid == vendorDetail.boothItem.availabilityId).isNotEmpty == true) ? entry.key.vendorForm?.availableTimeSlots?.firstWhere((element) => element.uid == vendorDetail.boothItem.availabilityId) : null;

                                                                  return MapEntry(j, Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: widget.model.accentColor,
                                                                        borderRadius: BorderRadius.circular(18),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: getRowForBoothOption(
                                                                          context,
                                                                          widget.model,
                                                                          widget.activityManagerForm.rulesService.currency,
                                                                          vendorDetail,
                                                                          j,
                                                                          availability,
                                                                          isSelected,
                                                                          vendorDetail.boothItem.status?.name == currentEditingMode,
                                                                          didSelectEdit: () {
                                                                            setState(() {
                                                                              if (isSelected) {
                                                                                selectedVendors.removeWhere((element) => element.uid == vendorDetail.uid);
                                                                                } else {
                                                                                selectedVendors.add(vendorDetail);
                                                                                }
                                                                              });
                                                                            }
                                                                          )
                                                                        )
                                                                      ),
                                                                    )
                                                                  );
                                                                }).values.toList() ?? [],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  const SizedBox(height: 8),
                                               ],
                                             );
                                            }
                                           ).toList(),
                                         )


                                  /// requested

                                  /// in progress

                                  /// waiting list

                                  /// denied


                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
              ),

              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 185,
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (Responsive.isDesktop(context)) ? Column(
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    exportButton(attendees.values.toList()),
                                    const SizedBox(height: 8),
                                    filterButton(),
                                    dropDownOptionsButton(context, attendees.values.toList()),
                                  ],
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    sendRejectionButton(context, attendees.values.toList()),
                                    const SizedBox(height: 8),
                                    sendConfirmationButton(context, attendees.values.toList()),
                                    const SizedBox(height: 8),
                                    selectAllButton(attendees.values.toList())
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ) : Column(
                          children: [
                            const SizedBox(height: 4),

                            Row(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                dropDownOptionsButton(context, attendees.values.toList()),
                                // exportButton(attendees.values.toList()),
                                filterButton()
                              ],
                            ),
                            const SizedBox(height: 62)  ,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                sendRejectionButton(context, attendees.values.toList()),
                                const SizedBox(width: 8),
                                sendConfirmationButton(context, attendees.values.toList()),
                                const SizedBox(width: 8),
                                selectAllButton(attendees.values.toList())
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                  top: 25,
                  child: Container(
                    width: 330,
                    child: Column(
                      children: [
                        Text('Vendor Form Details', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        /// search controller
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              controller: _textController,
                              style: TextStyle(color: widget.model.paletteColor),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.zoom_out, color: widget.model.disabledTextColor),
                                hintText: 'Search a Name or Vendor',
                                errorStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: widget.model.disabledTextColor
                                ),
                                filled: true,
                                contentPadding: const EdgeInsets.only(bottom: 15, top: 15),
                                fillColor: widget.model.accentColor,
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                      color: widget.model.paletteColor,
                                      width: 0
                                  ),
                                ),
                                focusedBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent,
                                      width: 0
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: widget.model.webBackgroundColor,
                                    width: 0,
                                  ),
                                ),
                              ),
                              autocorrect: true,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                              onChanged: (query) {
                              setState(() {
                                querySearch = query.toLowerCase();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
              Positioned(
                bottom: 15,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.11),
                          spreadRadius: 1,
                          blurRadius: 15,
                          offset: Offset(0, 2)
                      )
                    ],
                    color: widget.model.accentColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${attendees.length} Applicants', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: VerticalDivider(color: widget.model.paletteColor),
                        ),
                        Text('${getNumberOfConfirmedSlots(attendees.values.toList().map((e) => e.map((e) => e.boothItem).toList()).toList())} Confirmed'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: VerticalDivider(color: widget.model.paletteColor),
                        ),
                        Text('${completeTotalPriceWithCurrency(getTotalPotentialEarnings(attendees.values.toList().map((e) => e.map((e) => e.boothItem).toList()).toList()).toDouble(), widget.activityManagerForm.rulesService.currency)} Earnings'),
                        if (selectedVendors.isNotEmpty) Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: VerticalDivider(color: widget.model.paletteColor),
                        ),
                        if (selectedVendors.isNotEmpty) Text('${completeTotalPriceWithCurrency(attendeeVendorFee(selectedVendors.map((e) => e.boothItem).toList()).toDouble(), widget.activityManagerForm.rulesService.currency)} Potential Earnings', style: TextStyle(color: widget.model.paletteColor)),
                    ],
                  ),
                ),
              ),
            )
          ],
        );

  }
  //
  // Widget boothStatusButton(AvailabilityStatus? status) {
  //   switch (status) {
  //     case AvailabilityStatus.refunded:
  //       return Container(
  //         height: 30,
  //         decoration: BoxDecoration(
  //           color: Colors.red.withOpacity(0.24),
  //           borderRadius: BorderRadius.circular(50),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //           child: Center(child: Text('Refunded', style: TextStyle(color: Colors.red,))),
  //         ),
  //       );
  //     case AvailabilityStatus.cancelled:
  //       return Container(
  //         height: 30,
  //         decoration: BoxDecoration(
  //           border: Border.all(color: Colors.red),
  //           borderRadius: BorderRadius.circular(50),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //           child: Center(child: Text('Cancelled', style: TextStyle(color: Colors.red,))),
  //         ),
  //       );
  //     case AvailabilityStatus.denied:
  //       return Container(
  //         height: 30,
  //         decoration: BoxDecoration(
  //           color: Colors.red.withOpacity(0.24),
  //           borderRadius: BorderRadius.circular(50),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //           child: Center(child: Text('Denied', style: TextStyle(color: Colors.red,))),
  //         ),
  //       );
  //     case AvailabilityStatus.confirmed:
  //       return Container(
  //         height: 30,
  //         decoration: BoxDecoration(
  //           color: Colors.lightGreen.withOpacity(0.24),
  //           borderRadius: BorderRadius.circular(50),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //           child: Center(child: Text('Confirmed', style: TextStyle(color: Colors.lightGreen,),)),
  //         ),
  //       );
  //     case AvailabilityStatus.requested:
  //       return Container(
  //         height: 30,
  //         decoration: BoxDecoration(
  //           color: widget.model.webBackgroundColor,
  //           borderRadius: BorderRadius.circular(50),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //           child: Center(child: Text('Requested', style: TextStyle(color: widget.model.disabledTextColor),)),
  //         ),
  //       );
  //     default:
  //
  //   }
  //   return Container();
  // }

  Widget exportButton(List<List<VendorContactDetail>> vendors) {
    return Container(
      decoration: BoxDecoration(
        color: widget.model.accentColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: InkWell(
        onTap: () {
          final List<VendorContactDetail> vendorAppList = [];
          for (List<VendorContactDetail> vendorList in vendors.toList()) {
            for (VendorContactDetail vendor in vendorList) {
              vendorAppList.add(vendor);
            }
          }

          /// based on sorted
          exportToExcel(vendorAppList, widget.selectedForm.availableTimeSlots, widget.selectedForm.formTitle ?? 'My Form');
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.upload_outlined, color: widget.model.paletteColor),
              const SizedBox(width: 8),
              Text(' Export ', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: (Responsive.isDesktop(context)) ? widget.model.secondaryQuestionTitleFontSize : null)),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterButton() {
    return badges.Badge(
      showBadge: selectedFilterItems != null && getNumberOfFilterItems(selectedFilterItems) != 0,
      badgeStyle: badges.BadgeStyle(badgeColor: widget.model.paletteColor),
      badgeAnimation: const badges.BadgeAnimation.scale(animationDuration: Duration(milliseconds: 700)),
      badgeContent: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(getNumberOfFilterItems(selectedFilterItems).toString(), style: TextStyle(color: widget.model.accentColor)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: widget.model.accentColor,
          border: (getNumberOfFilterItems(selectedFilterItems) != 0) ? Border.all(color: widget.model.paletteColor) : null,
          borderRadius: BorderRadius.circular(40),
        ),
        child: InkWell(
          onTap: () {
            showFilterOptions(
                context,
                widget.model,
                widget.activityManagerForm,
                selectedFilterItems,
                widget.selectedForm,
                didSelectFilter: (filter) {
                  setState(() {
                    selectedFilterItems = filter;
                  });
                }
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(CupertinoIcons.equal_circle, color: widget.model.paletteColor),
                const SizedBox(width: 8),
                Text(' Filter ', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: (Responsive.isDesktop(context)) ? widget.model.secondaryQuestionTitleFontSize : null)),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget sendRejectionButton(BuildContext context, List<List<VendorContactDetail>> vendors) {
    switch (currentEditingMode) {
      case 'confirmed':
        return Container(
          decoration: BoxDecoration(
            border: (selectedVendors.isNotEmpty) ? Border.all(color: Colors.red) : null,
            borderRadius: BorderRadius.circular(40),
          ),
          child: InkWell(
            onTap: () {
              final List<VendorContactDetail> selectedInView = [];

              for (List<VendorContactDetail> vendors in vendors) {
                /// filter based on edit mode
                for (VendorContactDetail vendor in vendors.where((element) => element.boothItem.status == AvailabilityStatus.confirmed)) {
                  if (selectedVendors.map((e) => e.uid).contains(vendor.uid)) {
                    selectedInView.add(vendor);
                  }
                }
              }

              showRejectionPopOver(
                  context,
                  widget.model,
                  widget.activityManagerForm.rulesService.currency,
                  selectedInView,
                  didSelectReject: () {
                    context.read<AttendeeFormBloc>().add(AttendeeFormEvent.didRefundAttendeesGroup(selectedInView));
                    selectedVendors.clear();
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Send Refund', style: TextStyle(color: (selectedVendors.isNotEmpty) ? Colors.red : widget.model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: (Responsive.isDesktop(context)) ? widget.model.secondaryQuestionTitleFontSize : null)),
            ),
          ),
        );
      case 'requested':
        return Container(
          decoration: BoxDecoration(
            border: (selectedVendors.isNotEmpty) ? Border.all(color: Colors.red) : null,
            borderRadius: BorderRadius.circular(40),
          ),
          child: InkWell(
            onTap: () {
              final List<VendorContactDetail> selectedInView = [];

              for (List<VendorContactDetail> vendors in vendors) {
                /// filter based on edit mode
                for (VendorContactDetail vendor in vendors.where((element) => element.boothItem.status == AvailabilityStatus.requested)) {
                  if (selectedVendors.map((e) => e.uid).contains(vendor.uid)) {
                    selectedInView.add(vendor);
                  }
                }
              }

              showRejectionPopOver(
                  context,
                  widget.model,
                  widget.activityManagerForm.rulesService.currency,
                  selectedInView,
                  didSelectReject: () {
                    context.read<AttendeeFormBloc>().add(AttendeeFormEvent.didRejectAttendeesGroup(selectedInView));
                    selectedVendors.clear();
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Send Rejection', style: TextStyle(color: (selectedVendors.isNotEmpty) ? Colors.red : widget.model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: (Responsive.isDesktop(context)) ? widget.model.secondaryQuestionTitleFontSize : null)),
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Widget sendConfirmationButton(BuildContext context, List<List<VendorContactDetail>> vendors) {
    switch(currentEditingMode) {
      case 'requested':
        return Container(
          decoration: BoxDecoration(
            color: (selectedVendors.isNotEmpty) ? widget.model.paletteColor : widget.model.accentColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: InkWell(
            onTap: () {

              final List<VendorContactDetail> selectedInView = [];

              for (List<VendorContactDetail> vendors in vendors) {
                for (VendorContactDetail vendor in vendors) {
                  if (selectedVendors.map((e) => e.uid).contains(vendor.uid)) {
                    selectedInView.add(vendor);
                  }
                }
              }

              showConfirmationPopOver(
                  context,
                  widget.model,
                  selectedInView.map((e) => e.attendee.attendeeOwnerId).toSet().toList().length,
                  didSelectSave: () {
                    context.read<AttendeeFormBloc>().add(AttendeeFormEvent.didConfirmAttendeesGroup(selectedInView));
                    selectedVendors.clear();
                  }
              );

            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Send Confirmation', style: TextStyle(color: (selectedVendors.isNotEmpty) ? widget.model.accentColor : widget.model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: (Responsive.isDesktop(context)) ? widget.model.secondaryQuestionTitleFontSize : null)),
            ),
          ),
        );
      default:
        return Container();
    }

  }

  Widget selectAllButton(List<List<VendorContactDetail>> vendors) {
      if (currentEditingMode == null) {
        return Container();
      }
        return Container(
          decoration: BoxDecoration(
            color: widget.model.accentColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                for (List<VendorContactDetail> vendors in vendors) {
                  for (VendorContactDetail vendor in vendors.where((element) => element.boothItem.status?.name == currentEditingMode)) {
                    if (selectedVendors.map((e) => e.uid).contains(vendor.uid) == false) {
                      selectedVendors.add(vendor);
                    } else {
                      // selectedVendors.removeWhere((element) => element.uid == vendor.uid);
                    }
                  }
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Select All", style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: (Responsive.isDesktop(context)) ? widget.model.secondaryQuestionTitleFontSize : null)),
            ),
          ),
        );

  }


  Widget selectAllStatusHeader(List<VendorContactDetail> booths, AttendeeItem currentAttendee) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: booths.map((e) => e.boothItem.status?.name).contains(currentEditingMode),
            child: InkWell(
                onTap: () {
                  setState(() {
                    for (VendorContactDetail vendor in booths) {
                      if (selectedVendors.map((e) => e.uid).contains(vendor.uid) == false) {
                        selectedVendors.add(vendor);
                      } else {
                        selectedVendors.removeWhere((element) => element.uid == vendor.uid);
                      }
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.model.disabledTextColor.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(' select All '),
                ),
              )
            ),
          ),
          // Text('Applied At: ${DateFormat.MMMd().add_jm().format(e.dateCreated)}', style: TextStyle(color: widget.model.disabledTextColor)),
          Text('Status: ${currentAttendee.contactStatus?.name ?? 'Requested'}', style: TextStyle(color: widget.model.disabledTextColor)),
        ],
      ),
    );
  }

  Widget dropDownOptionsButton(BuildContext context, List<List<VendorContactDetail>> booths) {

    final List<String> allDropDrownOptions = [];

    if (Responsive.isDesktop(context) == false) {
      allDropDrownOptions.add('Export');
    }

    for (List<VendorContactDetail> vendors in booths) {
      if (allDropDrownOptions.contains(AvailabilityStatus.confirmed.name) == false && vendors.where((element) => element.boothItem.status == AvailabilityStatus.confirmed).isNotEmpty == true) {
        allDropDrownOptions.add(AvailabilityStatus.confirmed.name);
      }

      if (allDropDrownOptions.contains(AvailabilityStatus.requested.name) == false && vendors.where((element) => element.boothItem.status == AvailabilityStatus.requested).isNotEmpty == true) {
        allDropDrownOptions.add(AvailabilityStatus.requested.name);
      }
    }


    return Container(
      height: 55,
      constraints: (Responsive.isDesktop(context) == false) ? const BoxConstraints(
        maxWidth: 90,
      ) : null,
      child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isDense: true,
            customButton: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: (currentEditingMode == null) ? widget.model.accentColor : widget.model.paletteColor,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.pencil_circle, color: (currentEditingMode != null) ? widget.model.accentColor : widget.model.paletteColor),
                            const SizedBox(width: 8),
                            if (Responsive.isDesktop(context)) Text((currentEditingMode != null) ? currentEditingMode! : 'Edit', style: TextStyle(color: (currentEditingMode == null) ? widget.model.paletteColor : widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1),
                            if (Responsive.isDesktop(context) == false) Expanded(child: Text(currentEditingMode ?? 'Options', style: TextStyle(color: (currentEditingMode == null) ? widget.model.paletteColor : widget.model.accentColor, fontSize: null, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1,)),
                      ],
                    )
                  )
                ),
              ),
            ),
            onChanged: (Object? navItem) {
            },
            items: allDropDrownOptions.map(
                    (e) {
                  return DropdownMenuItem<String>(
                    onTap: () {
                      setState(() {
                        if (e == 'Export') {
                          final List<VendorContactDetail> vendorAppList = [];
                          for (List<VendorContactDetail> vendorList in booths.toList()) {
                            for (VendorContactDetail vendor in vendorList) {
                              vendorAppList.add(vendor);
                            }
                          }
                          /// based on sorted
                          exportToExcel(vendorAppList, widget.selectedForm.availableTimeSlots, widget.selectedForm.formTitle ?? 'My Form');
                        }

                        if (e == AvailabilityStatus.confirmed.name || e == AvailabilityStatus.requested.name) {
                          selectedVendors.clear();
                          if (currentEditingMode == e) {
                            currentEditingMode = null;
                          } else {
                            currentEditingMode = e;
                          }
                        }
                      });
                    },
                    value: e,
                    child: Text(e.capitalize(), style: TextStyle(color: widget.model.paletteColor, fontWeight: (currentEditingMode == e) ? FontWeight.bold : null)),
                  );
                }
            ).toList(),
            dropdownStyleData: DropdownStyleData(
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: widget.model.webBackgroundColor,
              ),
            ),
          )
      ),
    );
  }
}