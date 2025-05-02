import 'package:flutter/material.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';

import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class ArrowButton extends StatefulWidget {
  final String text;
  final Function()? onTap;
  final String? image;
  final bool? submitType;
  const ArrowButton(
      {super.key, this.image, this.onTap, required this.text, this.submitType});

  @override
  State<ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<ArrowButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: MediaQueryUtil.size(context).width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: widget.submitType! ? cardShadowColor : whiteColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Image.asset(
                    widget.image!,
                    height: 25,
                    width: 25,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      widget.text,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            widget.submitType!
                ? const CircleAvatar(
                    radius: 13,
                    backgroundColor: greenColor,
                    child: Icon(
                      Icons.done,
                      size: 16,
                      color: whiteColor,
                    ),
                  )
                : const Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}
