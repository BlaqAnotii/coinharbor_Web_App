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

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState
    extends State<CreateAccountScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BaseView<AuthViewModel>(onModelReady: (model) {
      debugPrint("Alladu======");
      model.setAppTitle('Create Account');
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
                                    const SizedBox(height: 18),
                                    const Text(
                                      "Create an account",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Sign up, Trade and Invest anytime",
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
                                        controller: model.fname,
                                        label: 'First Name',
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Enter firstname';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: CalcWidth(
                                          context, 150,
                                          maxWidth: 400),
                                      height: 50.0,
                                      child: Input(
                                        controller: model.lname,
                                        label: 'Last Name',
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Enter lastname';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: CalcWidth(
                                          context, 150,
                                          maxWidth: 400),
                                      height: 50.0,
                                      child: Input(
                                        controller: model.email,
                                        label: 'Email',
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Enter email';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: CalcWidth(
                                          context, 150,
                                          maxWidth: 400),
                                      height: 50.0,
                                      child: Input(
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Enter password';
                                          }
                                          return null;
                                        },
                                        controller:
                                            model.password,
                                        suffixIcon: const Icon(Icons
                                            .visibility_off_outlined),
                                        label: 'Password',
                                        isPassword: true,
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
                                            text:
                                                'Create Account',
                                            onPressed: () {
                                              FocusManager
                                                  .instance
                                                  .primaryFocus
                                                  ?.unfocus();
                                              if (model.formKey
                                                  .currentState!
                                                  .validate()) {
                                                model
                                                    .processSignUp(
                                                        context);
                                              }
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
                                                    "Have any account?          ",
                                                style:
                                                    const TextStyle(
                                                  color: Color(
                                                      0xff000000),
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "Sign in",
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
                              "Create an account",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Sign up, Trade and Invest anytime",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff000000),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Input(
                              //controller: model.name,
                              label: 'First Name',
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Enter firstname';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            Input(
                              //controller: model.name,
                              label: 'Last Name',
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Enter lastname';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
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
                            const SizedBox(height: 20),
                            Input(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Enter password';
                                }
                                return null;
                              },
                              //   controller:
                              //       model.password,
                              suffixIcon: const Icon(
                                  Icons.visibility_off_outlined),
                              label: 'Password',
                              isPassword: true,
                            ),
                            const SizedBox(height: 30),
                            Center(
                                child: AppButton(
                                    onPressed: () {
                                      context
                                          .go('/verification');
                                    },
                                    text: 'Create Account')),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: "Have any account? ",
                                    style: const TextStyle(
                                      color: Color(0xff000000),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Sign in",
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
