// To parse this JSON data, do
//
//     final syncAndroidToSapResponse = syncAndroidToSapResponseFromJson(jsonString);

import 'dart:convert';

SyncAndroidToSapResponse syncAndroidToSapResponseFromJson(String str) =>
    SyncAndroidToSapResponse.fromJson(json.decode(str));

String syncAndroidToSapResponseToJson(SyncAndroidToSapResponse data) =>
    json.encode(data.toJson());

class SyncAndroidToSapResponse {
  List<Activeemployee> activeemployee;
  List<Leavebalance> leavebalance;
  List<Attendanceemp> attendanceemp;
  List<Leaveemp> leaveemp;
  List<Odemp> odemp;
  List<PendingTask> pendingtask;
  List<Pendingleave> pendingleave;
  List<Pendingod> pendingod;
  List<Country> country;
  List<District> region;
  List<District> district;
  List<Tehsil> tehsil;
  List<Taxcode> taxcode;
  List<Exptype> exptype;
  List<Curr> curr;
  String test;

  SyncAndroidToSapResponse({
    required this.activeemployee,
    required this.leavebalance,
    required this.attendanceemp,
    required this.leaveemp,
    required this.pendingleave,
    required this.odemp,
    required this.pendingtask,
    required this.pendingod,
    required this.country,
    required this.region,
    required this.district,
    required this.tehsil,
    required this.taxcode,
    required this.exptype,
    required this.curr,
    required this.test,
  });

 // json["response"]!=null?List<Response>.from(json["response"].map((x) => Response.fromJson(x))):[]

  factory SyncAndroidToSapResponse.fromJson(Map<String, dynamic> json) =>
      SyncAndroidToSapResponse(
        activeemployee: List<Activeemployee>.from(
            json["activeemployee"].map((x) => Activeemployee.fromJson(x))),
        leavebalance: json["leavebalance"]!=null?List<Leavebalance>.from(
            json["leavebalance"].map((x) => Leavebalance.fromJson(x))):[],
        attendanceemp: List<Attendanceemp>.from(
            json["attendanceemp"].map((x) => Attendanceemp.fromJson(x))),
        pendingleave: List<Pendingleave>.from(json["pendingleave"].map((x) => Pendingleave.fromJson(x))),
        leaveemp: List<Leaveemp>.from(
            json["leaveemp"].map((x) => Leaveemp.fromJson(x))),
        pendingod: List<Pendingod>.from(json["pendingod"].map((x) => Pendingod.fromJson(x))),
        odemp: List<Odemp>.from(json["odemp"].map((x) => Odemp.fromJson(x))),
        pendingtask: List<PendingTask>.from(
            json["pendingtask"].map((x) => PendingTask.fromJson(x))),
        country:
            List<Country>.from(json["country"].map((x) => Country.fromJson(x))),
        region: List<District>.from(
            json["region"].map((x) => District.fromJson(x))),
        district: List<District>.from(
            json["district"].map((x) => District.fromJson(x))),
        tehsil:
            List<Tehsil>.from(json["tehsil"].map((x) => Tehsil.fromJson(x))),
        taxcode:
            List<Taxcode>.from(json["taxcode"].map((x) => Taxcode.fromJson(x))),
        exptype:
            List<Exptype>.from(json["exptype"].map((x) => Exptype.fromJson(x))),
        curr: List<Curr>.from(json["curr"].map((x) => Curr.fromJson(x))),
        test: json["test"],
      );

