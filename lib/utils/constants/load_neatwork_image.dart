import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';

class LoadNetworkImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final BoxFit? fit;

  const LoadNetworkImage(
    this.url, {
    super.key,
    this.height,
    this.width,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      progressIndicatorBuilder: (context, url, progress) {
        return Center(child: LoaderHelper.lottiWidget());
      },
      errorWidget: (context, _, dyn) => const Center(
        child: Icon(Icons.person_rounded),
      ),
    );
  }
}
