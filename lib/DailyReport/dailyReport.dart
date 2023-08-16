import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
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
  String? _selectedType, selectVisit, selectStatus, selectedGatePass;
  String TypeSpinner = 'Select Visit At ', statusType = "Select Status";

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
  TextEditingController person1 = TextEditingController();
  TextEditingController person2 = TextEditingController();
  TextEditingController person3 = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController agenda = TextEditingController();
  TextEditingController discussion = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime datefrom = DateTime.now();
  String? indianFromDate, selectedFromDate;
  String dateTimeFormat = "dd/MM/yyyy";
  DateTime? pickedDate;
  List<ImageModel> imageList = [];
  var imageFile;
  int? selectedIndex, selectedPassIndex;
  bool isChecked = false, isGatePassListShown = false, isLoading = false;
  late SharedPreferences sharedPreferences;

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

    selectedFromDate = DateFormat(dateTimeFormat).format(DateTime.now());
    fromDateController.text = DateFormat(dateTimeFormat).format(DateTime.now());
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              radiobuttonWidget(),
              textVendorFeildWidget(
                "Vendor Name",
              ),
              textFieldWidget("Vendor Code", vendoreCode),
              textFieldWidget("Vendor Address", vendoreAddress),
              textFieldWidget("Vendor Contact N0", vendoreContac),
              dateTextFieldWidget("Current Date",
                  DateFormat("dd-MM-yyyy").format(DateTime.now())),
              visitAtSpinnerWidget(),
              textFieldWidget("Responsible person", person1),
              textFieldWidget("Responsible person 2", person2),
              textFieldWidget("Responsible person 3", person3),
              longTextFieldWidget("Agenda", agenda),
              longTextFieldWidget("Discussion", discussion),
              datePickerWidget(selectedFromDate!, fromDateController, "0"),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: Row(
              children: <Widget>[
                Radio(
                  value: "Vendor",
                  groupValue: _selectedType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                const Text(
                  'Vendor',
                  style: TextStyle(
                      color: AppColor.themeColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Row(
              children: <Widget>[
                Radio(
                  value: "Prospective Vendor",
                  groupValue: _selectedType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                const Flexible(
                  child: Text(
                    'Prospective Vendor',
                    style: TextStyle(
                        color: AppColor.themeColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  textVendorFeildWidget(String hinttxt) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              hinttxt,
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
            suggestions: vendorNameList
                .map(
                  (vendornamelist) =>
                      SearchFieldListItem<List<VenderList.Response>>(
                    vendornamelist.name1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        vendornamelist.name1,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            color: AppColor.themeColor),
                      ),
                    ),
                  ),
                )
                .toList(),
            searchInputDecoration: InputDecoration(
              hintText: "Search by " + hinttxt,
              hintStyle: const TextStyle(
                fontSize: 13,
                color: AppColor.themeColor,
              ),
              border: InputBorder.none,
            ),
            onSearchTextChanged: (serachValue) {
              if (serachValue.length > 2) {
                vendorNameListAPI(serachValue);
              }
              return null;
            },
            onSubmit: (String value) {
              setState(() {
                vendoreContac.text = vendorNameList[0].telf1;
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
          style: const TextStyle(color: AppColor.themeColor),
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

  Future<void> _selectDate(BuildContext context, String value) async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: value == "0"
            ? DateTime.now()
            : selectedFromDate !=
                    DateFormat(dateTimeFormat).format(DateTime.now())
                ? DateTime(2023)
                : DateTime.now(),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      String formattedDate = DateFormat(dateTimeFormat).format(pickedDate!);
      setState(() {
        if (value == "0") {
          selectedFromDate = DateFormat(dateTimeFormat).format(pickedDate!);
          fromDateController.text = formattedDate;
        }
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

  textFieldWidget(String hinttxt, TextEditingController visitPlace) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 15),
            child: robotoTextWidget(
                textval: hinttxt,
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
            style: const TextStyle(color: AppColor.themeColor),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Please Enter " + hinttxt,
              hintStyle: const TextStyle(
                  color: AppColor.themeColor,
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  longTextFieldWidget(String title, TextEditingController longtext) {
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
            style: const TextStyle(color: AppColor.themeColor),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Please Enter " + title,
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
      String fromTO, TextEditingController DateController, String value) {
    return GestureDetector(
      onTap: () {
        _selectDate(context, value);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: const robotoTextWidget(
                  textval: 'Target Date',
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
                        hintStyle: const TextStyle(color: AppColor.themeColor),
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
          Container(
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
                      title: const robotoTextWidget(
                          textval: 'Camera',
                          colorval: AppColor.themeColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                      onTap: () => {
                        imageSelector(context, "camera"),
                        Navigator.pop(context)
                      },
                    ),
                    ListTile(
                      title: const robotoTextWidget(
                          textval: 'Cancel',
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
                      title: const robotoTextWidget(
                          textval: 'Display',
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
                      title: const robotoTextWidget(
                          textval: 'Change',
                          colorval: AppColor.themeColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                      onTap: () =>
                          {Navigator.pop(context), selectImage(context, "0")},
                    ),
                    ListTile(
                      title: const robotoTextWidget(
                          textval: 'Cancel',
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

      case "camera": // CAMERA CAPTURE CODE
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
      });
    } else {
      print("You have not taken image");
    }
  }

  submitDailyReportWidget() {
    return GestureDetector(
        onTap: () {
          // signIn();
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
}
