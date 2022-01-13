import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:teletip_app/app_colors.dart';
import 'package:teletip_app/config.dart';
import 'package:teletip_app/models/get_doctor_res.dart';
import 'package:teletip_app/pages/messagesDetails/message_details.dart';
import 'package:teletip_app/services/api_service.dart';
import 'package:teletip_app/services/shared_service.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({Key? key}) : super(key: key);

  @override
  _DoctorPageState createState() => _DoctorPageState();
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class _DoctorPageState extends State<DoctorPage> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFromKey = GlobalKey<FormState>();
  int type = 0;
  String doctorName = "";
  String dropdownValue = 'Seç';
  String dropdownValue2 = 'Seç';
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  var listeProf = <String>[
    'Seç',
    'Bel Fıtığı',
    'Boyun Fıtığı',
    'Omurilik Felci',
    'Optik',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF142A3B),
      body: ProgressHUD(
        child: Form(
          key: globalFromKey,
          child: SingleChildScrollView(child: _main(context)),
        ),
        key: UniqueKey(),
        inAsyncCall: isAPIcallProcess,
        opacity: 0.3,
      ),
    );
  }

  Widget _main(context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: type != 0
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    type != 0
                        ? SizedBox(
                            height: 45,
                            width: 138,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      type = 0;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.backspace,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Center(),
                    const SizedBox(
                      height: 45,
                      child: Text(
                        'Doktor Arama',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Color(0xFFECF1FF),
                          letterSpacing: 1,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            Container(
              height: 1,
              decoration: const BoxDecoration(color: Colors.white70),
            ),
            type == 0
                ? typeZero()
                : type == 1
                    ? typeOne()
                    : type == 2
                        ? typeTwo()
                        : typeThree()
          ],
        ),
      ),
    );
  }

  Widget typeZero() {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          button(() {
            setState(() {
              type = 2;
            });
          }, "Ana bilim dalına göre arama", Icons.medical_services),
          SizedBox(
            height: size.height * 0.05,
          ),
          button(() {
            setState(() {
              type = 3;
            });
          }, "uzmanlık alanına göre arama", Icons.airline_seat_flat),
          SizedBox(
            height: size.height * 0.05,
          ),
          button(() {
            setState(() {
              type = 1;
            });
          }, "İSME GÖRE  ARAMA", Icons.search)
        ],
      ),
    );
  }

  Widget typeOne() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        FormHelper.inputFieldWidget(
            context, const Icon(Icons.search), "Doctor", "Doktor Adı yazınız",
            (onValidateVal) {
          return null;
        }, (onSavedVal) {
          doctorName = onSavedVal;
        }, onChange: (val) {
          setState(() {
            doctorName = val;
          });
        },
            borderFocusColor: Colors.white,
            prefixIconColor: Colors.white,
            borderColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.white.withOpacity(0.7),
            borderRadius: 10),
        doctorName != "" ? getDoctorbyName(doctorName) : Center(),
      ],
    );
  }

  Widget typeTwo() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        DropdownButton<String>(
          dropdownColor: appPrimaryColor,
          value: dropdownValue,
          elevation: 16,
          style: const TextStyle(color: Colors.white),
          underline: Container(
            height: 2,
            color: Colors.white,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: <String>[
            'Seç',
            'Anatomi',
            'Fizyoloji',
            'Genel Cerrahi',
            'Onkoloji',
            'Dermatoloji'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        dropdownValue != "Seç" ? getMajorListB(dropdownValue) : Center(),
      ],
    );
  }

  Widget typeThree() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        DropdownButton<String>(
          dropdownColor: appPrimaryColor,
          value: dropdownValue2,
          elevation: 16,
          style: const TextStyle(color: Colors.white),
          underline: Container(
            height: 2,
            color: Colors.white,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue2 = newValue!;
            });
          },
          items: listeProf.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        dropdownValue2 != "Seç"
            ? getMajorListA(listeProf.indexOf(dropdownValue2).toString())
            : Center(),
      ],
    );
  }

  Widget getMajorListA(dropdownValue) {
    return FutureBuilder(
        future: APIService.getDoctorA(dropdownValue),
        builder: (BuildContext ctx, AsyncSnapshot<GetDoctorRes> snapshot) =>
            snapshot.hasData
                ? Column(
                    children: [
                      SizedBox(
                        height: 500,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.body.length,
                            itemBuilder: (BuildContext context, index) =>
                                InkWell(
                                  child: Container(
                                      height: 450,
                                      width: 300,
                                      padding: const EdgeInsets.only(
                                          right: 30, left: 30, top: 45),
                                      margin: const EdgeInsets.only(
                                          right: 30, left: 30, top: 45),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(1, 9),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 200.0,
                                            width: 200.0,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 5.0,
                                                    color: appPrimaryColor),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      spreadRadius: 2,
                                                      blurRadius: 10,
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      offset:
                                                          const Offset(0, 10)),
                                                ],
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        "http://" +
                                                            Config.apiURL +
                                                            "/uploads/" +
                                                            snapshot
                                                                .data!
                                                                .body[index]
                                                                .image))),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            (snapshot.data!.body[index].name +
                                                    " " +
                                                    snapshot.data!.body[index]
                                                        .surname)
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: appPrimaryColorHex),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                right: 8, left: 10, top: 5),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          blurRadius: 1,
                                                          offset: const Offset(
                                                              1, 1),
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Colors.white)),
                                                  child: SizedBox(
                                                    width: 200,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          snapshot
                                                              .data!
                                                              .body[index]
                                                              .science,
                                                          style: const TextStyle(
                                                              color:
                                                                  appPrimaryColorHex,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                            style: style,
                                            onPressed: () async {
                                              var a = "";
                                              var loginDetails =
                                                  await SharedService
                                                      .loginDetails();

                                              if (loginDetails!.user.id <
                                                  snapshot
                                                      .data!.body[index].id) {
                                                a = loginDetails.user.id
                                                        .toString() +
                                                    "-" +
                                                    snapshot
                                                        .data!.body[index].id
                                                        .toString();
                                              } else {
                                                a = snapshot
                                                        .data!.body[index].id
                                                        .toString() +
                                                    "-" +
                                                    loginDetails.user.id
                                                        .toString();
                                              }
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MessageDetails(
                                                          id: int.parse(
                                                              (loginDetails
                                                                      .user.id)
                                                                  .toString()),
                                                          target: int.parse(
                                                              (snapshot
                                                                  .data!
                                                                  .body[index]
                                                                  .id
                                                                  .toString())),
                                                          duo: a,
                                                          image: "http://" +
                                                              Config.apiURL +
                                                              "/uploads/" +
                                                              snapshot
                                                                  .data!
                                                                  .body[index]
                                                                  .image,
                                                          userName: (snapshot
                                                                      .data!
                                                                      .body[
                                                                          index]
                                                                      .name +
                                                                  " " +
                                                                  snapshot
                                                                      .data!
                                                                      .body[
                                                                          index]
                                                                      .surname)
                                                              .toString()
                                                              .toTitleCase(),
                                                        )),
                                              );
                                            },
                                            child: const Text('Mesaj Gönder'),
                                          ),
                                        ],
                                      )),
                                )),
                      ),
                    ],
                  )
                : const Center(
                    child: Text("Hiç mesajınız bulunmuyor"),
                  ));
  }

  Widget getMajorListB(dropdownValue) {
    return FutureBuilder(
        future: APIService.getDoctorB(dropdownValue),
        builder: (BuildContext ctx, AsyncSnapshot<GetDoctorRes> snapshot) =>
            snapshot.hasData
                ? Column(
                    children: [
                      SizedBox(
                        height: 500,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.body.length,
                            itemBuilder: (BuildContext context, index) =>
                                InkWell(
                                  child: Container(
                                      height: 450,
                                      width: 300,
                                      padding: const EdgeInsets.only(
                                          right: 30, left: 30, top: 45),
                                      margin: const EdgeInsets.only(
                                          right: 30, left: 30, top: 45),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(1, 9),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 200.0,
                                            width: 200.0,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 5.0,
                                                    color: appPrimaryColor),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      spreadRadius: 2,
                                                      blurRadius: 10,
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      offset:
                                                          const Offset(0, 10)),
                                                ],
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        "http://" +
                                                            Config.apiURL +
                                                            "/uploads/" +
                                                            snapshot
                                                                .data!
                                                                .body[index]
                                                                .image))),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            (snapshot.data!.body[index].name +
                                                    " " +
                                                    snapshot.data!.body[index]
                                                        .surname)
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: appPrimaryColorHex),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                right: 8, left: 10, top: 5),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          blurRadius: 1,
                                                          offset: const Offset(
                                                              1, 1),
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Colors.white)),
                                                  child: SizedBox(
                                                    width: 200,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          snapshot
                                                              .data!
                                                              .body[index]
                                                              .science,
                                                          style: const TextStyle(
                                                              color:
                                                                  appPrimaryColorHex,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                            style: style,
                                            onPressed: () async {
                                              var a = "";
                                              var loginDetails =
                                                  await SharedService
                                                      .loginDetails();

                                              if (loginDetails!.user.id <
                                                  snapshot
                                                      .data!.body[index].id) {
                                                a = loginDetails.user.id
                                                        .toString() +
                                                    "-" +
                                                    snapshot
                                                        .data!.body[index].id
                                                        .toString();
                                              } else {
                                                a = snapshot
                                                        .data!.body[index].id
                                                        .toString() +
                                                    "-" +
                                                    loginDetails.user.id
                                                        .toString();
                                              }
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MessageDetails(
                                                          id: int.parse(
                                                              (loginDetails
                                                                      .user.id)
                                                                  .toString()),
                                                          target: int.parse(
                                                              (snapshot
                                                                  .data!
                                                                  .body[index]
                                                                  .id
                                                                  .toString())),
                                                          duo: a,
                                                          image: "http://" +
                                                              Config.apiURL +
                                                              "/uploads/" +
                                                              snapshot
                                                                  .data!
                                                                  .body[index]
                                                                  .image,
                                                          userName: (snapshot
                                                                      .data!
                                                                      .body[
                                                                          index]
                                                                      .name +
                                                                  " " +
                                                                  snapshot
                                                                      .data!
                                                                      .body[
                                                                          index]
                                                                      .surname)
                                                              .toString()
                                                              .toTitleCase(),
                                                        )),
                                              );
                                            },
                                            child: const Text('Mesaj Gönder'),
                                          ),
                                        ],
                                      )),
                                )),
                      ),
                    ],
                  )
                : const Center(
                    child: Text("Hiç mesajınız bulunmuyor"),
                  ));
  }

  Widget getDoctorbyName(String doctorName) {
    return FutureBuilder(
        future: APIService.getDoctorUsagedName(doctorName),
        builder: (BuildContext ctx, AsyncSnapshot<GetDoctorRes> snapshot) =>
            snapshot.hasData
                ? Column(
                    children: [
                      SizedBox(
                        height: 500,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.body.length,
                            itemBuilder: (BuildContext context, index) =>
                                InkWell(
                                  child: Container(
                                      height: 450,
                                      width: 300,
                                      padding: const EdgeInsets.only(
                                          right: 30, left: 30, top: 45),
                                      margin: const EdgeInsets.only(
                                          right: 30, left: 30, top: 45),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(1, 9),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 200.0,
                                            width: 200.0,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 5.0,
                                                    color: appPrimaryColor),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      spreadRadius: 2,
                                                      blurRadius: 10,
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      offset:
                                                          const Offset(0, 10)),
                                                ],
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        "http://" +
                                                            Config.apiURL +
                                                            "/uploads/" +
                                                            snapshot
                                                                .data!
                                                                .body[index]
                                                                .image))),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            (snapshot.data!.body[index].name +
                                                    " " +
                                                    snapshot.data!.body[index]
                                                        .surname)
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: appPrimaryColorHex),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                right: 8, left: 10, top: 5),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          blurRadius: 1,
                                                          offset: const Offset(
                                                              1, 1),
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Colors.white)),
                                                  child: SizedBox(
                                                    width: 200,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          snapshot
                                                              .data!
                                                              .body[index]
                                                              .science,
                                                          style: const TextStyle(
                                                              color:
                                                                  appPrimaryColorHex,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                            style: style,
                                            onPressed: () async {
                                              var a = "";
                                              var loginDetails =
                                                  await SharedService
                                                      .loginDetails();

                                              if (loginDetails!.user.id <
                                                  snapshot
                                                      .data!.body[index].id) {
                                                a = loginDetails.user.id
                                                        .toString() +
                                                    "-" +
                                                    snapshot
                                                        .data!.body[index].id
                                                        .toString();
                                              } else {
                                                a = snapshot
                                                        .data!.body[index].id
                                                        .toString() +
                                                    "-" +
                                                    loginDetails.user.id
                                                        .toString();
                                              }
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MessageDetails(
                                                          id: int.parse(
                                                              (loginDetails
                                                                      .user.id)
                                                                  .toString()),
                                                          target: int.parse(
                                                              (snapshot
                                                                  .data!
                                                                  .body[index]
                                                                  .id
                                                                  .toString())),
                                                          duo: a,
                                                          image: "http://" +
                                                              Config.apiURL +
                                                              "/uploads/" +
                                                              snapshot
                                                                  .data!
                                                                  .body[index]
                                                                  .image,
                                                          userName: (snapshot
                                                                      .data!
                                                                      .body[
                                                                          index]
                                                                      .name +
                                                                  " " +
                                                                  snapshot
                                                                      .data!
                                                                      .body[
                                                                          index]
                                                                      .surname)
                                                              .toString()
                                                              .toTitleCase(),
                                                        )),
                                              );
                                            },
                                            child: const Text('Mesaj Gönder'),
                                          ),
                                        ],
                                      )),
                                )),
                      ),
                    ],
                  )
                : const Center(
                    child: Text("Hiç mesajınız bulunmuyor"),
                  ));
  }

  Widget button(void Function() onTap, String text, IconData icon) {
    return InkWell(
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          margin: const EdgeInsets.all(25),
          height: 80,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffE4EAF6),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: appPrimaryColor,
                ),
              ),
              Text(
                text.toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: appPrimaryColorHex,
                ),
              ),
            ],
          ),
        ));
  }
}
