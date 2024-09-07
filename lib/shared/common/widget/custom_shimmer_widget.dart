import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../resources/color_manager.dart';
import '../../resources/manager_values.dart';
import '../../resources/size_config.dart';

class CustomShimmerLoading extends StatelessWidget {
  const CustomShimmerLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorManager.neutralGray100,
      highlightColor: ColorManager.neutralGray100.withOpacity(.5),
      enabled: true,
      child: Container(
        margin: getPadding(bottom: AppPadding.p24),
        padding:
            getPadding(horizontal: AppPadding.p24, vertical: AppPadding.p8),
        child: const Row(
          children: [
            SizedBox(height: AppSize.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton(height: 60, width: 60),
                  SizedBox(height: AppSize.s16),
                  Skeleton(),
                  SizedBox(height: AppSize.s16),
                  Skeleton(
                    width: 250,
                  ),
                  SizedBox(height: AppSize.s16),
                  Skeleton(
                    width: 100,
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Skeleton(),
                  //     ),
                  //     SizedBox(height: AppSize.s16),
                  //     Expanded(
                  //       child: Skeleton(),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: getPadding(all: AppPadding.p8),
      decoration: const BoxDecoration(
          color: ColorManager.lightPrimary,
          borderRadius: BorderRadius.all(Radius.circular(AppPadding.p12))),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}
