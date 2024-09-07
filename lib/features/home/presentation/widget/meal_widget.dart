import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/shared/resources/color_manager.dart';
import 'package:template/shared/resources/manager_values.dart';
import 'package:template/shared/resources/size_config.dart';
import 'package:template/shared/resources/styles_manager.dart';

import '../../../../shared/common/widget/cach_image.dart';
import '../../../../shared/common/widget/component.dart';
import '../../domain/model/meal_entity.dart';
import '../view/meal_details.dart';

class SingleMealWidget extends StatelessWidget {
  final bool isFavorite;
  final MealEntity model;
  final Function onTap;

  const SingleMealWidget({
    Key? key,
    required this.isFavorite,
    required this.model,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: ShapeDecoration(
        color: ColorManager.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: const [
          BoxShadow(
            color: ColorManager.shadowColor,
            blurRadius: 10,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          changeNavigator(context, MealDetailPage(meal: model));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImage(
              url: model.image,
              fit: BoxFit.cover,
              width: 120.w,
              height: 120,
              borderRadius: BorderRadius.circular(6),
            ),
            SizedBox(width: 16.w),
            Expanded(
                child: Padding(
              padding: getPadding(vertical: AppSize.s4),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: getSemiBoldStyle(color: ColorManager.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      model.headline,
                      style: getRegularStyle(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]),
            )),
            SizedBox(width: 16.w),
            IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  onTap();
                }),
          ],
        ),
      ),
    );
  }
}