  Map<String, dynamic> toJson() => {
        "activeemployee":
            List<dynamic>.from(activeemployee.map((x) => x.toJson())),
        "leavebalance": List<dynamic>.from(leavebalance.map((x) => x.toJson())),
        "attendanceemp": List<dynamic>.from(attendanceemp.map((x) => x.toJson())),
        "pendingleave": List<dynamic>.from(pendingleave.map((x) => x.toJson())),
        "leaveemp": List<dynamic>.from(leaveemp.map((x) => x.toJson())),
        "odemp": List<dynamic>.from(odemp.map((x) => x.toJson())),
        "pendingtask": List<dynamic>.from(pendingtask.map((x) => x.toJson())),
        "pendingod": List<dynamic>.from(pendingod.map((x) => x.toJson())),
        "country": List<dynamic>.from(country.map((x) => x.toJson())),
        "region": List<dynamic>.from(region.map((x) => x.toJson())),
        "district": List<dynamic>.from(district.map((x) => x.toJson())),
        "tehsil": List<dynamic>.from(tehsil.map((x) => x.toJson())),
        "taxcode": List<dynamic>.from(taxcode.map((x) => x.toJson())),
        "exptype": List<dynamic>.from(exptype.map((x) => x.toJson())),
        "curr": List<dynamic>.from(curr.map((x) => x.toJson())),
        "test": test,
      };
}

class PendingTask {
  String asgnr1;
  String mrcDate1;
  String comDateFrom1;
  String comDateTo1;
  String mrct1;
  String chker1;
  String mandt;
  String srno;
  String dno;
  String depName;
  String mrct;
  String agenda;
  String agenda1;
  String discPoint;
  String comDateFrom;
  String comWeekFrom;
  String comDateTo;
  String comWeekTo;
  String resPersonId;
  String rpn;
  String cpid;
  String cpn;
  String cdate;
  String mrcDate;
  String mrcTime;
  String docEnDate;
  String docEnTime;
  String uname;
  String ipAdd;
  String status;
  String comEnDate;
  String comEnTime;
  String comUname;
  String comIpadd;
  String asgnr;
  String chker;
  String remark;
  String sta;
  String matnr;
  String menge;
  String extDate;
  String extWeek;
  String extCount;
  String taskNo;
  String chgDate;
  String chgUname;
  String chgIpadd;
  String chgTime;
  String cdate1;
  String comUname1;
  String ipAdd1;
  String ctime;
  String helpFrm;
  String taskTyp;
  String refTaskMaster;
  String request;
  String grp;
  String grp2;
  String grp3;
  String pa30TaskNo;
  String wbsElement;
  String tenderNo;
  String matColor;
  String refTask;
  String zpriority1;
  String reopen;

  PendingTask({
    required this.asgnr1,
    required this.mrcDate1,
    required this.comDateFrom1,
    required this.comDateTo1,
    required this.mrct1,
    required this.chker1,
    required this.mandt,
    required this.srno,
    required this.dno,
    required this.depName,
    required this.mrct,
    required this.agenda,
    required this.agenda1,
    required this.discPoint,
    required this.comDateFrom,
    required this.comWeekFrom,
    required this.comDateTo,
    required this.comWeekTo,
    required this.resPersonId,
    required this.rpn,
    required this.cpid,
    required this.cpn,
    required this.cdate,
    required this.mrcDate,
    required this.mrcTime,
    required this.docEnDate,
    required this.docEnTime,
    required this.uname,
    required this.ipAdd,
    required this.status,
    required this.comEnDate,
    required this.comEnTime,
    required this.comUname,
    required this.comIpadd,
    required this.asgnr,
    required this.chker,
    required this.remark,
    required this.sta,
    required this.matnr,
    required this.menge,
    required this.extDate,
    required this.extWeek,
    required this.extCount,
    required this.taskNo,
    required this.chgDate,
    required this.chgUname,
    required this.chgIpadd,
    required this.chgTime,
    required this.cdate1,
    required this.comUname1,
    required this.ipAdd1,
    required this.ctime,
    required this.helpFrm,
    required this.taskTyp,
    required this.refTaskMaster,
    required this.request,
    required this.grp,
    required this.grp2,
    required this.grp3,
    required this.pa30TaskNo,
    required this.wbsElement,
    required this.tenderNo,
    required this.matColor,
    required this.refTask,
    required this.zpriority1,
    required this.reopen,
  });

