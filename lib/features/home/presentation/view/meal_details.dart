import 'package:flutter/material.dart';
import 'package:template/features/home/domain/model/meal_entity.dart';
import 'package:template/shared/common/widget/custom_app_bar.dart';
import 'package:template/shared/common/widget/custom_image_widget.dart';
import 'package:template/shared/resources/font_manager.dart';
import 'package:template/shared/resources/manager_values.dart';
import 'package:template/shared/resources/size_config.dart';
import 'package:template/shared/resources/styles_manager.dart';

class MealDetailPage extends StatelessWidget {
  final MealEntity meal;

  MealDetailPage({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: meal.name),
      body: SingleChildScrollView(
        padding: getPadding(all: AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImageWidget(
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              imageName: meal.image,
            ),
            const SizedBox(height: 16),
            Text(
              'Description:',
              style: getBoldStyle(),
            ),
            const SizedBox(height: 8),
            Text(
              meal.description,
              style: getRegularStyle(),
            ),
            const SizedBox(height: 16),
            Text(
              'Ingredients:',
              style: getBoldStyle(),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: meal.ingredients
                  .map<Widget>((ingredient) => Text(
                        '• $ingredient',
                        style: getRegularStyle(fontSize: FontSize.s14),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Deliverable Ingredients:',
              style: getBoldStyle(),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: meal.deliverableIngredients
                  .map<Widget>((step) => Text(
                        '• $step',
                        style: getRegularStyle(fontSize: FontSize.s14),
                      ))
                  .toList(),
            ),
            const SizedBox(height: AppPadding.p16),
          ],
        ),
      ),
    );
  }
}
