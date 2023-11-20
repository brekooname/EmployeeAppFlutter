import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shakti_employee_app/DailyReport/model/daily_report_model.dart';
import 'package:shakti_employee_app/DailyReport/image_view_widget.dart';
import 'package:shakti_employee_app/DailyReport/model/vendor_gate_pass_model.dart'
    as vendorGatePassPrefix;
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

import '../Util/utility.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import 'model/image_model.dart';
import 'model/vendornamelistresponse.dart' as VenderList;
import 'model/vendornamelistresponse.dart';

class DailyReport extends StatefulWidget {
  DailyReport({Key? key, required this.vendorGatePassLists}) : super(key: key);
  List<vendorGatePassPrefix.Response> vendorGatePassLists = [];

  @override
  State<DailyReport> createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  String? _selectedType, selectVisit, selectStatus;
  String TypeSpinner = 'Select Visit At ',
      statusType = "Select Status",
      img1 = "",
      img2 = "",
      img3 = "",
      img4 = "",
      img5 = "",
      vendorGatePassDocNo = "",
      vendorGatePassRegion = "",
      vendorGatePassCity = "",
      vendorGatePassStreet = "";

  var TypeList = [
    'Select Visit At ',
    'Supplier Premises',
    'Shakti H.O',
  ];

  var statusList = [
    'Select Status',
    'Open',
    'Close',
    'In Progress',
  ];

  List<VenderList.Response> vendorNameList = [];
  TextEditingController vendoreName = TextEditingController();
  TextEditingController vendoreCode = TextEditingController();
  TextEditingController vendoreAddress = TextEditingController();
  TextEditingController vendoreContac = TextEditingController();
  TextEditingController responsiblePerson1 = TextEditingController();
  TextEditingController responsiblePerson2 = TextEditingController();
  TextEditingController responsiblePerson3 = TextEditingController();
  TextEditingController targetDateController = TextEditingController();
  TextEditingController agenda = TextEditingController();
  TextEditingController discussion = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime datefrom = DateTime.now();
  String? indianFromDate, selectedTargateDate;
  String dateTimeFormat = "dd/MM/yyyy";
  DateTime? pickedDate;
  List<ImageModel> imageList = [];
  var imageFile;
  int? selectedIndex, selectedPassIndex, selectedVendorPosition;
  int imgCount = 0;
  bool isChecked = false, isGatePassListShown = false, isLoading = false;
  late SharedPreferences sharedPreferences;
  List<DailyReportModel> dailyReportModel = [];