  factory PendingTask.fromJson(Map<String, dynamic> json) => PendingTask(
        asgnr1: json["asgnr1"],
        mrcDate1: json["mrc_date1"],
        comDateFrom1: json["com_date_from1"],
        comDateTo1: json["com_date_to1"],
        mrct1: json["mrct1"],
        chker1: json["chker1"],
        mandt: json["mandt"],
        srno: json["srno"],
        dno: json["dno"],
        depName: json["dep_name"],
        mrct: json["mrct"],
        agenda: json["agenda"],
        agenda1: json["agenda1"],
        discPoint: json["disc_point"],
        comDateFrom: json["com_date_from"],
        comWeekFrom: json["com_week_from"],
        comDateTo: json["com_date_to"],
        comWeekTo: json["com_week_to"],
        resPersonId: json["res_person_id"],
        rpn: json["rpn"],
        cpid: json["cpid"],
        cpn: json["cpn"],
        cdate: json["cdate"],
        mrcDate: json["mrc_date"],
        mrcTime: json["mrc_time"],
        docEnDate: json["doc_en_date"],
        docEnTime: json["doc_en_time"],
        uname: json["uname"],
        ipAdd: json["ip_add"],
        status: json["status"],
        comEnDate: json["com_en_date"],
        comEnTime: json["com_en_time"],
        comUname: json["com_uname"],
        comIpadd: json["com_ipadd"],
        asgnr: json["asgnr"],
        chker: json["chker"],
        remark: json["remark"],
        sta: json["sta"],
        matnr: json["matnr"],
        menge: json["menge"],
        extDate: json["ext_date"],
        extWeek: json["ext_week"],
        extCount: json["ext_count"],
        taskNo: json["task_no"],
        chgDate: json["chg_date"],
        chgUname: json["chg_uname"],
        chgIpadd: json["chg_ipadd"],
        chgTime: json["chg_time"],
        cdate1: json["cdate1"],
        comUname1: json["com_uname1"],
        ipAdd1: json["ip_add1"],
        ctime: json["ctime"],
        helpFrm: json["help_frm"],
        taskTyp: json["task_typ"],
        refTaskMaster: json["ref_task_master"],
        request: json["request"],
        grp: json["grp"],
        grp2: json["grp2"],
        grp3: json["grp3"],
        pa30TaskNo: json["pa30_task_no"],
        wbsElement: json["wbs_element"],
        tenderNo: json["tender_no"],
        matColor: json["mat_color"],
        refTask: json["ref_task"],
        zpriority1: json["zpriority1"],
        reopen: json["reopen"],
      );


  factory PendingTask.fromMap(Map<String, dynamic> map) => PendingTask(
    asgnr1: map["asgnr1"],
    mrcDate1: map["mrc_date1"],
    comDateFrom1: map["com_date_from1"],
    comDateTo1: map["com_date_to1"],
    mrct1: map["mrct1"],
    chker1: map["chker1"],
    mandt: map["mandt"],
    srno: map["srno"],
    dno: map["dno"],
    depName: map["dep_name"],
    mrct: map["mrct"],
    agenda: map["agenda"],
    agenda1: map["agenda1"],
    discPoint: map["disc_point"],
    comDateFrom: map["com_date_from"],
    comWeekFrom: map["com_week_from"],
    comDateTo: map["com_date_to"],
    comWeekTo: map["com_week_to"],
    resPersonId: map["res_person_id"],
    rpn: map["rpn"],
    cpid: map["cpid"],
    cpn: map["cpn"],
    cdate: map["cdate"],
    mrcDate: map["mrc_date"],
    mrcTime: map["mrc_time"],
    docEnDate: map["doc_en_date"],
    docEnTime: map["doc_en_time"],
    uname: map["uname"],
    ipAdd: map["ip_add"],
    status: map["status"],
    comEnDate: map["com_en_date"],
    comEnTime: map["com_en_time"],
    comUname: map["com_uname"],
    comIpadd: map["com_ipadd"],
    asgnr: map["asgnr"],
    chker: map["chker"],
    remark: map["remark"],
    sta: map["sta"],
    matnr: map["matnr"],
    menge: map["menge"],
    extDate: map["ext_date"],
    extWeek: map["ext_week"],
    extCount: map["ext_count"],
    taskNo: map["task_no"],
    chgDate: map["chg_date"],
    chgUname: map["chg_uname"],
    chgIpadd: map["chg_ipadd"],
    chgTime: map["chg_time"],
    cdate1: map["cdate1"],
    comUname1: map["com_uname1"],
    ipAdd1: map["ip_add1"],
    ctime: map["ctime"],
    helpFrm: map["help_frm"],
    taskTyp: map["task_typ"],
    refTaskMaster: map["ref_task_master"],
    request: map["request"],
    grp: map["grp"],
    grp2: map["grp2"],
    grp3: map["grp3"],
    pa30TaskNo: map["pa30_task_no"],
    wbsElement: map["wbs_element"],
    tenderNo: map["tender_no"],
    matColor: map["mat_color"],
    refTask: map["ref_task"],
    zpriority1: map["zpriority1"],
    reopen: map["reopen"],
  );

