import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _mobileController = TextEditingController(text: "1111111111");
  var _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Lottie.asset("assets/lottie/login.json")),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      style: TextStyle(fontWeight: FontWeight.w600),
                      enabled: !provider.showOtp,
                      maxLength: 10,
                      cursorColor: Colors.purple.shade100,
                      decoration: InputDecoration(
                        prefix: Text("+91"),
                        label: Text("Mobile Number"),
                        labelStyle: TextStyle(color: Colors.purple),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent
                          )
                        ),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent
                            )
                        )
                      ),
                      controller: _mobileController,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30,),
                    Visibility(
                      visible: provider.showOtp,
                      child: TextFormField(
                        controller: _otpController,
                        // The validator receives the text that the user has entered.
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontWeight: FontWeight.w600 , letterSpacing: 10),
                        maxLength: 6,
                        cursorColor: Colors.purple.shade100,
                        decoration: InputDecoration(
                            label: Text("OTP"),
                            labelStyle: TextStyle(color: Colors.purple , letterSpacing: 2),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent
                                )
                            )
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 30,),
                    Visibility(
                      visible: !provider.showOtp,
                      child: ElevatedButton(
                          onPressed: () {
                            provider.sendOtp(context ,_mobileController.text);
                          },
                          child: Text("Send OTP")),
                    ),
                    Visibility(
                      visible: provider.showOtp,
                      child: ElevatedButton(
                          onPressed: () {
                            provider.verifyOtp(context ,_otpController.text);
                          },
                          child: Text("Confirm OTP")),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
