import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import 'custom_loading_screen.dart';

// ignore: must_be_immutable
class CachedImage extends StatefulWidget {
  String url;
  String? errorImage;
  BoxFit? fit;
  double? height, width;
  BorderRadius? borderRadius;
  ColorFilter? colorFilter;
  Color? colorImage;
  Alignment alignment;
  Widget? child;
  BoxShape boxShape;
  double verticalPadding;
  double horizontalPadding;
  final bool? showImageLoading;

  CachedImage(
      {Key? key,
      required this.url,
      this.fit,
      this.errorImage,
      // this.fit = BoxFit.fill,
      this.width,
      this.height,
      this.borderRadius,
      this.colorFilter,
      this.alignment = Alignment.center,
      this.child,
      this.colorImage,
      this.verticalPadding = 0,
      this.horizontalPadding = 0,
      this.showImageLoading = true,
      this.boxShape = BoxShape.rectangle})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  @override
  Widget build(BuildContext context) {
    return
// SizedBox(
//         width: widget.width,
//         height: widget.height,
//         child:   Image.asset(
//           widget.url,
//           width: widget.width,
//           height: widget.height,
//           fit: widget.fit??BoxFit.cover,
//
//
//         ) ,
//       )

        widget.url.contains('.svg')
            ? Container(
                width: widget.width,
                height: widget.height,
                // color: ColorManager.package,
                child: SvgPicture.network(
                  widget.url,
                  width: widget.width,
                  height: widget.height,
                  fit: widget.fit ?? BoxFit.cover,
                  // fit: BoxFit.fill,
                  color: widget.colorImage,
                  placeholderBuilder: (context) => Container(
                    width: widget.width,
                    height: widget.height,
                    alignment: Alignment.center,
                    child: const CustomLoadingScreen(),
                  ),
                ),
              )
            : CachedNetworkImage(
                imageUrl: widget.url,
                width: widget.width,
                height: widget.height,
                color: widget.colorImage,
                imageBuilder: (context, imageProvider) => Container(
                  width: widget.width,
                  height: widget.height,
                  // padding: EdgeInsets.symmetric(vertical:widget.verticalPadding ,horizontal:widget.horizontalPadding ),
                  decoration: BoxDecoration(
                      // color: ColorManager.error,
                      image: DecorationImage(
                          image: imageProvider,
                          fit: widget.fit,
                          // fit: BoxFit.fill,
                          colorFilter: widget.colorFilter),
                      borderRadius: widget.borderRadius,
                      color: ColorManager.greyLightHover,
                      shape: widget.boxShape),
                  alignment: widget.alignment,
                  child: widget.child,
                ),
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                      // color: ColorManager.divider,
                      borderRadius: widget.borderRadius,
                      // image: DecorationImage(
                      //   image: const AssetImage(Assets.assetsImagesPlaceHolderNoImage),
                      //   fit: BoxFit.contain,
                      //   // fit: widget.fit,
                      //   // colorFilter: widget.colorFilter
                      // ),
                      shape: widget.boxShape),
                  child: Image.asset(widget.errorImage ??
                      Assets.assetsImagesPlaceHolderNoImage),
                  // child: Container(
                  //
                  //     width: 40,
                  //     height: 40,
                  //     decoration: BoxDecoration(
                  //          color: ColorManager.divider,
                  //         image: DecorationImage(
                  //           image: const AssetImage(Assets.assetsImagesPlaceHolderNoImage),
                  //           fit: BoxFit.contain,
                  //           // fit: widget.fit,
                  //           // colorFilter: widget.colorFilter
                  //         ),
                  //         borderRadius: widget.borderRadius,
                  //         shape: widget.boxShape)
                  //     // alignment: Alignment.center,
                  //     // child: Image.asset(widget.errorholder??ImageManager.logo,fit: BoxFit.fill,)
                  //     ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                      // color: ColorManager.divider,
                      borderRadius: widget.borderRadius,
                      // image: DecorationImage(
                      //   image: const AssetImage(Assets.assetsImagesPlaceHolderNoImage),
                      //   fit: BoxFit.contain,
                      //   // fit: widget.fit,
                      //   // colorFilter: widget.colorFilter
                      // ),
                      shape: widget.boxShape),
                  child: Image.asset(widget.errorImage ??
                      Assets.assetsImagesPlaceHolderNoImage),
                  // child: Container(
                  //
                  //     width: 40,
                  //     height: 40,
                  //     decoration: BoxDecoration(
                  //          color: ColorManager.divider,
                  //         image: DecorationImage(
                  //           image: const AssetImage(Assets.assetsImagesPlaceHolderNoImage),
                  //           fit: BoxFit.contain,
                  //           // fit: widget.fit,
                  //           // colorFilter: widget.colorFilter
                  //         ),
                  //         borderRadius: widget.borderRadius,
                  //         shape: widget.boxShape)
                  //     // alignment: Alignment.center,
                  //     // child: Image.asset(widget.errorholder??ImageManager.logo,fit: BoxFit.fill,)
                  //     ),
                ),
              );
  }
}