  Map<String, dynamic> toJson() => {
        "asgnr1": asgnr1,
        "mrc_date1": mrcDate1,
        "com_date_from1": comDateFrom1,
        "com_date_to1": comDateTo1,
        "mrct1": mrct1,
        "chker1": chker1,
        "mandt": mandt,
        "srno": srno,
        "dno": dno,
        "dep_name": depName,
        "mrct": mrct,
        "agenda": agenda,
        "agenda1": agenda1,
        "disc_point": discPoint,
        "com_date_from": comDateFrom,
        "com_week_from": comWeekFrom,
        "com_date_to": comDateTo,
        "com_week_to": comWeekTo,
        "res_person_id": resPersonId,
        "rpn": rpn,
        "cpid": cpid,
        "cpn": cpn,
        "cdate": cdate,
        "mrc_date": mrcDate,
        "mrc_time": mrcTime,
        "doc_en_date": docEnDate,
        "doc_en_time": docEnTime,
        "uname": uname,
        "ip_add": ipAdd,
        "status": status,
        "com_en_date": comEnDate,
        "com_en_time": comEnTime,
        "com_uname": comUname,
        "com_ipadd": comIpadd,
        "asgnr": asgnr,
        "chker": chker,
        "remark": remark,
        "sta": sta,
        "matnr": matnr,
        "menge": menge,
        "ext_date": extDate,
        "ext_week": extWeek,
        "ext_count": extCount,
        "task_no": taskNo,
        "chg_date": chgDate,
        "chg_uname": chgUname,
        "chg_ipadd": chgIpadd,
        "chg_time": chgTime,
        "cdate1": cdate1,
        "com_uname1": comUname1,
        "ip_add1": ipAdd1,
        "ctime": ctime,
        "help_frm": helpFrm,
        "task_typ": taskTyp,
        "ref_task_master": refTaskMaster,
        "request": request,
        "grp": grp,
        "grp2": grp2,
        "grp3": grp3,
        "pa30_task_no": pa30TaskNo,
        "wbs_element": wbsElement,
        "tender_no": tenderNo,
        "mat_color": matColor,
        "ref_task": refTask,
        "zpriority1": zpriority1,
        "reopen": reopen,
      };
}


class Pendingleave {
  int leavNo;
  String horo;
  int pernr;
  String name;
  String dedQuta1;
  DateTime levFrm;
  String levFr;
  DateTime levTo;
  String levT;
  String timFrm;
  String timTo;
  String reason;
  int adminChrg1;
  String nameperl;
  int adminChrg2;
  String nameperl2;
  String nameperl3;
  String nameperl4;
  String person;
  String directIndirect;

  Pendingleave({
    required this.leavNo,
    required this.horo,
    required this.pernr,
    required this.name,
    required this.dedQuta1,
    required this.levFrm,
    required this.levFr,
    required this.levTo,
    required this.levT,
    required this.timFrm,
    required this.timTo,
    required this.reason,
    required this.adminChrg1,
    required this.nameperl,
    required this.adminChrg2,
    required this.nameperl2,
    required this.nameperl3,
    required this.nameperl4,
    required this.person,
    required this.directIndirect,
  });

