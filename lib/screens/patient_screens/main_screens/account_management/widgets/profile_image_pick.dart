import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class ProfileImageDialog extends StatefulWidget {
  final String buttonText, title;
  final IconData messageIcon;
  final Color backgroundColor;
  final VoidCallback onButtonPress, onCameraPress, onPhotoLibraryPress;

  const ProfileImageDialog(
      {super.key,
      required this.backgroundColor,
      required this.title,
      required this.buttonText,
      required this.messageIcon,
      required this.onButtonPress,
      required this.onCameraPress,
      required this.onPhotoLibraryPress});

  @override
  State<ProfileImageDialog> createState() => _ProfileImageDialogState();
}

class _ProfileImageDialogState extends State<ProfileImageDialog> {
  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        //...bottom card part,
        Container(
          padding: const EdgeInsets.only(
            top: 40 + 16,
          ),
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
            color: whiteColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: Colors.black),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: widget.onPhotoLibraryPress,
                      icon: const Icon(
                        FontAwesomeIcons.images,
                        color: Colors.black,
                      ),
                      label: const Text(
                        'Select a photo from gallery',
                        style: TextStyle(
                            fontSize: 14, height: 1.2, color: Colors.black),
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: widget.onCameraPress,
                      icon: const Icon(
                        FontAwesomeIcons.camera,
                        color: Colors.black,
                      ),
                      label: const Text(
                        'Take a photo with camera',
                        style: TextStyle(
                            fontSize: 14, height: 1.2, color: Colors.black),
                      ),
                    ),
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: TextButton(
                        onPressed: widget.onButtonPress,
                        style: TextButton.styleFrom(
                          backgroundColor: widget.backgroundColor,
                        ),
                        child: Text(
                          widget.buttonText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                              color: whiteColor),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: widget.backgroundColor,
            radius: 40,
            child: Icon(
              widget.messageIcon,
              size: 30,
              color: whiteColor,
            ),
          ),
        ), //...top circlular image part,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
