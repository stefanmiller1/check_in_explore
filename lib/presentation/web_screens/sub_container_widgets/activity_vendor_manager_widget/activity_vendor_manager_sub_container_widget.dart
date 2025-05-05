import 'dart:js_interop';
import 'dart:ui';

import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/core/router_helper.dart';
import 'package:check_in_presentation/profile_core_widgets/profile_settings/components/payments_widget/payout_payment_methods_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:beamer/beamer.dart';

import '../../focused_main_container_widgets/activity_vendor_form_manage_widget/actvity_vendor_form_manager_helper.dart';

class ActivityVendorManagerSubContainer extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem? initialReservation;
  final String? currentVendorManagerFormId;
  // final ActivityManagerForm? currentActivityManagerForm;
  // final ListingManagerForm? listing;
  final UserProfileModel? currentUser;
  final Function(VendorMerchantForm form) didSelectFormItem;
  final Function() didSelectManageVendorForm;

  const ActivityVendorManagerSubContainer({super.key, required this.model, required this.didSelectFormItem, required this.didSelectManageVendorForm, required this.currentUser, required this.initialReservation, this.currentVendorManagerFormId});

  @override
  State<ActivityVendorManagerSubContainer> createState() => _ActivityVendorManagerSubContainerState();
}

class _ActivityVendorManagerSubContainerState extends State<ActivityVendorManagerSubContainer> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      appBar: (!(kIsWeb)) ? AppBar(
        backgroundColor: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.paletteColor : widget.model.mobileBackgroundColor,
        title: const Text('Manage Vendor Applications'),
        titleTextStyle: TextStyle(color: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.accentColor : widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
        centerTitle: true,
      ) : null,
      body: (widget.initialReservation != null) ? getReservationListing(context, widget.initialReservation!) : Container()
    );
  }


  Widget getReservationListing(BuildContext context, ReservationItem reservation) {
    if (ActivityVendorHelperCore.isLoadingSubContainer) {
      return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
    }
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<ListingManagerWatcherBloc>()..add(ListingManagerWatcherEvent.watchListingManagerItemStarted(reservation.instanceId.getOrCrash()))),
          BlocProvider(create: (_) => getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(reservation.reservationId.getOrCrash()))),
        ],
        child: BlocBuilder<ListingManagerWatcherBloc, ListingManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadListingManagerItemSuccess: (item) {
                  return getActivityForm(context, reservation, item.failure);
                },
                orElse: () => Container()
          );
        },
      ),
    );
  }

  Widget getActivityForm(BuildContext context, ReservationItem reservation, ListingManagerForm listingForm) {
    return BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
            loadActivityManagerFormSuccess: (item) {
              return getMainContainer(context, reservation, listingForm, item.item);
            },
            orElse: () => Container()
        );
      },
    );
  }

  Widget getMainContainer(BuildContext context, ReservationItem reservation, ListingManagerForm listingManagerForm, ActivityManagerForm activityManagerForm) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: activityManagerForm.rulesService.vendorMerchantForms?.toList().asMap().map((i, form) {

                      return MapEntry(i, SlideInTransitionWidget(
                        durationTime: 300 * i,
                        offset: Offset(0, 0.25),
                        transitionWidget: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(17.5)),
                                border: widget.currentVendorManagerFormId == form.formId.getOrCrash() ? Border.all(color: widget.model.paletteColor, width: 1.5) : null
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: widget.model.webBackgroundColor,
                                        borderRadius: BorderRadius.all(Radius.circular(17.5))
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        widget.didSelectFormItem(form);
                                      },
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 15),
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: (widget.currentVendorManagerFormId == form.formId.getOrCrash()) ? widget.model.paletteColor : widget.model.disabledTextColor.withOpacity(0.2),
                                                  borderRadius: BorderRadius.all(Radius.circular(30))
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(Icons.note_alt_outlined, color:  widget.model.webBackgroundColor, size: 35),
                                              )
                                          ),
                                          const SizedBox(height: 15),
                                          Text(form.formTitle ?? 'Form', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                                          // Divider(color: widget.model.disabledTextColor),
                                          const SizedBox(height: 25),
                                          if (form.welcomeMessage != null && form.welcomeMessage!.isNotEmpty) ListTile(
                                            leading: Icon(Icons.favorite_border_rounded, color: widget.model.disabledTextColor),
                                            title: Text('Welcome Message', style: TextStyle(color: widget.model.paletteColor)),
                                            subtitle: Text(form.welcomeMessage!, style: TextStyle(color: widget.model.disabledTextColor, overflow: TextOverflow.ellipsis), maxLines: 1,),
                                          ),
                                          if (form.openCloseDates != null) ListTile(
                                            leading: Icon(Icons.timer_outlined, color: widget.model.disabledTextColor),
                                            title: Text('Close & Open form at:', style: TextStyle(color: widget.model.paletteColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                                            subtitle: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: widget.model.disabledTextColor.withOpacity(0.35),
                                                          borderRadius: BorderRadius.all(Radius.circular(17.5))
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Center(child: Text(DateFormat.yMMMd().format(form.openCloseDates?.start ?? DateTime.now()), style: TextStyle(color: widget.model.paletteColor, overflow: TextOverflow.ellipsis), maxLines: 1)),
                                                      )
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Divider(color: widget.model.disabledTextColor),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: widget.model.disabledTextColor.withOpacity(0.35),
                                                          borderRadius: BorderRadius.all(Radius.circular(17.5))
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Center(child: Text(DateFormat.yMMMd().format(form.openCloseDates?.end ?? DateTime.fromMillisecondsSinceEpoch(retrieveTimeStampForLastTimeSlot(reservation.reservationSlotItem))), style: TextStyle(color: widget.model.paletteColor, overflow: TextOverflow.ellipsis), maxLines: 1)),
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (form.availableTimeSlots == null) ListTile(
                                            leading: Icon(Icons.calendar_month_outlined, color: widget.model.disabledTextColor),
                                            title: Wrap(
                                                children: [Container(
                                                  height: 30,
                                                  width: 30,
                                                  child: Icon(Icons.calendar_month_rounded),
                                                ),
                                                ]
                                            ),
                                            subtitle: Text('1 Option to Choose From'),
                                          ),

                                          if (form.availableTimeSlots != null) ListTile(
                                            leading: Icon(Icons.calendar_month_outlined, color: widget.model.disabledTextColor),
                                            title: Wrap(
                                                children: form.availableTimeSlots?.map(
                                                      (e) =>  Container(
                                                    height: 30,
                                                    width: 30,
                                                    child: Icon(Icons.calendar_month_rounded),
                                                  ),
                                                ).toList() ?? []
                                            ),
                                            subtitle: Text('${form.availableTimeSlots?.length} different Dates to choose From'),
                                          ),

                                          if (form.boothPaymentOptions != null) ListTile(
                                            leading: Icon(Icons.storefront, color: widget.model.disabledTextColor),
                                            title: Wrap(
                                              children: form.boothPaymentOptions?.map(
                                                    (e) => Container(
                                                  height: 30,
                                                  width: 30,
                                                  child: Icon(Icons.local_convenience_store_rounded),
                                                ),
                                              ).toList() ?? [],
                                            ),
                                            subtitle: Text((form.boothPaymentOptions?.length == 1) ? '1 Custom Booth Type' : '${form.boothPaymentOptions?.length ?? 0} Custom Booth Types'),
                                          ),

                                          if (form.customOptions != null && form.customOptions?.isNotEmpty == true) ListTile(
                                            leading: Icon(Icons.note_alt_outlined, color: widget.model.disabledTextColor),
                                            title: Text('Requires Documents', style: TextStyle(color: widget.model.paletteColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                                          ),

                                          if (form.disclaimerOptions != null && form.disclaimerOptions?.isNotEmpty == true) ListTile(
                                            leading: Icon(Icons.info_outline, color: widget.model.disabledTextColor),
                                            title: Text((form.disclaimerOptions?.length == 1) ? '1 Disclaimer' : '${form.disclaimerOptions?.length ?? 0} Disclaimers', style: TextStyle(color: widget.model.paletteColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                                          ),

                                          Divider(color: widget.model.disabledTextColor),

                                          const SizedBox(height: 25),
                                          Text('Last opened at: ${DateFormat.MMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(form.lastOpenedAt))}', style: TextStyle(color: widget.model.disabledTextColor)),
                                          const SizedBox(height: 15),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    top: 10,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: getStatusColor(widget.model, form.formStatus).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(form.formStatus.name, style: TextStyle(color: getStatusColor(widget.model, form.formStatus))),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      );
                    }).values.toList() ?? [],
                  ),
                ),

                // getActivityTicketOptionsColumn(
                //     context,
                //     widget.model,
                //     widget.currentReservationItem ?? ReservationItem.empty(),
                //     widget.currentActivityManagerForm ?? ActivityManagerForm.empty(),
                //     false,
                //     ActivityTicketHelperCore.selectedTicket,
                //     didSelectTicketOption: (ticket) {
                //       widget.didSelectTicketItem(ticket);
                //     }
                // ),
                const SizedBox(height: 210),
              ],
            ),
          ),
        ),

        Container(
            height: 210,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ClipRRect(
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: widget.model.accentColor.withOpacity(0.35)
                        ),
                        child: getApplicantsReceivedFooter(context, reservation, listingManagerForm, activityManagerForm),
                    )
                ),
              ),
            )
        ),
      ],
    );
  }

  Widget getApplicantsReceivedFooter(BuildContext context, ReservationItem reservation, ListingManagerForm listingManagerForm, ActivityManagerForm activityManagerForm,) {
    return BlocProvider(create: (context) => getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.vendor.toString(), reservation.reservationId.getOrCrash())),
        child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  attLoadInProgress: (_) => getLoadingForOverviewFooter(context),
                  /// earnings from all vendors
                  loadAllAttendanceSuccess: (allAttendees) {
                    return applicantsReceivedFooterWidget(
                        context,
                        reservation,
                        allAttendees.item.where((element) => element.vendorForm != null && (element.vendorForm?.boothPaymentOptions?.map((e) => e.status).contains(AvailabilityStatus.confirmed) == true)).toList(),
                        listingManagerForm,
                        activityManagerForm
                    );
                  },
                  /// no earnings yet.
                  orElse: () => getNoApplicantsFooter(
                      context,
                      reservation,
                      listingManagerForm,
                      activityManagerForm
                  )
              );
            }
        )
    );
  }

  Widget applicantsReceivedFooterWidget(BuildContext context, ReservationItem reservation, List<AttendeeItem> vendorApplicants, ListingManagerForm listingManagerForm, ActivityManagerForm activityManagerForm) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('Total Earnings: ', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize), maxLines: 1)),
              /// earnings,
              Row(
                children: [
                  Text(completeTotalPriceWithCurrency((totalFeeFromAllApplicants(vendorApplicants.map((e) => e.vendorForm).toList() ?? [])).toDouble() - (totalFeeFromAllApplicants(vendorApplicants.map((e) => e.vendorForm).toList() ?? [])).toDouble() * CICOSellerPercentageFee, activityManagerForm.rulesService.currency),
                      style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                  Icon(Icons.credit_card, color: widget.model.paletteColor)
                ],
              ),
              /// number of tickets on sale
              /// link to stripe
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('Vendors Accepted:', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize), maxLines: 1,)),

              Row(
                children: [
                  Text('x ${vendorApplicants.length} ', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                  Icon(Icons.note_alt_outlined, color: widget.model.paletteColor)
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),
          if (widget.currentUser != null) InkWell(
            onTap: () {
              if (kIsWeb) {
                showGeneralDialog(
                  context: context,
                  barrierDismissible: false,
                  barrierLabel: 'Payment Methods',
                  transitionDuration: Duration(milliseconds: 350),
                  pageBuilder: (BuildContext contexts, anim1, anim2) {
                    return  Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: widget.model.accentColor,
                                    borderRadius: BorderRadius.all(Radius.circular(17.5))
                                ),
                                width: 550,
                                height: 750,
                                child: PayoutAccountLink(
                                  model: widget.model,
                                )
                            )
                        )
                    );
                  },
                  transitionBuilder: (context, anim1, anim2, child) {
                    return Transform.scale(
                        scale: anim1.value,
                        child: Opacity(
                            opacity: anim1.value,
                            child: child
                        )
                    );
                  },
                );
              } else {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) {
                      return PayoutAccountLink(
                        model: widget.model,
                      );
                    })
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: widget.model.paletteColor
              ),
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Center(child: Text('Review My Earnings', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold))),
              ),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              if (kIsWeb) {
                Beamer.of(context).update(
                    configuration: RouteInformation(
                        location: reservationSettingsRoute(reservation.reservationId.getOrCrash(), SettingNavMarker.vendorForm.name)
                    ),
                    rebuild: false
                );
                context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resSettings));
                final SettingNavMarker navItem = getReservationSettingNavMarker(SettingNavMarker.vendorForm.name);
                ReservationHelperCore.currentSettingsItemModel = (subActivitySettingItems(null).isNotEmpty && subActivitySettingItems(null).where((e) => e.navItem == navItem).isNotEmpty) ? subActivitySettingItems(null).where((e) => e.navItem == navItem).first : subActivitySettingItems(null)[0];

              } else {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      /// if owner else show attendee manage options
                      return ActivitySettingsScreenMobile(
                        model: widget.model,
                        reservationItem: reservation,
                        activityManagerForm: activityManagerForm,
                        listing: listingManagerForm,
                        currentUser: widget.currentUser!,
                      );
                    })
                );
              }
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: widget.model.webBackgroundColor
                ),
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Center(child: Text('Manage Vendor Forms', style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold))),
                )
            ),
          )
        ],
      ),
    );
  }

  Widget getNoApplicantsFooter(BuildContext context, ReservationItem reservation, ListingManagerForm listingManagerForm, ActivityManagerForm activityManagerForm) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(Icons.note_alt_outlined, color: widget.model.disabledTextColor, size: 35),
            const SizedBox(height: 10),
            Text('Applicant Info will appear here', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                if (kIsWeb) {
                  Beamer.of(context).update(
                      configuration: RouteInformation(
                          location: reservationSettingsRoute(reservation.reservationId.getOrCrash(), SettingNavMarker.vendorForm.name)
                      ),
                      rebuild: false
                  );
                  context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resSettings));
                  final SettingNavMarker navItem = getReservationSettingNavMarker(SettingNavMarker.vendorForm.name);
                  ReservationHelperCore.currentSettingsItemModel = (subActivitySettingItems(null).isNotEmpty && subActivitySettingItems(null).where((e) => e.navItem == navItem).isNotEmpty) ? subActivitySettingItems(null).where((e) => e.navItem == navItem).first : subActivitySettingItems(null)[0];

                } else {

                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) {
                        /// if owner else show attendee manage options
                        return ActivitySettingsScreenMobile(
                          model: widget.model,
                          reservationItem: reservation,
                          activityManagerForm: activityManagerForm,
                          listing:listingManagerForm,
                          currentUser: widget.currentUser!,
                        );
                      })
                  );
                }
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: widget.model.webBackgroundColor
                  ),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Center(child: Text('Manage Vendor Forms', style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold))),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}