  factory Pendingleave.fromJson(Map<String, dynamic> json) => Pendingleave(
    leavNo: json["leavNo"],
    horo: json["horo"],
    pernr: json["pernr"],
    name: json["name"],
    dedQuta1: json["dedQuta1"],
    levFrm: DateTime.parse(json["levFrm"]),
    levFr: json["levFr"],
    levTo: DateTime.parse(json["levTo"]),
    levT: json["levT"],
    timFrm: json["timFrm"],
    timTo: json["timTo"],
    reason: json["reason"],
    adminChrg1: json["adminChrg1"],
    nameperl: json["nameperl"],
    adminChrg2: json["adminChrg2"],
    nameperl2: json["nameperl2"],
    nameperl3: json["nameperl3"],
    nameperl4: json["nameperl4"],
    person: json["person"],
    directIndirect: json["directIndirect"],
  );

  factory Pendingleave.fromMap(Map<String, dynamic> map) => Pendingleave(
    leavNo: map["leavNo"],
    horo: map["horo"],
    pernr: map["pernr"],
    name: map["name"],
    dedQuta1: map["dedQuta1"],
    levFrm: DateTime.parse(map["levFrm"]),
    levFr: map["levFr"],
    levTo: DateTime.parse(map["levTo"]),
    levT: map["levT"],
    timFrm: map["timFrm"],
    timTo: map["timTo"],
    reason: map["reason"],
    adminChrg1: map["adminChrg1"],
    nameperl: map["nameperl"],
    adminChrg2: map["adminChrg2"],
    nameperl2: map["nameperl2"],
    nameperl3: map["nameperl3"],
    nameperl4: map["nameperl4"],
    person: map["person"],
    directIndirect: map["directIndirect"],

  );

  Map<String, dynamic> toJson() => {
    "leavNo": leavNo,
    "horo": horo,
    "pernr": pernr,
    "name": name,
    "dedQuta1": dedQuta1,
    "levFrm": "${levFrm.year.toString().padLeft(4, '0')}-${levFrm.month.toString().padLeft(2, '0')}-${levFrm.day.toString().padLeft(2, '0')}",
    "levFr": levFr,
    "levTo": "${levTo.year.toString().padLeft(4, '0')}-${levTo.month.toString().padLeft(2, '0')}-${levTo.day.toString().padLeft(2, '0')}",
    "levT": levT,
    "timFrm": timFrm,
    "timTo": timTo,
    "reason": reason,
    "adminChrg1": adminChrg1,
    "nameperl": nameperl,
    "adminChrg2": adminChrg2,
    "nameperl2": nameperl2,
    "nameperl3": nameperl3,
    "nameperl4": nameperl4,
    "person": person,
    "directIndirect": directIndirect,
  };

  @override
  String toString() {
    return 'Pendingleave{leavNo: $leavNo, horo: $horo, pernr: $pernr, name: $name, dedQuta1: $dedQuta1, levFrm: $levFrm, levFr: $levFr, levTo: $levTo, levT: $levT, timFrm: $timFrm, timTo: $timTo, reason: $reason, adminChrg1: $adminChrg1, nameperl: $nameperl, adminChrg2: $adminChrg2, nameperl2: $nameperl2, nameperl3: $nameperl3, nameperl4: $nameperl4, person: $person, directIndirect: $directIndirect}';
  }
}

class Pendingod {
  String odno;
  String horo;
  String ename;
  String odstdateC;
  String odedateC;
  String atnStatus;
  String vplace;
  String purpose1;
  String purpose2;
  String purpose3;
  String remark;
  String directIndirect;

  Pendingod({
    required this.odno,
    required this.horo,
    required this.ename,
    required this.odstdateC,
    required this.odedateC,
    required this.atnStatus,
    required this.vplace,
    required this.purpose1,
    required this.purpose2,
    required this.purpose3,
    required this.remark,
    required this.directIndirect,
  });

