import 'package:flutter/material.dart';
import 'package:teletip_app/app_colors.dart';
import 'package:teletip_app/services/api_service.dart';

class Messages extends StatefulWidget {
  const Messages(
      {Key? key,
      required this.id,
      required this.duo,
      required this.userName,
      required this.image,
      required this.target})
      : super(key: key);

  final int id;
  final String duo;
  final String userName;
  final String image;
  final int target;

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final _controller = TextEditingController();
  String? message;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        backgroundColor: appPrimaryColor,
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: appPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 10)),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(widget.image),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.userName,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 2,
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(
                    height: screenHeight - keyboardHeight - 178,
                    child: allMessage()),
                Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: (onSavedVal) {
                          message = onSavedVal;
                        },
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          hintText: 'Mesaj gönder',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // background
                        onPrimary: appPrimaryColor, // foreground
                      ),
                      onPressed: () async {
                        var isSend = await APIService.sendMessage(
                            target: widget.target,
                            source: widget.id,
                            message: message);
                        if (isSend) {
                          setState(() {
                            _controller.clear();
                          });
                          message = "";
                        } else {
                          print("yok olmadı");
                        }
                      },
                      child: Row(
                        children: const [Icon(Icons.send)],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget allMessage() {
    return FutureBuilder(
        future: APIService.getDuoMessage(widget.duo),
        builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) => snapshot
                .hasData
            ? ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, index) => Padding(
                  padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment:
                        widget.id == snapshot.data![index]['source']
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    children: [
                      if (!(widget.id == snapshot.data![index]['source']))
                        Container(
                          margin: const EdgeInsets.only(
                              left: 5, top: 5, bottom: 5, right: 5),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              color: Colors.white,
                              border:
                                  Border.all(width: 5, color: Colors.white)),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(widget.image),
                              ),
                              const SizedBox(width: kDefaultPadding / 2),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                        width: 5, color: Colors.white)),
                                child: Text(
                                  snapshot.data![index]['message'],
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: appPrimaryColorHex),
                                ),
                              )
                            ],
                          ),
                        ),
                      if ((widget.id == snapshot.data![index]['source']))
                        Container(
                            padding: const EdgeInsets.only(
                                left: 5, top: 5, bottom: 5, right: 5),
                            margin: const EdgeInsets.only(
                                left: 5, top: 5, bottom: 5, right: 5),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  topRight: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                ),
                                color: Colors.white,
                                border:
                                    Border.all(width: 5, color: Colors.white)),
                            child: Text(
                              snapshot.data![index]['message'],
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: appPrimaryColorHex),
                            ))
                    ],
                  ),
                ),
              )
            : Text("data"));
  }
}