  getAllImageData() async {
    imageList.add(
        ImageModel(imageName: 'Photo1', imagePath: '', imageSelected: false));
    imageList.add(
        ImageModel(imageName: 'Photo2', imagePath: '', imageSelected: false));
    imageList.add(
        ImageModel(imageName: 'Photo3', imagePath: '', imageSelected: false));
    imageList.add(
        ImageModel(imageName: 'Photo4', imagePath: '', imageSelected: false));
    imageList.add(
        ImageModel(imageName: 'Photo5', imagePath: '', imageSelected: false));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedTargateDate = DateFormat(dateTimeFormat).format(DateTime.now());
    targetDateController.text =
        DateFormat(dateTimeFormat).format(DateTime.now());
    indianFromDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
    getAllImageData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title: robotoTextWidget(
            textval: dailyReport,
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              radiobuttonWidget(),
              textVendorFeildWidget(searchByName, vendor_name),
              textFieldWidget(enterVendorCode, vendoreCode, vendor_code),
              textFieldWidget(
                  enterVendorAddress, vendoreAddress, vendor_address),
              textFieldWidget(
                  enterVendorContact, vendoreContac, vendor_contact),
              dateTextFieldWidget(
                  currentDat, DateFormat("dd-MM-yyyy").format(DateTime.now())),
              visitAtSpinnerWidget(),
              textFieldWidget(
                  enterSapCode, responsiblePerson1, responsible_person),
              textFieldWidget(
                  enterSapCode, responsiblePerson2, responsible_person2),
              textFieldWidget(
                  enterSapCode, responsiblePerson3, responsible_person3),
              longTextFieldWidget(enterAgenda, agenda, agenda_),
              longTextFieldWidget(
                  enterDiscussionPoint, discussion, discussionPoint),
              datePickerWidget(
                  selectedTargateDate!, targetDateController, target_date),
              statusSpinnerWidget(),
              imageList.isNotEmpty ? imageListWidget() : Container(),
              widget.vendorGatePassLists.isNotEmpty && isGatePassListShown
                  ? gatePassListWidget()
                  : Container(),
              submitDailyReportWidget(),
            ],
          ),
        ),
      ),
    );
  }

  radiobuttonWidget() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio(
                  value: vendor,
                  groupValue: _selectedType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                robotoTextWidget(
                    textval: vendor,
                    colorval: AppColor.themeColor,
                    sizeval: 14,
                    fontWeight: FontWeight.bold),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio(
                  value: prospective_vendor,
                  groupValue: _selectedType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                robotoTextWidget(
                    textval: prospective_vendor,
                    colorval: AppColor.themeColor,
                    sizeval: 14,
                    fontWeight: FontWeight.bold),
              ],
            ),
          )
        ],
      ),
    );
  }

  textVendorFeildWidget(String hinttxt, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.black45, fontWeight: FontWeight.bold),
            )),
        Container(
          margin:
              const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
          padding: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.themeColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: SearchField<List<VenderList.Response>>(
            controller: vendoreName,
            suggestions: vendorNameList
                .map(
                  (vendornamelist) =>
                      SearchFieldListItem<List<VenderList.Response>>(
                    vendornamelist.name1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: robotoTextWidget(
                          textval: vendornamelist.name1,
                          colorval: AppColor.themeColor,
                          sizeval: 12,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                )
                .toList(),
            searchStyle: const TextStyle(
                fontSize: 12,
                color: AppColor.themeColor,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600),
            searchInputDecoration: InputDecoration(
              hintText: hinttxt,
              hintStyle: const TextStyle(
                fontSize: 12,
                color: AppColor.themeColor,
              ),
              border: InputBorder.none,
            ),
            onSearchTextChanged: (serachValue) {
              if (serachValue.length > 2) {
                Utility().checkInternetConnection().then((connectionResult) {
                  if (connectionResult) {
                    vendorNameListAPI(serachValue);
                  } else {
                    Utility()
                        .showInSnackBar(value: checkInternetConnection, context: context);
                  }
                });

              }
              return null;
            },
            onSubmit: (String value) {
              for (int i = 0; i < vendorNameList.length; i++) {
                if (vendorNameList[i].name1 == value) {
                  selectedVendorPosition = i;
                  break;
                }
              }

              setState(() {
                vendoreName.text =
                    vendorNameList[selectedVendorPosition!].name1;
                vendoreCode.text =
                    vendorNameList[selectedVendorPosition!].lifnr;
                vendoreContac.text =
                    vendorNameList[selectedVendorPosition!].telf1;
                vendoreAddress.text =
                    vendorNameList[selectedVendorPosition!].add;
              });
            },
          ),
        )
      ],
    );
  }

  visitAtSpinnerWidget() {
    return Container(
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15),
              child: robotoTextWidget(
                  textval: visitAt,
                  colorval: Colors.black45,
                  sizeval: 12,
                  fontWeight: FontWeight.bold)),
          Container(
              margin: const EdgeInsets.all(10),
              height: 55,
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonFormField(
                isExpanded: true,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.themeColor),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
                    hintText: 'Select visit type',
                    fillColor: Colors.white),
                value: selectVisit,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please Select visit type'
                    : "",
                items: TypeList.map((leaveType) => DropdownMenuItem(
                    value: leaveType,
                    child: robotoTextWidget(
                        textval: leaveType,
                        colorval: AppColor.themeColor,
                        sizeval: 12,
                        fontWeight: FontWeight.bold))).toList(),
                onChanged: (Object? value) {
                  setState(() {
                    if (value.toString() == "Shakti H.O") {
                      isGatePassListShown = true;
                    } else {
                      isGatePassListShown = false;
                    }
                    selectVisit = value.toString();
                  });
                },
              ))
        ],
      ),
    );
  }

  dateTextFieldWidget(String title, String date) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15),
          child: robotoTextWidget(
              textval: title,
              colorval: Colors.black45,
              sizeval: 12,
              fontWeight: FontWeight.bold)),
      Container(
        margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 10),
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.themeColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: TextField(
          style: const TextStyle(
              color: AppColor.themeColor,
              fontSize: 12,
              fontWeight: FontWeight.normal,
              fontFamily: 'Roboto'),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: date,
            hintStyle: const TextStyle(
                color: AppColor.themeColor,
                fontSize: 12,
                fontWeight: FontWeight.normal),
          ),
          keyboardType: TextInputType.text,
        ),
      )
    ]);
  }

  Future<void> _selectDate(BuildContext context) async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      setState(() {
        String formattedDate = DateFormat(dateTimeFormat).format(pickedDate!);
        selectedTargateDate = DateFormat(dateTimeFormat).format(pickedDate!);
        targetDateController.text = formattedDate;
      });
    }
  }

  Future<void> vendorNameListAPI(String value) async {

    var jsonData = null;
    dynamic response = await HTTP.get(vendorNameAPI(value));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      VendorNameResponse vendorNameResponse =
          VendorNameResponse.fromJson(jsonData);
      if (vendorNameResponse.status == "true" &&
          vendorNameResponse.response.isNotEmpty)
        setState(() {
          vendorNameList = vendorNameResponse.response;
        });
    } else {
      Utility().showToast(somethingWentWrong);
    }
  }

  textFieldWidget(
      String hinttxt, TextEditingController visitPlace, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 15),
            child: robotoTextWidget(
                textval: title,
                colorval: Colors.black45,
                sizeval: 12,
                fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.only(left: 15),
          margin:
              const EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.themeColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: TextField(
            controller: visitPlace,
            style: const TextStyle(
                color: AppColor.themeColor,
                fontSize: 12,
                fontWeight: FontWeight.normal,
                fontFamily: 'Roboto'),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hinttxt,
              hintStyle: const TextStyle(
                  color: AppColor.themeColor,
                  fontSize: 12,
                  fontWeight: FontWeight.normal),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  longTextFieldWidget(
      String hintTxt, TextEditingController longtext, String title) {
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 15),
            child: robotoTextWidget(
                textval: title,
                colorval: Colors.black45,
                sizeval: 12,
                fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.only(left: 15),
          margin:
              const EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.themeColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: TextField(
            maxLines: 3,
            controller: longtext,
            style: const TextStyle(
                color: AppColor.themeColor,
                fontSize: 12,
                fontWeight: FontWeight.normal,
                fontFamily: 'Roboto'),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintTxt,
              hintStyle: const TextStyle(
                  color: AppColor.themeColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 13),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  datePickerWidget(
      String fromTO, TextEditingController DateController, String title) {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: robotoTextWidget(
                  textval: title,
                  colorval: Colors.black45,
                  sizeval: 12,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColor.themeColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: AppColor.themeColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: TextField(
                    controller: DateController,
                    maxLines: 1,
                    showCursor: false,
                    enabled: false,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        hintText: fromTO,
                        hintStyle: const TextStyle(
                            color: AppColor.themeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto'),
                        border: InputBorder.none),
                    style: const TextStyle(
                        color: AppColor.themeColor,
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold),
                    keyboardType: TextInputType.datetime,
                    textInputAction: TextInputAction.done,
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  statusSpinnerWidget() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5),
            child: const robotoTextWidget(
                textval: 'Status',
                colorval: Colors.black45,
                sizeval: 12,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonFormField(
                isExpanded: true,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.themeColor),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
                    hintText: 'Select status type',
                    fillColor: Colors.white),
                value: selectStatus,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please Select status type'
                    : "",
                items: statusList
                    .map((leaveType) => DropdownMenuItem(
                        value: leaveType,
                        child: robotoTextWidget(
                            textval: leaveType,
                            colorval: AppColor.themeColor,
                            sizeval: 12,
                            fontWeight: FontWeight.bold)))
                    .toList(),
                onChanged: (Object? value) {
                  setState(() {
                    selectStatus = value.toString();
                  });
                },
              ))
        ],
      ),
    );
  }

  imageListWidget() {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            robotoTextWidget(
                textval: vendorMeetingImage,
                colorval: Colors.black45,
                sizeval: 12,
                fontWeight: FontWeight.bold),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: imageList.length,
                itemBuilder: (context, position) {
                  return listItem(imageList[position], position);
                })
          ],
        ));
  }

  gatePassListWidget() {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          robotoTextWidget(
              textval: vendorGatePass,
              colorval: Colors.black45,
              sizeval: 12,
              fontWeight: FontWeight.bold),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.vendorGatePassLists.length,
              itemBuilder: (context, position) {
                return gatePasslistItem(
                    widget.vendorGatePassLists[position], position);
              })
        ]));
  }

  listItem(ImageModel imageList, int position) {
    return GestureDetector(
      onTap: () {
        selectedIndex = position;
        if (imageList.imageSelected == true) {
          selectImage(context, "1");
        } else {
          selectImage(context, "0");
        }
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  robotoTextWidget(
                      textval: imageList.imageName,
                      colorval: AppColor.blackColor,
                      sizeval: 12,
                      fontWeight: FontWeight.bold),
                  SvgPicture.asset(
                    imageList.imageSelected == true
                        ? 'assets/svg/tick_icon.svg'
                        : 'assets/svg/close_icon.svg',
                    width: 20,
                    height: 20,
                  )
                ]),
          )),
    );
  }

  gatePasslistItem(
      vendorGatePassPrefix.Response vendorGatePassList, int position) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            Checkbox(
              value: selectedPassIndex == position ? isChecked : false,
              onChanged: (bool? value) {
                setState(() {
                  selectedPassIndex = position;
                  isChecked = true;
                });
              },
              activeColor: Colors.blue,
              // Change the color of the checkbox when it is checked
              checkColor: Colors.white,
            ),
            Container(
              child: Column(
                children: [
                  vendorGatePassList.lifnr.isNotEmpty
                      ? robotoTextWidget(
                          textval: vendorGatePassList.lifnr,
                          colorval: AppColor.blackColor,
                          sizeval: 12,
                          fontWeight: FontWeight.bold)
                      : const SizedBox(
                          height: 1,
                        ),
                  robotoTextWidget(
                      textval: vendorGatePassList.name1,
                      colorval: AppColor.blackColor,
                      sizeval: 12,
                      fontWeight: FontWeight.bold),
                ],
              ),
            ), // Change the color of the checkmark inside the checkbox)
          ]),
        ));
  }

  void selectImage(BuildContext context, String value) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return value == "0"
              ? Wrap(
                  children: <Widget>[
                    ListTile(
                      title: robotoTextWidget(
                          textval: camera,
                          colorval: AppColor.themeColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                      onTap: () => {
                        imageSelector(context, camera),
                        Navigator.pop(context)
                      },
                    ),
                    ListTile(
                      title: robotoTextWidget(
                          textval: cancel,
                          colorval: AppColor.blackColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                      onTap: () => {Navigator.pop(context)},
                    ),
                  ],
                )
              : Wrap(
                  children: <Widget>[
                    ListTile(
                      title: robotoTextWidget(
                          textval: display,
                          colorval: AppColor.themeColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                      onTap: () => {
                        Navigator.pop(context),
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => ImageView(
                                    imagepath:
                                        imageList[selectedIndex!].imagePath)),
                            (route) => true)
                      },
                    ),
                    ListTile(
                      title: robotoTextWidget(
                          textval: change,
                          colorval: AppColor.themeColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                      onTap: () =>
                          {Navigator.pop(context), selectImage(context, "0")},
                    ),
                    ListTile(
                      title: robotoTextWidget(
                          textval: cancel,
                          colorval: AppColor.blackColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                      onTap: () => {Navigator.pop(context)},
                    ),
                  ],
                );
        });
  }

  Future imageSelector(BuildContext context, String pickerType) async {
    switch (pickerType) {
      case "gallery":

        /// GALLERY IMAGE PICKER
        imageFile = await ImagePicker.platform.getImageFromSource(
          source: ImageSource.gallery,
        );
        break;

      case "Camera": // CAMERA CAPTURE CODE
        imageFile = await ImagePicker.platform
            .getImageFromSource(source: ImageSource.camera);
        break;
    }

    if (imageFile != null) {
      setState(() {
        debugPrint("SELECTED IMAGE PICK   $imageFile");
        List<ImageModel> imageModel = [];
        imageModel.add(ImageModel(
            imageName: imageList[selectedIndex!].imageName,
            imagePath: imageFile.path,
            imageSelected: true));
        imageList.setAll(selectedIndex!, imageModel);

        if (imgCount == 0) {
          imgCount = 1;
        }
        if (imgCount == 1) {
          imgCount = 2;
        }
        print('imgCount====>$imgCount');
      });
    } else {
      print("You have not taken image");
    }
  }

  submitDailyReportWidget() {
    return GestureDetector(
        onTap: () {
          submitDailyReport();

        },
        child: Container(
            height: 50,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColor.themeColor),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: AppColor.whiteColor,
                      ),
                    )
                  : robotoTextWidget(
                      textval: submit,
                      colorval: Colors.white,
                      sizeval: 14,
                      fontWeight: FontWeight.bold),
            )));
  }

  void submitDailyReport() {
    print(
        'targetDateController======>${targetDateController.text.toString()}============>$selectedTargateDate');
    if (vendoreName.text.isEmpty) {
      Utility().showInSnackBar(value: searchByName, context: context);
    } else if (vendoreCode.text.isEmpty) {
      Utility().showInSnackBar(value: enterVendorCode, context: context);
    } else if (vendoreAddress.text.isEmpty) {
      Utility().showInSnackBar(value: enterVendorAddress, context: context);
    } else if (vendoreContac.text.isEmpty) {
      Utility().showInSnackBar(value: enterVendorContact, context: context);
    } else if (selectVisit.toString().isEmpty) {
      Utility().showInSnackBar(value: selectVisitAtStatus, context: context);
    } else if (responsiblePerson1.text.toString().isEmpty) {
      Utility().showInSnackBar(value: enterSapCode, context: context);
    } else if (agenda.text.toString().isEmpty) {
      Utility().showInSnackBar(value: enterAgenda, context: context);
    } else if (discussion.text.toString().isEmpty) {
      Utility().showInSnackBar(value: enterDiscussionPoint, context: context);
    } else if (targetDateController.text.toString().isEmpty) {
      Utility().showInSnackBar(value: selectTargetDat, context: context);
    } else if (statusType.toString().isEmpty && statusType == "Select Status") {
      Utility().showInSnackBar(value: selectStus, context: context);
    } else if (imgCount < 2) {
      Utility().showInSnackBar(value: attechImages, context: context);
    } else {
      setState(() {
        if (imageList[0].imageSelected) {
          img1 = Utility.getBase64FormateFile(imageList[0].imagePath);
        }
        if (imageList[1].imageSelected) {
          img2 = Utility.getBase64FormateFile(imageList[0].imagePath);
        }
        if (imageList[2].imageSelected) {
          img3 = Utility.getBase64FormateFile(imageList[0].imagePath);
        }
        if (imageList[3].imageSelected) {
          img4 = Utility.getBase64FormateFile(imageList[0].imagePath);
        }
        if (imageList[4].imageSelected) {
          img5 = Utility.getBase64FormateFile(imageList[0].imagePath);
        }

        if (selectedPassIndex != null) {
          if (widget.vendorGatePassLists[selectedPassIndex!].docno.isNotEmpty) {
            vendorGatePassDocNo =
                widget.vendorGatePassLists[selectedPassIndex!].docno;
          }

          if (widget.vendorGatePassLists[selectedPassIndex!].ort01.isNotEmpty) {
            vendorGatePassRegion =
                widget.vendorGatePassLists[selectedPassIndex!].ort01;
          }

          if (widget.vendorGatePassLists[selectedPassIndex!].ort01.isNotEmpty) {
            vendorGatePassCity =
                widget.vendorGatePassLists[selectedPassIndex!].ort02;
          }
          if (widget.vendorGatePassLists[selectedPassIndex!].stras.isNotEmpty) {
            vendorGatePassStreet =
                widget.vendorGatePassLists[selectedPassIndex!].stras;
          }
        }
        Utility().checkInternetConnection().then((connectionResult) {
          if (connectionResult) {
            SubmitDailyReportAPI();
          } else {
            Utility()
                .showInSnackBar(value: checkInternetConnection, context: context);
          }
        });

      });
    }
  }

  Future<void> SubmitDailyReportAPI() async {
    dailyReportModel = [];
    setState(() {
      isLoading = true;
    });
    if (_selectedType.toString() == vendor) {
      dailyReportModel.add(DailyReportModel(
          pros_vendor: '',
          vendor: _selectedType.toString(),
          name: vendoreName.text.toString(),
          addres: vendoreAddress.text.toString(),
          TELF2: vendoreContac.text.toString(),
          VISIT_AT: selectVisit.toString(),
          pernr1: responsiblePerson1.text.toString(),
          pernr2: responsiblePerson2.text.toString(),
          pernr3: responsiblePerson3.text.toString(),
          ACTIVITY: agenda.text.toString(),
          DISC: discussion.text.toString(),
          TGTDATE: targetDateController.text.toString(),
          STATUS: selectStatus.toString(),
          STREET: vendorGatePassStreet,
          REGION: vendorGatePassRegion,
          CITY1: vendorGatePassCity,
          CONTACT_P: vendoreCode.text.toString(),
          GATEPASS_NO: vendorGatePassDocNo,
          photo1: img1,
          photo2: img2,
          photo3: img3,
          photo4: img4,
          photo5: img5));
    } else {
      dailyReportModel.add(DailyReportModel(
          pros_vendor: _selectedType.toString(),
          vendor: '',
          name: vendoreName.text.toString(),
          addres: vendoreAddress.text.toString(),
          TELF2: vendoreContac.text.toString(),
          VISIT_AT: selectVisit.toString(),
          pernr1: responsiblePerson1.text.toString(),
          pernr2: responsiblePerson2.text.toString(),
          pernr3: responsiblePerson3.text.toString(),
          ACTIVITY: agenda.text.toString(),
          DISC: discussion.text.toString(),
          TGTDATE: selectedTargateDate.toString(),
          STATUS: selectStatus.toString(),
          STREET: vendorGatePassStreet,
          REGION: vendorGatePassRegion,
          CITY1: vendorGatePassCity,
          CONTACT_P: vendoreCode.text.toString(),
          GATEPASS_NO: vendorGatePassDocNo,
          photo1: img1,
          photo2: img2,
          photo3: img3,
          photo4: img4,
          photo5: img5));
    }
    String value = convert.jsonEncode(dailyReportModel).toString();
    print('value$value');
    var jsonData = null;
    dynamic response = await HTTP.get(DailyReportAPI(value));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      Utility().showToast(dailyReportSubmitted);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      Utility().showToast(somethingWentWrong);
      setState(() {
        isLoading = false;
      });
    }
  }

}
