import 'package:flutter/material.dart';
import 'package:teletip_app/app_colors.dart';
import 'package:teletip_app/services/api_service.dart';

class MessageDetails extends StatefulWidget {
  const MessageDetails(
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
  _MessageDetailsState createState() => _MessageDetailsState();
}

class _MessageDetailsState extends State<MessageDetails> {
  final _controller = TextEditingController();
  String? message;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFF142A3B),
      body: SafeArea(
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 45.0,
                                height: 45.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  image: DecorationImage(
                                    image: NetworkImage(widget.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                widget.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Color(0xFFECF1FF),
                                  letterSpacing: 0.8,
                                  height: 1.25,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 30,
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              allMessage(screenHeight - 220, keyboardHeight),
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
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        letterSpacing: 0.7000000000000001,
                        fontWeight: FontWeight.w600,
                        height: 1.43,
                      ),
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
                      primary: Colors.white,
                      onPrimary: appPrimaryColor,
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
              //const Line(),
            ],
          ),
        ),
      ),
    );
  }

  Widget allMessage(screen, keyboard) {
    return FutureBuilder(
        future: APIService.getDuoMessage(widget.duo),
        builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>
            snapshot.hasData
                ? SizedBox(
                    height: screen - keyboard,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, index) => Padding(
                          padding:
                              const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                          child: widget.id == snapshot.data![index]['source']
                              ? source(snapshot.data![index]['message'])
                              : target(snapshot.data![index]['message'])),
                    ),
                  )
                : Text("data"));
  }

  Widget source(String text) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(19),
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        ),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment(0.97, -1.0),
          colors: [Color(0xFF5574F7), Color(0xFF60C3FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(0, 5.0),
            blurRadius: 14.0,
          ),
        ],
      ),
      child: SizedBox(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            letterSpacing: 0.7000000000000001,
            fontWeight: FontWeight.w600,
            height: 1.43,
          ),
        ),
      ),
    );
  }

  Widget target(String text) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(19),
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
        color: const Color(0xFF1F3C53),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            offset: const Offset(0, 7.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14.0,
            color: Color(0xFFECF1FF),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
