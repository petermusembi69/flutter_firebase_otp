import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_otp/cubit/generate_otp_cubit.dart';
import 'package:flutter_firebase_otp/cubit/verify_otp_cubit.dart';
import 'package:flutter_firebase_otp/services/_index.dart';
import 'package:flutter_firebase_otp/ui/home_page.dart';
import 'package:flutter_firebase_otp/utils/_index.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:timer_count_down/timer_count_down.dart';

class OtpPage extends StatefulWidget {
  OtpPage({Key? key}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GenerateOtpCubit>(
      create: (context) => locator<GenerateOtpCubit>(),
      child: BlocProvider<VerifyOtpCubit>(
        create: (context) => locator<VerifyOtpCubit>(),
        child: OtpView(),
      ),
    );
  }
}

class OtpView extends StatefulWidget {
  OtpView({Key? key}) : super(key: key);

  @override
  _OtpViewState createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  TextEditingController pinController = TextEditingController();

  String? phoneNumber = locator<HiveServices>().retrievePhoneNumber();
  @override
  void initState() {
    super.initState();
    locator<GenerateOtpCubit>().generateOtp(phoneNumber: phoneNumber!);
  }

  late Future<Widget> resendAgainLink;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocConsumer<GenerateOtpCubit, GenerateOtpState>(
      listener: (context, state) => state.when(
        Initial: () {},
        loading: () {},
        loaded: () {
          resendAgainLink = Future<Widget>.delayed(
            const Duration(seconds: 60),
            () => InkWell(
              onTap: () {
                locator<GenerateOtpCubit>()
                    .generateOtp(phoneNumber: phoneNumber!);
                pinController.clear();
              },
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: 'Did not receive code, '),
                    TextSpan(
                      text: 'Resend Again',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        error: (error) {
          final snackBar = SnackBar(content: Text(error));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      ),
      builder: (context, state) {
        return BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
          listener: (context, state) => state.when(
            initial: () {},
            loading: () {},
            loaded: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
            error: (error) {
              final snackBar = SnackBar(content: Text(error));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 50),
                    child: Text(
                      'Verification',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
                PinCodeTextField(
                  controller: pinController,
                  isCupertino: true,
                  hideCharacter: false,
                  highlight: true,
                  highlightColor: Colors.blue,
                  defaultBorderColor: Colors.black,
                  hasTextBorderColor: Colors.black,
                  maxLength: 6,
                  onTextChanged: (text) {},
                  onDone: (text) {},
                  pinBoxHeight: 50,
                  pinBoxWidth: screenWidth * 0.1,
                  hasUnderline: false,
                  wrapAlignment: WrapAlignment.spaceEvenly,
                  pinTextStyle: const TextStyle(fontSize: 45),
                  pinTextAnimatedSwitcherDuration:
                      const Duration(milliseconds: 300),
                  highlightAnimation: true,
                  highlightAnimationBeginColor: Colors.black,
                  highlightAnimationEndColor: Colors.white12,
                  keyboardType: TextInputType.number,
                  pinBoxRadius: 5,
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  onPressed: () {
                    locator<VerifyOtpCubit>();
                  },
                  color: pinController.text.length == 6
                      ? Colors.grey
                      : Colors.blue,
                  minWidth: double.infinity,
                  height: 90,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
                    builder: (context, state) => state.when(
                      initial: () => Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      loading: () => Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      loaded: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      },
                      error: (error) => Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: BlocBuilder<GenerateOtpCubit, GenerateOtpState>(
                    builder: (context, state) => state.when(
                      initial: () => const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      loaded: () => FutureBuilder<Widget>(
                          future: resendAgainLink,
                          builder: (BuildContext context,
                              AsyncSnapshot<Widget> snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.requireData;
                            } else {
                              return Countdown(
                                seconds: 59,
                                build: (BuildContext context, double time) =>
                                    InkWell(
                                  onTap: () {},
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Resend code after,',
                                        ),
                                        TextSpan(
                                          text: ' ${time.truncate()} ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'seconds',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                interval: const Duration(milliseconds: 100),
                              );
                            }
                          }),
                      error: (err) => const SizedBox.shrink(),
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
