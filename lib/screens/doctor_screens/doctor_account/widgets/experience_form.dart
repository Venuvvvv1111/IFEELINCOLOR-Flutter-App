import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/doctor_controllers/account_controllers/get_doctor_profile_controller.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class ExperienceForm extends StatefulWidget {
  final GetDoctorProfileController controller;

  const ExperienceForm({super.key, required this.controller});

  @override
  State<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<ExperienceForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(
                  width: MediaQueryUtil.size(context).width,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 10,
                      right: 10,
                      bottom: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildExperienceList(context),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Add New Experince',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        editInputFeilds(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExperienceList(BuildContext context) {
    return Obx(() {
      if (widget.controller.existingExperiences.isEmpty) {
        return Text(
          "No previous experiences added.",
          style: Theme.of(context).textTheme.bodySmall,
        );
      }

      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap:
            true, // Important for embedding inside another scrollable view
        itemCount: widget.controller.existingExperiences.length,
        itemBuilder: (context, index) {
          final experience = widget.controller.existingExperiences[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leading content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          experience['name'] ?? 'Unknown Role',
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Specialty: ${experience['specialty'] ?? 'N/A'}"),
                        Text(
                            "Organization: ${experience['organizationName'] ?? 'N/A'}"),
                        Text(
                          "Duration: ${MediaQueryUtil.formatDateWithSuffix(DateTime.parse('${experience['startDate']}'))}"
                          " - ${MediaQueryUtil.formatDateWithSuffix(DateTime.parse('${experience['endDate']}'))}",
                        ),
                      ],
                    ),
                  ),
                  // Trailing Icon positioned at the bottom right
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _removeExperience(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _removeExperience(int index) {
    widget.controller.existingExperiences.removeAt(index);
    Fluttertoast.showToast(
      msg: "Experience removed successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  Widget editInputFeilds(BuildContext context) {
    return Column(
      children: [
        Container(
          color: whiteColor,
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(3000),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            widget.controller.start = selectedDate;
                            widget.controller.end = null;
                          });
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "From Date",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Image.asset(
                                  AppIcons.calenderIcon,
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.controller.start != null
                                          ? "${widget.controller.start?.day} ${Constants.kMonthsList[widget.controller.start!.month - 1]}, ${widget.controller.start?.year} "
                                          : "--/--",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        if (widget.controller.start != null) {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: widget.controller.end ??
                                widget.controller.start!,
                            //end ?? start!,
                            firstDate: widget.controller.start!,
                            lastDate: DateTime(3000),
                          );

                          if (selectedDate != null) {
                            widget.controller.end = selectedDate;
                            setState(() {});
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please select start date first");
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "To Date",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Image.asset(
                                  AppIcons.calenderIcon,
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.controller.end != null
                                          ? "${widget.controller.end?.day} ${Constants.kMonthsList[widget.controller.end!.month - 1]}, ${widget.controller.end?.year}"
                                          : "--/--",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: widget.controller.currentRoleEditController.value,
                  focusNode: widget.controller.emailEditFocusNode,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: whiteColor,
                    label: const Text('Current Role'),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Enter Role',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      widget.controller.validateEmail(value ?? ''),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: widget.controller.spetialityEditController.value,
                  focusNode: widget.controller.mobileEditFocusNode,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    filled: true,
                    label: const Text('Specialty'),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    fillColor: whiteColor,
                    hintText: 'Enter Specialty',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      widget.controller.validateMobile(value ?? ''),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller:
                      widget.controller.oreganizationEditController.value,
                  decoration: InputDecoration(
                    label: const Text('Organization'),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: whiteColor,
                    hintText: 'Enter Organization',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: const OutlineInputBorder(),
                  ),
                  // validator: (value) =>
                  //     widget.controller.validateDob(value ?? ''),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: widget.controller.aboutEditController.value,
                  // focusNode: widget.controller.addressEditFocusNode,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: whiteColor,
                    label: const Text('About'),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Enter Objective',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      widget.controller.validatePassword(value ?? ''),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQueryUtil.size(context).width,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.controller.updateProfile(context);
                      });
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
