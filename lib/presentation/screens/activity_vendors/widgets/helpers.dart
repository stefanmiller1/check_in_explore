import 'package:excel/excel.dart';
import 'package:check_in_domain/domain/misc/attendee_services/form/merchant_vendor/custom_availability/mv_custom_availability.dart';
import 'package:check_in_domain/domain/misc/filter_services/vendor_contact_filter_model.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:intl/intl.dart';

void exportToExcel(List<VendorContactDetail> vendorDetails, List<MCCustomAvailability>? availabilitySlot, String vendorForm) {
  final excel = Excel.createExcel();

  Sheet sheet = excel['Sheet1'];

  // Create headers
  var headers = [
  "First Name", "Last Name", "Email", "Vendor Name", "Date Created",
  "Booth Name", "Fee", "Status", "Availability", "Vendor Form"
  ].map((e) => TextCellValue(e)).toList();

  // Add headers to the sheet
  sheet.appendRow(headers);

  // Sort vendorDetails by email before adding to Excel
  vendorDetails.sort((a, b) => a.userProfile!.emailAddress.getOrCrash().compareTo(b.userProfile!.emailAddress.getOrCrash()));

  String lastEmail = "";
  // Add data
  for (var detail in vendorDetails) {
  // Check for email change to add a blank row for visual separation
    if (lastEmail != "" && detail.userProfile!.emailAddress.getOrCrash() != lastEmail) {
    sheet.appendRow(List.filled(headers.length, null)); // Append a blank row
  }

  // Check booth availability
  String availability;

  // final MCCustomAvailability? availability = (vendorDetail.boothItem.availabilityId != null && entry.key.vendorForm?.availableTimeSlots?.where((element) => element.uid == vendorDetail.boothItem.availabilityId).isNotEmpty == true) ? entry.key.vendorForm?.availableTimeSlots?.firstWhere((element) => element.uid == vendorDetail.boothItem.availabilityId) : null;
  if (availabilitySlot != null && availabilitySlot.map((e) => e.uid).contains(detail.boothItem.availabilityId)) {
      final availableSlot = availabilitySlot.firstWhere((element) => element.uid == detail.boothItem.availabilityId);

      availability = (availableSlot.dateTitle != null) ? availableSlot.dateTitle! : availableSlot.selectedSlotItem.map((date) => DateFormat.MMMd().format(date.selectedDate)).join(', ');
    //// Converts list of dates to a comma-separated string
  } else {
  availability = "All Days"; // Default text when no dates are provided
  }

  var row = [
    TextCellValue(detail.userProfile.legalName.getOrCrash()),
    TextCellValue(detail.userProfile.legalSurname.getOrCrash()),
    TextCellValue(detail.userProfile.emailAddress.getOrCrash()),
    TextCellValue(detail.vendorProfile.brandName.getOrCrash()),
    DateCellValue(year: detail.attendee.dateCreated.year, month: detail.attendee.dateCreated.month, day: detail.attendee.dateCreated.day),
    TextCellValue(detail.boothItem.boothTitle ?? 'Booth'),
    IntCellValue(detail.boothItem.fee ?? 0),
    TextCellValue(detail.boothItem.status?.name ?? AvailabilityStatus.requested.name),
    TextCellValue(detail.boothItem.availabilityId == null ? 'All Dates' : availability), // This would be dynamic based on your data model
    TextCellValue(vendorForm) // Adding the vendor form name
  ];
  sheet.appendRow(row);

  // Update lastEmail for the next iteration
  lastEmail = detail.userProfile.emailAddress.getOrCrash() ?? '';
  }

  // Save the file
  excel.save(fileName: "${DateTime.now().year}_${DateTime.now().month}_${DateTime.now().day}_Vendors_$vendorForm.xlsx");

}