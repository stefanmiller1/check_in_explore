import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReservationTypeOption {

  final UniqueId typeId;
  final String title;
  final String subTitle;
  final IconData resIcon;

  ReservationTypeOption({required this.typeId, required this.title, required this.subTitle, required this.resIcon});

}

List<ReservationTypeOption> getReservationOptions(BuildContext context) {
  return [
    ReservationTypeOption(typeId: UniqueId.fromUniqueString('6e24dae0-96dd-11eb-gfku-gnio34n309f4'), title: 'Create Slots', subTitle: '', resIcon: Icons.list_alt_rounded),
    ReservationTypeOption(typeId: UniqueId.fromUniqueString('6e24dae0-96dd-11eb-gfku-nifo4o3oi2i4'), title: AppLocalizations.of(context)!.activityCreatorFormNavAttendanceTicket1, subTitle: AppLocalizations.of(context)!.activityCreatorFormNavAttendanceTicketDes, resIcon: Icons.airplane_ticket_rounded),
    ReservationTypeOption(typeId: UniqueId.fromUniqueString('6e24dae0-96dd-11eb-gfku-986gkuyfjkl2'), title: AppLocalizations.of(context)!.activityCreatorFormNavAttendancePasses1, subTitle: AppLocalizations.of(context)!.activityCreatorFormNavAttendancePassesDes, resIcon: Icons.credit_card_rounded),
  ];
}