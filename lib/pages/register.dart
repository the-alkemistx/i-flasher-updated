import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:consumer/widgets/common_methods.dart';
import 'package:consumer/widgets/text_fields.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return CustomTextField(
          controller: _nameController,
          hintText: "Full-Name",
        );
      case 1:
        return CustomTextField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          controller: _phoneController,
          hintText: "Phone",
        );
      case 2:
        return CustomTextField(
          controller: _userNameController,
          hintText: "Username",
        );
      case 3:
        return CustomTextField(
          controller: _emailController,
          hintText: "E-mail",
        );
      case 4:
        return CustomTextField(
          controller: _passwordController,
          obscureText: true,
          hintText: "Password",
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue,
            Colors.green,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 30),
              child: Text(
                'Create\nAccount',
                style: GoogleFonts.aclonica(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.22,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          _buildStepContent(),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_currentStep > 0)
                                ElevatedButton(
                                  onPressed: _prevStep,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent, // Set the button's background color to transparent
                                    side: const BorderSide(width: 1.5, color: Colors.white), // Add a border with the desired width and color
                                  ),
                                  child: const Text("Previous"),
                                ),

                              if (_currentStep < 4)
                                ElevatedButton(
                                  onPressed: _nextStep,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent, // Set the button's background color to transparent
                                    side: const BorderSide(width: 1.5, color: Colors.white), // Add a border with the desired width and color
                                  ),
                                  child: const Text("Next"),
                                ),
                              if (_currentStep == 4)
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white38,
                                  child: IconButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      String fullname = _nameController.text;
                                      int phone =
                                      int.parse(_phoneController.text);
                                      String username =
                                          _userNameController.text;
                                      String email = _emailController.text;
                                      String password =
                                          _passwordController.text;
                                      if (validateEmail(email)) {
                                        if (await insertion(
                                            username,
                                            password,
                                            fullname,
                                            phone,
                                            email)) {
                                          Navigator.pushReplacementNamed(
                                              context, 'login');
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: 'Please Use Valid Details.',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                            Colors.blueAccent,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: 'Please Use Valid Mail',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                          Colors.blueAccent,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'login');
                                },
                                style: const ButtonStyle(),
                                child: Text(
                                  'Sign In',
                                  textAlign:TextAlign.left,
                                  style: GoogleFonts.oxanium(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontSize: 22),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
