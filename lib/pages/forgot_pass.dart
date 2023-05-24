import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _usernameController = TextEditingController();
  String _selectedOption = 'Email';
  bool _isEmailSelected = true;
  bool _isPhoneSelected = false;

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
        body: Stack(
          children: [
            Container(),
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Forgot\nPassword',
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
                  top: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isEmailSelected = true;
                                _isPhoneSelected = false;
                                _selectedOption = 'Email';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _isEmailSelected
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.email,
                                    color: _isEmailSelected
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                      color: _isEmailSelected
                                          ? Colors.white
                                          : Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isEmailSelected = false;
                                _isPhoneSelected = true;
                                _selectedOption = 'Phone';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _isPhoneSelected
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: _isPhoneSelected
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Phone',
                                    style: TextStyle(
                                      color: _isPhoneSelected
                                          ? Colors.white
                                          : Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          TextField(
                            controller: _usernameController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              filled: true,
                              hintText: _isEmailSelected
                                  ? 'Email'
                                  : 'Phone Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Get Code',
                                style: GoogleFonts.oxanium(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white38,
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () async {
                                    String username =
                                        _usernameController.text;

                                    if (username.isNotEmpty) {
                                      // Perform code retrieval based on selected option
                                      if (_selectedOption == 'Email') {
                                        // Send code to email
                                        // Implement your email sending logic here
                                      } else if (_selectedOption == 'Phone') {
                                        // Send code to phone
                                        // Implement your SMS sending logic here
                                      }

                                      // Navigate to the code verification page
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/code_verification',
                                        arguments: {
                                          'username': username,
                                          'option': _selectedOption,
                                        },
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: 'Enter a valid credentials.',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.blueAccent,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_forward),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/register');
                                },
                                style: const ButtonStyle(),
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.oxanium(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Back to Login',
                                  style: GoogleFonts.oxanium(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
