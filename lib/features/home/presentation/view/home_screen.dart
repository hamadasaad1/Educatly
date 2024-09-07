import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/features/home/domain/model/meal_entity.dart';
import 'package:template/features/home/presentation/view/favorite_screen.dart';
import 'package:template/shared/common/widget/component.dart';
import 'package:template/shared/common/widget/custom_empty_widget.dart';
import 'package:template/shared/common/widget/custom_loading_screen.dart';
import 'package:template/shared/resources/color_manager.dart';
import 'package:template/shared/resources/manager_values.dart';
import 'package:template/shared/resources/size_config.dart';

import '../../../../app/service_locator.dart';
import '../../../../shared/common/widget/check_view_widget.dart';
import '../../../../shared/common/widget/custom_app_bar.dart';
import '../../../../shared/common/widget/refresh_widget.dart';
import '../view_model/home_cubit.dart';
import '../widget/meal_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _KdsHomeScreenState createState() => _KdsHomeScreenState();
}

class _KdsHomeScreenState extends State<HomeScreen> {
  DeviceScreenType deviceScreenType = DeviceScreenType.Mobile;

  void onChangeView(DeviceScreenType value) {
    deviceScreenType = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  late HomeCubit _viewModel;

  void _getMeal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.getMeals();
    });
  }

  List<MealEntity> meals = [];

  @override
  void initState() {
    initHomeModule();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Recipes',
        isCenterTitle: true,
        actions: [
          Padding(
            padding: getPadding(right: AppPadding.p16),
            child: InkWell(
              onTap: () {
                changeNavigator(context, const FavoriteScreen());
              },
              child: const Icon(
                Icons.favorite,
                color: ColorManager.primary,
                size: AppSize.s28,
              ),
            ),
          )
        ],
      ),
      body: ResponsiveWidget(
        smallScreen: BlocProvider<HomeCubit>(
          create: (context) {
            _viewModel = HomeCubit();
            _viewModel.initialHive();
            _getMeal();
            return _viewModel;
          },
          child: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state is HomeMealSuccessState) {
                meals = [];
                meals.addAll(state.entity);
              }
            },
            builder: (context, state) {
              return Padding(
                padding: getPadding(
                    vertical: AppPadding.p12, horizontal: AppPadding.p16),
                child: state is HomeMealLoadingState
                    ? const CustomLoadingScreen()
                    : state is HomeMealErrorState
                        ? CustomEmptyScreen(
                            title: state.failure.message,
                          )
                        : buildBody(),
              );
            },
          ),
        ),
        onChangeView: onChangeView,
      ),
    );
  }

  Widget buildBody() {
    return RefreshWidget(
      onRefresh: () async {
        _getMeal();
      },
      child: ListView.separated(
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSize.s16),
        itemCount: meals.length,
        itemBuilder: (context, index) {
          return SingleMealWidget(
            isFavorite: _viewModel.mealBox.containsKey(meals[index].id),
            model: meals[index],
            onTap: () {
              _viewModel.toggleFavorite(meals[index]);
            },
          );
        },
      ),
    );
  }
}
