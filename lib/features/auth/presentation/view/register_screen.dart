import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/auth/presentation/model/input_register_model.dart';

import '../../../../app/service_locator.dart';
import '../../../../shared/common/state_renderer/state_renderer.dart';
import '../../../../shared/common/widget/button_widget.dart';
import '../../../../shared/common/widget/check_view_widget.dart';
import '../../../../shared/common/widget/component.dart';
import '../../../../shared/common/widget/text_field_with_title_widget.dart';
import '../../../../shared/resources/color_manager.dart';
import '../../../../shared/resources/font_manager.dart';
import '../../../../shared/resources/manager_values.dart';
import '../../../../shared/resources/size_config.dart';
import '../../../../shared/resources/styles_manager.dart';
import '../model/input_store_user_model.dart';
import '../view_model/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isShowPassword = true;
  late AuthCubit _viewModel;
  DeviceScreenType deviceScreenType = DeviceScreenType.Mobile;

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
    return Scaffold(
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
              storeUserToFireStore(state.entity);
              Navigator.pop(context);
              showSnackBar(context, 'Register Success');
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
                          "Sign up to your account",
                          style: getRegularStyle(
                              color: ColorManager.textSubTitleColor),
                        ),
                        const SizedBox(height: AppPadding.p24),

                        TextFieldWithTitle(
                          fNameController: _nameController,
                          fieldName: "Name",
                          hintText: "Enter your name",
                        ),

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
                                _viewModel.register(
                                    model: InputRegisterModel(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        fullName: _nameController.text));
                              }
                            },
                            labelText: "Register"),
                        // remember me
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void storeUserToFireStore(user) {
    _viewModel.storeUser(
        model: InputStoreUserModel(
            user: user, fullName: _nameController.text, isSupporter: false));
  }
}