  factory Pendingod.fromJson(Map<String, dynamic> json) => Pendingod(
    odno: json["odno"],
    horo: json["horo"],
    ename: json["ename"],
    odstdateC: json["odstdateC"],
    odedateC: json["odedateC"],
    atnStatus: json["atnStatus"],
    vplace: json["vplace"],
    purpose1: json["purpose1"],
    purpose2: json["purpose2"],
    purpose3: json["purpose3"],
    remark: json["remark"],
    directIndirect: json["directIndirect"],
  );

  factory Pendingod.fromMap(Map<String, dynamic> map) => Pendingod(
    odno: map["odno"],
    horo: map["horo"],
    ename: map["ename"],
    odstdateC: map["odstdateC"],
    odedateC: map["odedateC"],
    atnStatus: map["atnStatus"],
    vplace: map["vplace"],
    purpose1: map["purpose1"],
    purpose2: map["purpose2"],
    purpose3: map["purpose3"],
    remark: map["remark"],
    directIndirect: map["directIndirect"],
  );

  Map<String, dynamic> toJson() => {
    "odno": odno,
    "horo": horo,
    "ename": ename,
    "odstdateC": odstdateC,
    "odedateC": odedateC,
    "atnStatus": atnStatus,
    "vplace": vplace,
    "purpose1": purpose1,
    "purpose2": purpose2,
    "purpose3": purpose3,
    "remark": remark,
    "directIndirect": directIndirect,
  };
}

class Activeemployee {
  int pernr;
  String ename;
  String btrtl;
  String btext;

  Activeemployee({
    required this.pernr,
    required this.ename,
    required this.btrtl,
    required this.btext,
  });

  factory Activeemployee.fromJson(Map<String, dynamic> json) => Activeemployee(
        pernr: json["pernr"],
        ename: json["ename"],
        btrtl: json["btrtl"],
        btext: json["btext"],
      );

  factory Activeemployee.fromMap(Map<String, dynamic> map) => Activeemployee(
    pernr: map["pernr"],
    ename: map["ename"],
    btrtl: map["btrtl"],
    btext: map["btext"],
  );

  Map<String, dynamic> toJson() => {
        "pernr": pernr,
        "ename": ename,
        "btrtl": btrtl,
        "btext": btext,
      };

  @override
  String toString() {
    return 'Activeemployee{pernr: $pernr, ename: $ename, btrtl: $btrtl, btext: $btext}';
  }
}

class Attendanceemp {
  String begdat;
  String indz;
  String iodz;
  String totdz;
  String atnStatus;
  String leaveTyp;

  Attendanceemp({
    required this.begdat,
    required this.indz,
    required this.iodz,
    required this.totdz,
    required this.atnStatus,
    required this.leaveTyp,
  });

  factory Attendanceemp.fromJson(Map<String, dynamic> json) => Attendanceemp(
        begdat: json["begdat"],
        indz: json["indz"],
        iodz: json["iodz"],
        totdz: json["totdz"],
        atnStatus: json["atn_status"],
        leaveTyp: json["leave_typ"],
      );

  factory Attendanceemp.fromMap(Map<String, dynamic> map) => Attendanceemp(
    begdat: map["begdat"],
    indz: map["indz"],
    iodz: map["iodz"],
    totdz: map["totdz"],
    atnStatus: map["atn_status"],
    leaveTyp: map["leave_typ"],
  );

  Map<String, dynamic> toJson() => {
        "begdat": begdat,
        "indz": indz,
        "iodz": iodz,
        "totdz": totdz,
        "atn_status":atnStatus,
        "leave_typ": leaveTyp,
      };
}


class Country {
  String land1;
  String landx;

  Country({
    required this.land1,
    required this.landx,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        land1: json["land1"],
        landx: json["landx"],
      );

  Map<String, dynamic> toJson() => {
        "land1": land1,
        "landx": landx,
      };
}

class Curr {
  String waers;
  String ltext;

  Curr({
    required this.waers,
    required this.ltext,
  });

  factory Curr.fromJson(Map<String, dynamic> json) => Curr(
        waers: json["waers"],
        ltext: json["ltext"],
      );

