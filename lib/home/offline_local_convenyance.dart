import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/home/model/distance_calculate_model.dart'
    as distancePrefix;
import 'package:shakti_employee_app/home/model/local_convence_model.dart';
import 'package:shakti_employee_app/home/model/travelmodel.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;

import '../database/database_helper.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../webservice/APIDirectory.dart';

class OfflineLocalConveyance extends StatefulWidget {
  const OfflineLocalConveyance({Key? key}) : super(key: key);

  @override
  State<OfflineLocalConveyance> createState() => _OfflineLocalConveyanceState();
}

class _OfflineLocalConveyanceState extends State<OfflineLocalConveyance> {
  List<LocalConveyanceModel> listLocalConveyance = [];
  List<TravelModel> travelList = [];
  TextEditingController travelModeController = TextEditingController();
  int? selectedIndex;
  bool isLoading = false;
  String? allLatLng;

  Future<List<Map<String, dynamic>>?> getAllLocalConveyanceData() async {
    List<Map<String, dynamic>> listMap =
        await DatabaseHelper.instance.queryAllLocalConveyance();
    setState(() {
      listMap.forEach(
          (map) => listLocalConveyance.add(LocalConveyanceModel.fromMap(map)));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllLocalConveyanceData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.themeColor,
          elevation: 0,
          title: robotoTextWidget(
              textval: offlineLocalConveyance,
              colorval: AppColor.whiteColor,
              sizeval: 15,
              fontWeight: FontWeight.w800),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColor.whiteColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: Stack(children: [
          Container(
              margin: const EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: listLocalConveyance.length,
                  itemBuilder: (context, position) {
                    return listItem(listLocalConveyance[position], position);
                  })),
          Center(
            child: isLoading == true
                ? const CircularProgressIndicator(
                    color: AppColor.themeColor,
                  )
                : const SizedBox(),
          )
        ]));
  }

