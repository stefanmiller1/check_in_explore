import 'package:check_in_domain/domain/misc/attendee_services/form/merchant_vendor/booth_payments/mv_booth_payments.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:excel/excel.dart' as ex;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/domain/misc/filter_services/vendor_contact_filter_model.dart';

import 'widgets/activity_vendor_confirmation_widget.dart';
import 'widgets/activity_vendor_filter_widgets.dart';
import 'widgets/activty_vendor_rejection_widget.dart';


int getNumberOfFilterItems(VendorContactFilterModel? filter) {
  late int total = 0;

  for (var available in filter?.availabilityFilter ?? []) {
    total += 1;
  }

  for (var booth in filter?.boothFilter ?? []) {
    total += 1;
  }

  for (var boothStatus in filter?.boothStatusFilter ?? []) {
    total += 1;
  }

  for (var vType in filter?.vendorTypeFilter ?? []) {
    total += 1;
  }

  return total;
}


bool filterByAvailability(MVBoothPayments booth, VendorContactFilterModel? filterModel) {
  if (filterModel == null) {
    return true;
  }

  if (filterModel.availabilityFilter.isEmpty == true) {
    return true;
  }

  bool matchesAvailability = filterModel.availabilityFilter.any(
          (filterAvailability) => booth.availabilityId == filterAvailability.uid // Adjust field names based on actual model structure
  );
  return matchesAvailability;
}

bool filterByBoothItem(MVBoothPayments booth, VendorContactFilterModel? filterModel) {
  if (filterModel == null) {
    return true;
  }

  if (filterModel.boothFilter.isEmpty == true) {
    return true;
  }

  bool matchesBooth = filterModel.boothFilter.any(
          (filterBooth) => booth.uid == filterBooth.uid // Assuming uid can be compared, adjust based on actual need
  );

  return matchesBooth;
}

bool filterByByBoothStatus(MVBoothPayments booth, VendorContactFilterModel? filterModel) {
  if (filterModel == null) {
    return true;
  }

  if (filterModel.boothStatusFilter.isEmpty == true) {
    return true;
  }
  // Check if the booth status matches any status in the filter
  bool matchesBoothStatus = filterModel.boothStatusFilter.any(
          (status) => booth.status == status // Assuming status can be directly compared
  );
  return matchesBoothStatus;
}

bool filterByVendorType(EventMerchantVendorProfile? vProfile, VendorContactFilterModel? filterModel) {
  if (filterModel == null) {
    return true;
  }

  if (filterModel.vendorTypeFilter.isEmpty == true) {
    return true;
  }

  bool matchesVendorType = filterModel.vendorTypeFilter.any(
          (type) => vProfile?.type?.contains(type) == true// Adjust based on actual VendorForm model structure
  );

  return matchesVendorType;
}


bool filterProfileName(List<UserProfileModel> profiles, UniqueId attendeeId, String query) {
  final UserProfileModel? profile = profiles.where((element) => element.userId == attendeeId).isNotEmpty ? profiles.where((element) => element.userId == attendeeId).first : null;
  if (profile == null) {
    return true;
  }

  return (profile.legalName.value.fold((l) => '', (r) => r).toLowerCase().contains(query));
}

bool filterProfileLastName(List<UserProfileModel> profiles, UniqueId attendeeId, String query) {
  final UserProfileModel? profile = profiles.where((element) => element.userId == attendeeId).isNotEmpty ? profiles.where((element) => element.userId == attendeeId).first : null;
  if (profile == null) {
    return false;
  }

  return (profile.legalSurname.value.fold((l) => '', (r) => r).toLowerCase().contains(query));
}

bool filterProfileFirstLastName(List<UserProfileModel> profiles, UniqueId attendeeId, String query) {
  final UserProfileModel? profile = profiles.where((element) => element.userId == attendeeId).isNotEmpty ? profiles.where((element) => element.userId == attendeeId).first : null;
  if (profile == null) {
    return false;
  }
  final String firstLast = '${profile.legalName.value.fold((l) => '', (r) => r)} ${profile.legalSurname.value.fold((l) => '', (r) => r)}';

  return firstLast.toLowerCase().contains(query);
}


bool filterByVendorName(List<EventMerchantVendorProfile> profiles, UniqueId attendeeId, String query) {
  final EventMerchantVendorProfile? profile = profiles.where((element) => element.profileOwner == attendeeId).isNotEmpty ? profiles.where((element) => element.profileOwner == attendeeId).first : null;
  if (profile == null) {
    return false;
  }

  return profile.brandName.value.fold((l) => '', (r) => r).toLowerCase().contains(query);
}

void showConfirmationPopOver(BuildContext context, DashboardModel model, int selectedCount, {required Function() didSelectSave}) {
  if (kIsWeb) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Filter',
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return  Align(
            alignment: Alignment.center,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Container(
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(17.5))
                    ),
                    width: 770,
                    height: 300,
                    child: ActivityVendorConfirmationPopOver(
                      numberOfConfirmed: selectedCount,
                      model: model,
                      didSelectSave: () {
                        didSelectSave();
                      },
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
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return ActivityVendorConfirmationPopOver(
            numberOfConfirmed: selectedCount,
            model: model,
            didSelectSave: () {

            },
          );
        })
    );
  }
}

void showRejectionPopOver(BuildContext context, DashboardModel model, String currency, List<VendorContactDetail> rejectionList, {required Function() didSelectReject}) {
  if (kIsWeb) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Filter',
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return  Align(
            alignment: Alignment.center,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Container(
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(17.5))
                    ),
                    width: 550,
                    height: 750,
                    child: ActivityVendorRejectionPopOver(
                      rejectionList: rejectionList,
                      currency: currency,
                      model: model,
                      didSelectReject: () {
                        didSelectReject();
                }
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
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return ActivityVendorRejectionPopOver(
              rejectionList: rejectionList,
              currency: currency,
              model: model,
              didSelectReject: () {
                didSelectReject();
              }
          );
        })
    );
  }
}

void showFilterOptions(BuildContext context, DashboardModel model, ActivityManagerForm activityForm, VendorContactFilterModel? filterModel, VendorMerchantForm vendorForm, {required Function(VendorContactFilterModel?) didSelectFilter}) {
  if (kIsWeb) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Filter',
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return  Align(
            alignment: Alignment.center,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Container(
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(17.5))
                    ),
                    width: 770,
                    height: 900,
                    child: ActivityVendorFilterPopOver(
                      vendorForm: vendorForm,
                      activityForm: activityForm,
                      filterModel: filterModel,
                      model: model,
                      didFinishUpdatingFilter: (filter) {
                        didSelectFilter(filter);
                      },
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
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return ActivityVendorFilterPopOver(
            vendorForm: vendorForm,
            activityForm: activityForm,
            filterModel: filterModel,
            model: model, 
            didFinishUpdatingFilter: (VendorContactFilterModel ) {  
              
            },
          );
        })
    );
  }
}

