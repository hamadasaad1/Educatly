import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/features/home/domain/model/meal_entity.dart';
import 'package:template/shared/common/widget/custom_empty_widget.dart';

import '../../../../shared/common/widget/check_view_widget.dart';
import '../../../../shared/common/widget/custom_app_bar.dart';
import '../../../../shared/resources/manager_values.dart';
import '../../../../shared/resources/size_config.dart';
import '../view_model/home_cubit.dart';
import '../widget/meal_widget.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _KdsHomeScreenState createState() => _KdsHomeScreenState();
}

class _KdsHomeScreenState extends State<FavoriteScreen> {
  DeviceScreenType deviceScreenType = DeviceScreenType.Mobile;

  void onChangeView(DeviceScreenType value) {
    deviceScreenType = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  late HomeCubit _viewModel;

  List<MealEntity> meals = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Favorites'),
      body: ResponsiveWidget(
        smallScreen: BlocProvider<HomeCubit>(
          create: (context) {
            _viewModel = HomeCubit();
            _viewModel.initialHive();

            return _viewModel;
          },
          child: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Padding(
                padding: getPadding(
                    vertical: AppPadding.p12, horizontal: AppPadding.p16),
                child: buildBody(),
              );
            },
          ),
        ),
        onChangeView: onChangeView,
      ),
    );
  }

  Widget buildBody() {
    return _viewModel.getFavorites().isEmpty
        ? const Center(child: CustomEmptyScreen(title: 'No Favorite'))
        : ListView.separated(
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSize.s16),
            itemCount: _viewModel.getFavorites().length,
            itemBuilder: (context, index) {
              return SingleMealWidget(
                isFavorite: _viewModel.mealBox
                    .containsKey(_viewModel.getFavorites()[index].id),
                model: _viewModel.getFavorites()[index],
                onTap: () {
                  _viewModel.toggleFavorite(_viewModel.getFavorites()[index]);
                },
              );
            },
          );
  }
}