  Map<String, dynamic> toJson() => {
        "waers": waers,
        "ltext": ltext,
      };
}

class District {
  String land1;
  String regio;
  String? cityc;
  String bezei;
  String? bland;

  District({
    required this.land1,
    required this.regio,
    this.cityc,
    required this.bezei,
    this.bland,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
        land1: json["land1"],
        regio: json["regio"],
        cityc: json["cityc"],
        bezei: json["bezei"],
        bland: json["bland"],
      );

  Map<String, dynamic> toJson() => {
        "land1": land1,
        "regio": regio,
        "cityc": cityc,
        "bezei": bezei,
        "bland": bland,
      };
}

class Exptype {
  String spkzl;
  String sptxt;

  Exptype({
    required this.spkzl,
    required this.sptxt,
  });

  factory Exptype.fromJson(Map<String, dynamic> json) => Exptype(
        spkzl: json["spkzl"],
        sptxt: json["sptxt"],
      );

  Map<String, dynamic> toJson() => {
        "spkzl": spkzl,
        "sptxt": sptxt,
      };
}

class Leavebalance {
  String leaveType;
  double leaveBal;

  Leavebalance({
    required this.leaveType,
    required this.leaveBal,
  });

  factory Leavebalance.fromJson(Map<String, dynamic> json) => Leavebalance(
        leaveType: json["leaveType"],
        leaveBal: json["leaveBal"]?.toDouble(),
      );
  factory Leavebalance.fromMap(Map<String, dynamic> map) => Leavebalance(
    leaveType: map["leaveType"],
    leaveBal: map["leaveBal"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
        "leaveType": leaveType,
        "leaveBal": leaveBal,
      };

  @override
  String toString() {
    return 'Leavebalance{leaveType: $leaveType, leaveBal: $leaveBal}';
  }
}

class Leaveemp {
  String leavNo;
  String horo;
  String levFrm;
  String levTo;
  String dedQuta1;
  String levTyp;
  String apphod;
  String dele;
  String reason;

  Leaveemp({
    required this.leavNo,
    required this.horo,
    required this.levFrm,
    required this.levTo,
    required this.dedQuta1,
    required this.levTyp,
    required this.apphod,
    required this.dele,
    required this.reason,
  });

  factory Leaveemp.fromJson(Map<String, dynamic> json) => Leaveemp(
        leavNo: json["leav_no"]?? "",
        horo: json["horo"]?? "",
        levFrm: json["lev_frm"]?? "",
        levTo: json["lev_to"]?? "",
        dedQuta1: json["ded_quta1"]?? "",
        levTyp: json["lev_typ"] ?? "",
        apphod: json["apphod"]?? "",
        dele: json["dele"]?? "",
        reason: json["reason"]?? "",
      );

  factory Leaveemp.fromMap(Map<String, dynamic> map) => Leaveemp(
    leavNo: map["leav_no"]?? "",
    horo: map["horo"]?? "",
    levFrm: map["lev_frm"]?? "",
    levTo: map["lev_to"]?? "",
    dedQuta1: map["ded_quta1"]?? "",
    levTyp: map["lev_typ"] ?? "",
    apphod: map["apphod"]?? "",
    dele: map["dele"]?? "",
    reason: map["reason"]?? "",

  );


  Map<String, dynamic> toJson() => {
        "leav_no": leavNo,
        "horo": horo,
        "lev_frm": levFrm,
        "lev_to": levTo,
        "ded_quta1": dedQuta1,
        "lev_typ": levTyp,
        "apphod":apphod,
        "dele": dele,
        "reason": reason,
      };

  @override
  String toString() {
    return '{leavNo: $leavNo, horo: $horo, levFrm: $levFrm, levTo: $levTo, dedQuta1: $dedQuta1, levTyp: $levTyp, apphod: $apphod, dele: $dele, reason: $reason}';
  }
}



class Odemp {
  String odno;
  String horo;
  String ename;
  String odstdateC;
  String odedateC;
  String odaprdtC;
  String atnStatus;
  String vplace;
  String purpose1;
  String purpose2;
  String purpose3;
  String remark;
  String directIndirect;

