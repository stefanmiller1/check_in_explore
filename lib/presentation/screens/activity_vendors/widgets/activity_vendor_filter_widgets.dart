import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/filter_services/vendor_contact_filter_model.dart';
import 'package:check_in_domain/domain/misc/attendee_services/form/merchant_vendor/booth_payments/mv_booth_payments.dart';
import 'package:check_in_domain/domain/misc/attendee_services/form/merchant_vendor/custom_availability/mv_custom_availability.dart';
import '../activity_vendors_results_helper.dart';

class ActivityVendorFilterPopOver extends StatefulWidget {

  final VendorMerchantForm vendorForm;
  final ActivityManagerForm activityForm;
  final VendorContactFilterModel? filterModel;
  final DashboardModel model;
  final Function(VendorContactFilterModel?) didFinishUpdatingFilter;

  const ActivityVendorFilterPopOver({super.key, required this.model, this.filterModel, required this.vendorForm, required this.activityForm, required this.didFinishUpdatingFilter});

  @override
  State<ActivityVendorFilterPopOver> createState() => _ActivityVendorFilterPopOverState();
}

class _ActivityVendorFilterPopOverState extends State<ActivityVendorFilterPopOver> {

  late VendorContactFilterModel? currentFilterModel = null;

  @override
  void initState() {
    currentFilterModel = widget.filterModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      elevation: 0,
      backgroundColor: widget.model.paletteColor,
        title: Text(
          'Filter', style: TextStyle(color: widget.model.accentColor),
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
                    if (currentFilterModel != null) {
                      widget.didFinishUpdatingFilter(null);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(' Clear ', style: TextStyle(color: (currentFilterModel != null) ? widget.model.accentColor : widget.model.accentColor.withOpacity(0.4), fontSize: widget.model.secondaryQuestionTitleFontSize),),
                ),
              ),
            ),
          ],
        ),
        actions: [
          const SizedBox(width: 8),
          Center(
            child: Container(
                decoration: (currentFilterModel != null) ? BoxDecoration(
                    color: widget.model.accentColor,
                    borderRadius: BorderRadius.circular(20)
                ) : null,
              child: InkWell(
                onTap: () {
                  if (currentFilterModel != null) {
                    if (getNumberOfFilterItems(currentFilterModel) == 0) {
                      widget.didFinishUpdatingFilter(null);
                    } else {
                      widget.didFinishUpdatingFilter(currentFilterModel!);
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text('Add Filter', style: TextStyle(color: (currentFilterModel != null) ? widget.model.paletteColor : widget.model.accentColor.withOpacity(0.4), fontSize: widget.model.secondaryQuestionTitleFontSize),),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                  title: Text('Select Filters based on your Vendor Form', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                  subtitle: Text('applicants will be filtered by what you select once your\'re done.'),
              ),
              const SizedBox(height: 15),
              Visibility(
                visible: widget.vendorForm.availableTimeSlots != null && widget.vendorForm.availableTimeSlots?.isNotEmpty == true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      ListTile(
                          title: Text('Select an Availability', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        runSpacing: 6,
                        spacing: 8,
                        alignment: WrapAlignment.start,
                        direction: Axis.horizontal,
                        children: widget.vendorForm.availableTimeSlots?.where((element) => element.isConfirmed == true).toList().asMap().map((i, e) {
                        return MapEntry(i,
                          getVendorSimpleAvailableTimeSlot(
                              context,
                              widget.model,
                              e,
                              i,
                              (currentFilterModel?.availabilityFilter ?? []).contains(e) == true,
                              didSelectTimeOption: (time) {
                                setState(() {
                                  late VendorContactFilterModel? newFilter = (currentFilterModel == null) ? VendorContactFilterModel(availabilityFilter: [], boothFilter: [], boothStatusFilter: [], vendorTypeFilter: []) : currentFilterModel;
                                  final List<MCCustomAvailability> list = [];
                                  list.addAll(currentFilterModel?.availabilityFilter ?? []);

                                  if (list.map((e) => e.uid).contains(time.uid)) {
                                    list.remove(time);
                                  } else {
                                    list.add(time);
                                  }

                                  newFilter = newFilter?.copyWith(
                                    availabilityFilter: list
                                  );

                                  currentFilterModel = newFilter;

                                });
                              }
                            ),
                          );
                        }).values.toList() ?? [],
                      ),
                      const SizedBox(height: 25),
                      Divider(color: widget.model.disabledTextColor),
                  ],
                )
              ),

              Visibility(
                visible: widget.vendorForm.boothPaymentOptions != null && widget.vendorForm.boothPaymentOptions?.isNotEmpty == true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      ListTile(
                          title: Text('Booth Type', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                          alignment: WrapAlignment.start,
                          runSpacing: 6,
                          spacing: 8,
                          children: widget.vendorForm.boothPaymentOptions?.toList().asMap().map((j, f) {
                            return MapEntry(j, getBoothPaymentsOption(
                                context,
                                widget.model,
                                f,
                                widget.activityForm.rulesService.currency,
                                (currentFilterModel?.boothFilter ?? []).contains(f) == true,
                                j,
                                didSelectTimeOption: (booth) {
                                  setState(() {


                                  late VendorContactFilterModel? newFilter = (currentFilterModel == null) ? VendorContactFilterModel(availabilityFilter: [], boothFilter: [], boothStatusFilter: [], vendorTypeFilter: []) : currentFilterModel;
                                  late List<MVBoothPayments> list = [];

                                  list.addAll(currentFilterModel?.boothFilter ?? []);

                                  if (list.map((e) => e.uid).contains(booth.uid)) {
                                    list.remove(booth);
                                  } else {
                                    list.add(booth);
                                  }

                                   newFilter = newFilter?.copyWith(
                                      boothFilter: list
                                  );

                                  currentFilterModel = newFilter;
                                  });
                                }
                              ),
                            );
                          }
                        ).values.toList() ?? []
                      ),
                      const SizedBox(height: 25),
                      Divider(color: widget.model.disabledTextColor),
                  ],
                )
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  ListTile(
                      title: Text('Vendor Type', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 6,
                      spacing: 8,
                      children: MerchantVendorTypes.values.map(
                              (e) => InkWell(
                            onTap: () {
                              setState(() {

                              late VendorContactFilterModel? newFilter = (currentFilterModel == null) ? VendorContactFilterModel(availabilityFilter: [], boothFilter: [], boothStatusFilter: [], vendorTypeFilter: []) : currentFilterModel;
                              List<MerchantVendorTypes> types = [];
                              types.addAll(currentFilterModel?.vendorTypeFilter ?? []);

                              if (types.contains(e) == true) {
                                  types.remove(e);
                                } else {
                                  types.add(e);
                                }

                              newFilter = newFilter?.copyWith(
                                  vendorTypeFilter: types
                              );

                              currentFilterModel = newFilter;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: (currentFilterModel?.vendorTypeFilter.contains(e) == true) ? widget.model.paletteColor : widget.model.accentColor,
                                    borderRadius: BorderRadius.circular(18)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(getVendorMerchTitle(e), style: TextStyle(color: (currentFilterModel?.vendorTypeFilter.contains(e) == true) ? widget.model.accentColor : widget.model.disabledTextColor)),
                                )
                            ),
                          )
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}