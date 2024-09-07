import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/app/singlton.dart';
import 'package:template/features/auth/presentation/model/input_login_model.dart';
import 'package:template/features/auth/presentation/view/register_screen.dart';

import '../../../../app/service_locator.dart';
import '../../../../shared/common/state_renderer/state_renderer.dart';
import '../../../../shared/common/widget/button_widget.dart';
import '../../../../shared/common/widget/check_view_widget.dart';
import '../../../../shared/common/widget/component.dart';
import '../../../../shared/common/widget/text_field_with_title_widget.dart';
import '../../../../shared/resources/color_manager.dart';
import '../../../../shared/resources/font_manager.dart';
import '../../../../shared/resources/manager_values.dart';
import '../../../../shared/resources/routes_manager.dart';
import '../../../../shared/resources/size_config.dart';
import '../../../../shared/resources/styles_manager.dart';
import '../view_model/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isShowPassword = true;
  late AuthCubit _viewModel;
  DeviceScreenType deviceScreenType = DeviceScreenType.Mobile;
  DateTime? _currentBackPressTime;

  void onChangeView(DeviceScreenType value) {
    deviceScreenType = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void initState() {
    initAuthModule();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      smallScreen: buildMobileView(),
      onChangeView: onChangeView,
    );
  }

  Widget buildMobileView() {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (_currentBackPressTime == null ||
            now.difference(_currentBackPressTime!) >
                const Duration(seconds: 2)) {
          _currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: ColorManager.primary,
              content: Text(
                'Press back button again to exit.',
                style: getRegularStyle(color: ColorManager.white),
              ),
            ),
          );
          return false;
        }
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorManager.background,
        body: BlocProvider<AuthCubit>(
          create: (context) {
            _viewModel = AuthCubit();
            return _viewModel;
          },
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLoginLoadingState) {
                showPopupDialog(
                    context: context,
                    stateRendererType: StateRendererType.popupLoadingState);
              }
              if (state is AuthLoginErrorState) {
                dismissDialog(context);
                //generic
                showPopupDialog(
                    context: context,
                    message: state.failure.message,
                    stateRendererType: StateRendererType.popupErrorState);
              }
              if (state is AuthLoginSuccessState) {
                dismissDialog(context);
                Singleton().userModel = state.entity;
                Navigator.pushReplacementNamed(
                  context,
                  Routes.messagesRoute,
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: deviceScreenType == DeviceScreenType.Desktop
                    ? getPadding(horizontal: AppPadding.p50)
                    : EdgeInsets.zero,
                child: Container(
                  alignment: Alignment.center,
                  height: ScreenUtil().screenHeight,
                  margin:
                      addPaddingForContent(deviceScreenType: deviceScreenType),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: AppPadding.p32,
                          ),

                          const SizedBox(height: AppPadding.p32),
                          Text(
                            "Hi There!",
                            style: getBoldStyle(
                              fontSize: FontSize.s24,
                              color: ColorManager.textHeaderColor,
                            ),
                          ),
                          Text(
                            "Welcome back, Let's get you logged in",
                            style: getRegularStyle(
                                color: ColorManager.textSubTitleColor),
                          ),
                          const SizedBox(height: AppPadding.p24),
                          TextFieldWithTitle(
                            fNameController: _emailController,
                            fieldName: "Email",
                            hintText: "Enter email address",
                            inputType: TextInputType.emailAddress,
                          ),
                          TextFieldWithTitle(
                            fNameController: _passwordController,
                            fieldName: "Password",
                            isSecure: true,
                            hintText: "Enter your password",
                            isPassword: true,
                          ),
                          const SizedBox(height: AppSize.s28),
                          CustomButton(
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  _viewModel.login(
                                      model: LoginInputModel(
                                          email: _emailController.text,
                                          password: _passwordController.text));
                                }
                              },
                              labelText: "Login"),
                          // remember me
                          //add don't have account

                          const SizedBox(height: AppSize.s28),
                          InkWell(
                            onTap: () {
                              changeNavigator(context, const RegisterScreen());
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Don\'t have an account ? ',
                                    style: getRegularStyle(),
                                  ),
                                  TextSpan(
                                    text: 'Sign up',
                                    style: getSemiBoldStyle(
                                        color: ColorManager.primary),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
