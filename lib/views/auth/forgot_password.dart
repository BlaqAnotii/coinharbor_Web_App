import 'package:coinharbor/controllers/auth_vm.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/utils/responsive.dart';
import 'package:coinharbor/utils/widget_extensions.dart';
import 'package:coinharbor/views/base.dart';
import 'package:coinharbor/widgets/app_buttons.dart';
import 'package:coinharbor/widgets/input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BaseView<AuthViewModel>(onModelReady: (model) {
      debugPrint("Alladu======");
      model.setAppTitle('Login');
    }, builder: (context, model, child) {
      return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.background,
            ),
            child: Responsive.isDesktop(context)
                ? Center(
                    child: Row(
                      children: [
                        // Left Side (Form)
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 30,
                              right: 30,
                            ),
                            child: SingleChildScrollView(
                              child: Form(
                                key: model.formKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment:
                                          Alignment.centerLeft,
                                      child: Image.asset(
                                        'assets/image/logo.png',
                                        scale: 7,
                                      ),
                                    ),
                                    const SizedBox(height: 88),
                                    const Text(
                                      "Forget Password",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Enter Email to receive verification code",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    SizedBox(
                                      width: CalcWidth(
                                          context, 150,
                                          maxWidth: 400),
                                      height: 50.0,
                                      child: Input(
                                        // controller:
                                        //     model.emailLogin,
                                        label: 'Email',
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Enter email';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Center(
                                      child: SizedBox(
                                          width: CalcWidth(
                                              context, 150,
                                              maxWidth: 390),
                                          height: 50.0,
                                          child: AppButton(
                                            text: 'Proceed',
                                            onPressed: () {
                                              // FocusManager
                                              //     .instance
                                              //     .primaryFocus
                                              //     ?.unfocus();
                                              // if (model.formKey
                                              //     .currentState!
                                              //     .validate()) {
                                              //   model
                                              //       .processLogin(
                                              //           context);
                                              // }
                                            },
                                          )),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: CalcWidth(
                                          context, 150,
                                          maxWidth: 400),
                                      height: 50.0,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          children: [
                                            Text.rich(
                                              TextSpan(
                                                text:
                                                    "Return back?          ",
                                                style:
                                                    const TextStyle(
                                                  color: Color(
                                                      0xff000000),
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "Login",
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap =
                                                              () {
                                                            context
                                                                .go('/login');
                                                          },
                                                    style:
                                                        const TextStyle(
                                                      color: Color(
                                                          0xff000000),
                                                      decoration:
                                                          TextDecoration
                                                              .underline,
                                                      fontWeight:
                                                          FontWeight
                                                              .bold,
                                                    ),
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
                            ),
                          ),
                        ),

                        // Right Side (Image + overlays)
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: 736,
                            height: 936,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/image/hero4.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        right: 25,
                      ),
                      child: Form(
                        //key: model.formKey,
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.center,
                          mainAxisAlignment:
                              MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            Image.asset(
                              'assets/image/logo.png',
                              scale: 7,
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            const Text(
                              "Forget Password",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Enter Email to receive verification code",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff000000),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Input(
                              //   controller:
                              //       model.email,
                              label: 'Email',
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Enter email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            Center(
                                child: AppButton(
                                    onPressed: () {},
                                    text: 'Proceed')),
                            const SizedBox(height: 20),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: "Return back? ",
                                    style: const TextStyle(
                                      color: Color(0xff000000),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Login",
                                        recognizer:
                                            TapGestureRecognizer()
                                              ..onTap = () {
                                                context.go(
                                                    '/login');
                                              },
                                        style: const TextStyle(
                                          color:
                                              Color(0xff000000),
                                          decoration:
                                              TextDecoration
                                                  .underline,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  )),
      );
    });
  }
}
