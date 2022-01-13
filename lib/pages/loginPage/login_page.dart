import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:teletip_app/app_colors.dart';
import 'package:teletip_app/config.dart';
import 'package:teletip_app/models/user_login_req.dart';
import 'package:teletip_app/components/or_divider.dart';
import 'package:teletip_app/services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFromKey = GlobalKey<FormState>();
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appPrimaryColor,
        body: ProgressHUD(
          child: Form(
            key: globalFromKey,
            child: _loginUI(context),
          ),
          key: UniqueKey(),
          inAsyncCall: isAPIcallProcess,
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 5,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white]),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 150,
                  fit: BoxFit.contain,
                ),
              )
            ],
          ),
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 30, top: 50),
            child: Text(
              "Giriş Yap",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
          ),
        ),
        FormHelper.inputFieldWidget(
            context, const Icon(Icons.person), "email", "E-mail",
            (onValidateVal) {
          if (onValidateVal.isEmpty) {
            return "Email adresi boş olamaz";
          }
          return null;
        }, (onSavedVal) {
          email = onSavedVal;
        },
            borderFocusColor: Colors.white,
            prefixIconColor: Colors.white,
            borderColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.white.withOpacity(0.7),
            borderRadius: 10),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: FormHelper.inputFieldWidget(
              context, const Icon(Icons.lock), "password", "Şifre",
              (onValidateVal) {
            if (onValidateVal.isEmpty) {
              return "Şifre boş olamaz";
            }
            return null;
          }, (onSavedVal) {
            password = onSavedVal;
          },
              borderFocusColor: Colors.white,
              prefixIconColor: Colors.white,
              borderColor: Colors.white,
              textColor: Colors.white,
              obscureText: hidePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                icon: Icon(
                    hidePassword ? Icons.visibility : Icons.visibility_off),
                color: Colors.white.withOpacity(0.7),
              ),
              hintColor: Colors.white.withOpacity(0.7),
              borderRadius: 10),
        ),
        const SizedBox(
          height: 40,
        ),
        Center(
          child: FormHelper.submitButton("Giriş yap", () {
            if (validateAndSave()) {
              setState(() {
                isAPIcallProcess = true;
              });

              UserLoginReqModel model =
                  UserLoginReqModel(email: email!, password: password!);
              APIService.userLogin(model).then((res) {
                if (res) {
                  setState(() {
                    isAPIcallProcess = false;
                  });
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false);
                } else {
                  FormHelper.showSimpleAlertDialog(
                      context, Config.appName, "Email/Şifre Yanlış", "Tamam",
                      () {
                    setState(() {
                      isAPIcallProcess = false;
                    });
                    Navigator.pop(context);
                  });
                }
              });
            }
          },
              btnColor: appPrimaryColor,
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 10),
        ),
        const SizedBox(
          height: 35,
        ),
        const Center(child: OrDivider()),
        Center(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              children: <TextSpan>[
                const TextSpan(
                  text: "Henüz bir hesabın yok mu?",
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                    text: " Kayıt ol",
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, "/userRegister");
                      })
              ],
            ),
          ),
        ),
      ],
    ));
  }

  bool validateAndSave() {
    final form = globalFromKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
