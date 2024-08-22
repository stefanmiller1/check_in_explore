import 'dart:typed_data';
// import 'package:excel/excel.dart';
import 'package:check_in_domain/domain/misc/attendee_services/form/merchant_vendor/custom_availability/mv_custom_availability.dart';
import 'package:check_in_domain/domain/misc/pdf_services/value_objects.dart';
import 'package:check_in_domain/domain/misc/attendee_services/form/merchant_vendor/booth_payments/mv_booth_payments.dart';
import 'package:check_in_domain/domain/misc/filter_services/vendor_contact_filter_model.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:collection/collection.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


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
  vendorDetails.sort((a, b) => a.userProfile.emailAddress.getOrCrash().compareTo(b.userProfile.emailAddress.getOrCrash()));

  String lastEmail = "";
  // Add data
  for (var detail in vendorDetails) {
  // Check for email change to add a blank row for visual separation
    if (lastEmail != "" && detail.userProfile.emailAddress.getOrCrash() != lastEmail) {
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
    TextCellValue(detail.userProfile.legalSurname.value.fold((l) => '', (r) => r)),
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

Future<Uint8List> loadLogoFromAssets(String path) async {
  final ByteData data = await rootBundle.load(path);
  return data.buffer.asUint8List();
}



Future<Uint8List> generateRefundPdf(ActivityManagerForm activity, UserProfileModel vendorUser, EventMerchantVendorProfile vendorProfile, VendorMerchantForm vendorForm) {
  final pdf = pw.Document();
  final fontSize = 9.0;
  final lineThickness = 1.0;
  final double columnWidth = PdfPageFormat.a4.width / 2 - 48; // Subtracting padding from width
  final greyColor = PdfColors.grey; // Define the grey color

  pdf.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        buildBackground: (context) {
          return pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(
              color: const PdfColor.fromInt(0xFFEAF5F6), // Very light teal background color
            ),
          );
        },
      ),
      build: (pw.Context context) {
        return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'ACIRCLE',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.Divider(thickness: lineThickness, color: greyColor),
              pw.SizedBox(height: 10),
              pw.Text(
                'Thanks, ${vendorUser.legalName.getOrCrash()}',
                style: pw.TextStyle(fontSize: 20),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                "We updated your receipt for ${activity.profileService.activityBackground.activityTitle.getOrCrash()} and ACIRCLE.",
                style: pw.TextStyle(fontSize: 9),
              ),
              pw.SizedBox(height: 30),
              pw.Divider(thickness: lineThickness, color: greyColor),
              pw.SizedBox(height: 10),
              pw.Text(
                'Invoice number: 739F9135-0001',
                style: pw.TextStyle(fontSize: fontSize),
              ),
              pw.Text(
                'Receipt number: 739F9135',
                style: pw.TextStyle(fontSize: fontSize),
              ),
              pw.Text(
                'Date paid: July 27, 2024',
                style: pw.TextStyle(fontSize: fontSize),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'A CIRCLE POP-UP',
                        style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        'cincout.ca',
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                      pw.Text(
                        '65 Songbird Drive, Markham',
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                      pw.Text(
                        'Ontario, L3S 3T9, Canada',
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                      pw.Text(
                        '+1 647-389-9063',
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Bill to:',
                        style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        'Jennifer Tsang',
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                      pw.Text(
                        '2684709 Ontario Inc',
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                      pw.Text(
                        'Markham, Ontario, Canada',
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                      pw.Text(
                        'jennifer.tsang1997@gmail.com',
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'CA\$25.60 paid on July 27, 2024',
                style: pw.TextStyle(fontSize: 15),
              ),
              pw.SizedBox(height: 20),

              // Previous Total and New Total with dividers
              buildSummaryRow('Previous Total', 'CA\$81.72', fontSize),
              pw.Divider(thickness: lineThickness, color: greyColor),
              buildSummaryRow('New Total', 'CA\$90.00', fontSize, isBold: true),
              pw.Divider(thickness: lineThickness, color: greyColor),

              pw.SizedBox(height: 35),
// Payments section
              pw.Text(
                'Payments',
                style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold),
              ),
              pw.Divider(thickness: lineThickness, color: greyColor),
              buildPaymentRow(
                paymentMethod: 'Apple Pay Visa ****1234',
                dateTime: '8/9/24 3:35PM',
                amount: 'CA\$23.23',
                fontSize: fontSize,
                isRefund: true,
              ),
              pw.SizedBox(height: 30),

            ],
          ),
        ];
      },
      footer: (pw.Context context) {
        return pw.Container(
          // alignment: pw.Alignment.,
          margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: pw.Text(
            '739F9135 · CA\$25.60 paid on July 27, 2024',
            style: pw.TextStyle(fontSize: fontSize),
          ),
        );
      },
    ),
  );

  return pdf.save();
}