  Odemp({
    required this.odno,
    required this.horo,
    required this.ename,
    required this.odstdateC,
    required this.odedateC,
    required this.odaprdtC,
    required this.atnStatus,
    required this.vplace,
    required this.purpose1,
    required this.purpose2,
    required this.purpose3,
    required this.remark,
    required this.directIndirect,
  });

  factory Odemp.fromJson(Map<String, dynamic> json) => Odemp(
        odno: json["odno"],
        horo: json["horo"],
        ename: json["ename"],
        odstdateC: json["odstdate_c"],
        odedateC: json["odedate_c"],
        odaprdtC: json["odaprdt_c"],
        atnStatus: json["atn_status"],
        vplace: json["vplace"],
        purpose1: json["purpose1"],
        purpose2: json["purpose2"],
        purpose3: json["purpose3"],
        remark: json["remark"],
        directIndirect: json["direct_indirect"],
      );

  factory Odemp.fromMap(Map<String, dynamic> map) => Odemp(
    odno: map["odno"],
    horo: map["horo"],
    ename: map["ename"],
    odstdateC: map["odstdate_c"],
    odedateC: map["odedate_c"],
    odaprdtC: map["odaprdt_c"],
    atnStatus: map["atn_status"],
    vplace: map["vplace"],
    purpose1: map["purpose1"],
    purpose2: map["purpose2"],
    purpose3: map["purpose3"],
    remark: map["remark"],
    directIndirect: map["direct_indirect"],

  );

  Map<String, dynamic> toJson() => {
        "odno": odno,
        "horo": horo,
        "ename": ename,
        "odstdate_c": odstdateC,
        "odedate_c": odedateC,
        "odaprdt_c": odaprdtC,
        "atn_status": atnStatus,
        "vplace": vplace,
        "purpose1": purpose1,
        "purpose2": purpose2,
        "purpose3": purpose3,
        "remark": remark,
        "direct_indirect": directIndirect,
      };

  @override
  String toString() {
    return 'Odemp{odno: $odno, horo: $horo, ename: $ename, odstdateC: $odstdateC, odedateC: $odedateC, odaprdtC: $odaprdtC, atnStatus: $atnStatus, vplace: $vplace, purpose1: $purpose1, purpose2: $purpose2, purpose3: $purpose3, remark: $remark, directIndirect: $directIndirect}';
  }
}

class Taxcode {
  String mandt;
  String taxCode;
  String text;

  Taxcode({
    required this.mandt,
    required this.taxCode,
    required this.text,
  });

  factory Taxcode.fromJson(Map<String, dynamic> json) => Taxcode(
        mandt: json["mandt"],
        taxCode: json["tax_code"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "mandt": mandt,
        "tax_code": taxCode,
        "text": text,
      };

  @override
  String toString() {
    return 'Taxcode{mandt: $mandt, taxCode: $taxCode, text: $text}';
  }
}

class Tehsil {
  Land1 land1;
  String regio;
  String district;
  String tehsil;
  String tehsilText;

  Tehsil({
    required this.land1,
    required this.regio,
    required this.district,
    required this.tehsil,
    required this.tehsilText,
  });

  factory Tehsil.fromJson(Map<String, dynamic> json) => Tehsil(
        land1: land1Values.map[json["land1"]]!,
        regio: json["regio"],
        district: json["district"],
        tehsil: json["tehsil"],
        tehsilText: json["tehsil_text"],
      );

  Map<String, dynamic> toJson() => {
        "land1": land1Values.reverse[land1],
        "regio": regio,
        "district": district,
        "tehsil": tehsil,
        "tehsil_text": tehsilText,
      };

  @override
  String toString() {
    return 'Tehsil{land1: $land1, regio: $regio, district: $district, tehsil: $tehsil, tehsilText: $tehsilText}';
  }
}

enum Land1 { IN, NP }

final land1Values = EnumValues({"IN": Land1.IN, "NP": Land1.NP});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