  Widget listItem(LocalConveyanceModel listLocalConveyance, int position) {
    return GestureDetector(
        onTap: () {
            Utility().checkInternetConnection().then((connectionResult) {
              if (connectionResult) {
                setState(() {
                  selectedIndex = position;
                  isLoading = true;
                  calculateDistance(listLocalConveyance);
                });
              } else {
                Utility().showInSnackBar(value: checkInternetConnection, context: context);
              }
            });

        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              showLatLngWidget(fromLatitude, listLocalConveyance.fromLatitude),
              showLatLngWidget(
                  fromLongitude, listLocalConveyance.fromLongitude),
              showLatLngWidget(toLatitude, listLocalConveyance.toLatitude),
              showLatLngWidget(toLongitude, listLocalConveyance.toLongitude),
              listLocalConveyance.fromAddress.toString().isNotEmpty?showLatLngWidget(fromAddress, listLocalConveyance.fromAddress):Container(),
              listLocalConveyance.toAddress.toString().isNotEmpty?showLatLngWidget(toAddress, listLocalConveyance.toAddress):Container()
            ]),
          ),
        ));
  }

  showLatLngWidget(String latitude, String latlng) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          robotoTextWidget(
              textval: latitude,
              colorval: AppColor.themeColor,
              sizeval: 14,
              fontWeight: FontWeight.w600),
          Flexible(
              child: robotoTextWidget(
                  textval: latlng,
                  colorval: AppColor.blackColor,
                  sizeval: 12,
                  fontWeight: FontWeight.w400))
        ],
      ),
    );
  }

  Future<void> calculateDistance(
      LocalConveyanceModel localConveyanceList) async {
    var jsonData = null;
    dynamic response = await HTTP.get(getDistanceAPI(
        '${localConveyanceList.fromLatitude},${localConveyanceList.fromLongitude}',
        '${localConveyanceList.toLatitude},${localConveyanceList.toLongitude}'));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      distancePrefix.DistanceCalculateModel distanceCalculateModel =
          distancePrefix.DistanceCalculateModel.fromJson(jsonData);
      if (distanceCalculateModel.rows.isNotEmpty &&
          distanceCalculateModel.rows[0].elements.isNotEmpty &&
          distanceCalculateModel.rows[0].elements[0].distance.text.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) => stopJourneyPopup(
              context, distanceCalculateModel, localConveyanceList),
        );
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
        Utility().showInSnackBar(value: somethingWentWrong, context: context);
      });
    }
  }

  stopJourneyPopup(
      BuildContext context,
      distancePrefix.DistanceCalculateModel distanceCalculateModel,
      LocalConveyanceModel localConveyanceList) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height / 1.7,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: robotoTextWidget(
                            textval: appName,
                            colorval: AppColor.themeColor,
                            sizeval: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      latLongWidget(
                        '$fromLatitude  ${localConveyanceList.fromLatitude}',
                      ),
                      latLongWidget(
                        '$fromLongitude  ${localConveyanceList.fromLongitude}',
                      ),
                      latLongWidget(
                        '$toLatitude  ${localConveyanceList.toLatitude}',
                      ),
                      latLongWidget(
                        '$toLongitude  ${localConveyanceList.toLongitude}',
                      ),
                      latLongWidget(
                        '$fromAddress ${distanceCalculateModel.originAddresses[0]}',
                      ),
                      latLongWidget(
                        '$toAddress ${distanceCalculateModel.destinationAddresses[0]}',
                      ),
                      latLongWidget(
                        '$distanceTravelled ${distanceCalculateModel.rows[0].elements[0].distance.text}',
                      ),
                      travelModeWidget(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColor.whiteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12), // <-- Radius
                                ),
                              ),
                              child: robotoTextWidget(
                                textval: cancel,
                                colorval: AppColor.darkGrey,
                                sizeval: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                if (travelModeController.text
                                    .toString()
                                    .isEmpty) {
                                  Utility().showToast(enterTravelMode);
                                } else {

                                  Utility().checkInternetConnection().then((connectionResult) {
                                    if (connectionResult) {
                                      setState(() {
                                        isLoading = true;
                                        Navigator.of(context).pop();
                                        syncTravelDataAPI(
                                            localConveyanceList,
                                            distanceCalculateModel);
                                      });
                                    } else {
                                      Utility().showInSnackBar(value: checkInternetConnection, context: context);
                                    }
                                  });

                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColor.themeColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12), // <-- Radius
                                ),
                              ),
                              child: robotoTextWidget(
                                textval: confirm,
                                colorval: AppColor.whiteColor,
                                sizeval: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      )
                    ]))));
  }

  latLongWidget(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          robotoTextWidget(
              textval: title,
              colorval: Colors.black,
              sizeval: 12,
              fontWeight: FontWeight.normal),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
        ],
      ),
    );
  }

  travelModeWidget() {
    return Container(
      height: 40,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TextField(
        controller: travelModeController,
        style: const TextStyle(
            color: AppColor.themeColor,
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: enterTravelMode,
          hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Future<void> syncTravelDataAPI(
      LocalConveyanceModel LocalConveyance, distancePrefix.DistanceCalculateModel distanceCalculateModel,) async {

    allLatLng = '${LocalConveyance.fromLatitude},'
        '${LocalConveyance.fromLongitude},'
        '${LocalConveyance.toLatitude},'
        '${LocalConveyance.toLongitude}';
    travelList.add(TravelModel(
        pernr: LocalConveyance.userId.toString(),
        begda: LocalConveyance.createDate,
        endda: LocalConveyance.endDate,
        startTime: LocalConveyance.createTime,
        endTime: LocalConveyance.endTime,
        startLat: LocalConveyance.fromLatitude,
        endLat: LocalConveyance.toLatitude,
        startLong: LocalConveyance.fromLongitude,
        endLong: LocalConveyance.toLongitude,
        latLong111: allLatLng!,
        startLocation: distanceCalculateModel.originAddresses[0],
        endLocation: distanceCalculateModel.destinationAddresses[0],
        distance: distanceCalculateModel
            .rows[0].elements[0].distance.text,
        travelMode: travelModeController.text.toString(),
        latLong: allLatLng!));
    String value = convert.jsonEncode(travelList).toString();
  var jsonData = null;
    dynamic response = await HTTP.get(syncLocalConveyanceAPI(value));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      print('jsonData=====>$jsonData');
      setState(() {
        isLoading = false;
        listLocalConveyance.removeAt(selectedIndex!);
        DatabaseHelper.instance.deleteLocalConveyance(
            LocalConveyance.toMapWithoutId());

      });
    } else {
      setState(() {
        isLoading = false;
        Utility().showInSnackBar(value: somethingWentWrong, context: context);
      });
    }
  }
}
