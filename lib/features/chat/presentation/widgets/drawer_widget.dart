import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/features/auth/presentation/view/login_screen.dart';
import 'package:template/features/auth/presentation/view_model/auth_cubit.dart';

import '../../../../app/singlton.dart';
import '../../../../shared/common/widget/component.dart';
import '../../../../shared/common/widget/custom_image_widget.dart';
import '../../../../shared/resources/assets_manager.dart';
import '../../../../shared/resources/color_manager.dart';
import '../../../../shared/resources/font_manager.dart';
import '../../../../shared/resources/manager_values.dart';
import '../../../../shared/resources/size_config.dart';
import '../../../../shared/resources/styles_manager.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return buildDrawerView(context);
  }

  Widget buildDrawerView(BuildContext context) {
    return SafeArea(
      child: Drawer(
          child: Padding(
        padding:
            getPadding(vertical: AppPadding.p24, horizontal: AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: AppPadding.p32,
            ),
            InkWell(
              splashColor: ColorManager.white,
              onTap: () {
                // changeNavigator(context, const AccountScreen());
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: AppSize.s50,
                    width: AppSize.s50,
                    child: CircleAvatar(
                        backgroundColor: ColorManager.gray16,
                        radius: AppSize.s40,
                        child: CustomSvgImage(
                          height: AppSize.s28,
                          imageName: Assets.assetsSvgPerson,
                          color: ColorManager.coolGray,
                        )),
                  ),
                  const SizedBox(
                    width: AppPadding.p8,
                  ),
                  BlocProvider<AuthCubit>(
                    create: (context) {
                      return AuthCubit()..getUser();
                    },
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              Singleton().userData?['fullName'] ?? '',
                              style: getSemiBoldStyle(),
                            ),
                            const SizedBox(
                              height: AppPadding.p4,
                            ),
                            Text(
                              Singleton().userData?['email'] ?? '',
                              style: getRegularStyle(fontSize: FontSize.s14),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppPadding.p16),
            const Divider(),
            buildDrawerItem(
              svgName: Assets.assetsSvgComplete,
              name: "Dashboard",
              onTap: () {
                Navigator.pop(context);
              },
            ),
      
            // buildDrawerItem(
            //   svgName: Assets.assetsSvgCategory,
            //   name: "Recipes",
            //   onTap: () {
            //     changeNavigator(context, const HomeScreen());
            //   },
            // ),
            BlocProvider<AuthCubit>(
              create: (context) {
                return AuthCubit();
              },
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (ctx, state) {
                  if (state is AuthLogoutSuccessState) {
                    changeNavigatorAndRemoveUntil(context, LoginScreen());
                  }
                },
                builder: (ctx, state) => buildDrawerItem(
                    svgName: Assets.assetsSvgLogout,
                    name: "Log out",
                    onTap: () {
                      final logout = ctx.read<AuthCubit>();
                      logout.logout();
                    }),
              ),
            ),
            const SizedBox(height: AppPadding.p16),
          ],
        ),
      )),
    );
  }

  Widget buildDrawerItem({
    required String name,
    required String svgName,
    required Function onTap,
  }) {
    return ListTile(
      splashColor: ColorManager.white,
      // contentPadding: getPadding(horizontal: 5),
      minLeadingWidth: 17,
      leading: Container(
        // decoration: BoxDecoration(color: ColorManager.white, borderRadius: BorderRadius.circular(50)),
        child: CustomSvgImage(
          width: 17,
          imageName: svgName,
          color: ColorManager.coolGray,
        ),
      ),
      title: Text(
        name,
        style: getMediumStyle(fontSize: FontSize.s14),
      ),
      onTap: onTap as VoidCallback,
    );
  }
}
