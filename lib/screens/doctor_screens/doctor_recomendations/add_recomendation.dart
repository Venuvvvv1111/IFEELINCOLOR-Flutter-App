import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/models/doctor_models/subscribed_patients_model.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/app_images.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:ifeelin_color/controllers/doctor_controllers/recomendation_controllers/add_recomendation_controller.dart';
import 'package:ifeelin_color/utils/helpers/url_launcher_helper.dart';

class AddRecommendationScreen extends StatelessWidget {
  final Patient? patient;
  AddRecommendationScreen({super.key, required this.patient});

  final RecommendationController controller =
      Get.put(RecommendationController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF033A98),
          actions: [
            CircleAvatar(
              backgroundColor: whiteColor,
              child: IconButton(
                icon: Image(image: AssetImage(AppIcons.notificationIcon)),
                onPressed: () {
                  Navigator.pushNamed(
                      context, AppRoutes.allNotificationsScreen);
                },
              ),
            ),
            const SizedBox(width: 10),
          ],
          title: const Text(
            'Add Recommendations',
            style: TextStyle(height: 1.2, color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileCard(context),
                const SizedBox(height: 16),

                // Recommendation Text Input
                Card(
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (value) =>
                              controller.recommendationText.value = value,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Type your recommendation',
                            labelStyle: TextStyle(
                              fontSize: 14, // Set the font size for the label
                              color: Colors.grey[700], // Adjust color as needed
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Please type your recomendation..',
                            hintStyle: const TextStyle(fontSize: 13),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey, // Light border color
                                width: 1.0, // Lighten the border width
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    doctorPrimaryColor, // Border color when focused
                                width: 1.0, // Lighten the focused border width
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Category Container
                        Container(
                          color: doctorPrimaryColorLight,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                                controller.categories.length, (index) {
                              return Flexible(
                                child: _buildCategoryContainer(
                                  index,
                                  controller.categories[index]['label']!,
                                  controller.categories[index]['icon']!,
                                ),
                              );
                            }),
                          ),
                        ),

                        // Items Section
                        Obx(() {
                          int selectedCategory =
                              controller.selectedCategory.value;
                          List<dynamic> items = [];

                          // Show items based on the selected category
                          if (selectedCategory == 0) {
                            items = controller.images;
                          } else if (selectedCategory == 1) {
                            items = controller.documents;
                          } else if (selectedCategory == 2) {
                            items = controller.links;
                          }

                          return SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  // Show existing items in the selected category
                                  ...items.map((item) {
                                    return _buildItemContainer(
                                        selectedCategory, item, context);
                                    // ignore: unnecessary_to_list_in_spreads
                                  }).toList(),
                                  // Add a "+" button to add new items
                                  _buildAddItemButton(selectedCategory),
                                ],
                              ),
                            ),
                          );
                        }),

                        Obx(() {
                          return controller.selectedCategory.value == 1
                              ? const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Note: Only pdf format is allowed',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 13),
                                  ),
                                )
                              : const SizedBox();
                        }),

                        // Submit Button
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.recommendationText.value.isEmpty) {
                  MyToast.showGetToast(
                      title: 'Error',
                      message: 'please fill the required fields',
                      color: Colors.white,
                      backgroundColor: Colors.red);
                } else {
                  controller.sendRecommendation(
                      patient?.sId ?? '', context); // Pass patient ID
                }
              },
              child: const Text('Send Recommendation'),
            ),
          ],
        ),
      ),
    );
  }

  // Profile Header

  Widget _buildProfileCard(BuildContext context) {
    return Card(
      color: whiteColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  width: 50,
                  child: ClipOval(
                    child: LoadNetworkImage(
                      patient?.image.toString() ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          patient?.userName.toString() ?? "",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                              image: AssetImage(AppIcons.userLocationIcon),
                              height: 17,
                              width: 17,
                            ),
                            Expanded(
                              child: Text(
                                patient?.location.toString() ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: secondaryFontColor,
                                        fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildProfileOptions(context),
        ],
      ),
    );
  }

  Widget _buildProfileOptions(context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: const BoxDecoration(color: Color(0xFFEDF0FC)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppRoutes.patientIntakeDetailsScreen,
                        arguments: patient?.sId);
                  },
                  child: _buildProfileOption('Intake Details'))),
          const Spacer(),
          GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.arrow_forward_ios_outlined,
                color: doctorTextColor,
              )),
        ],
      ),
    );
  }

  Widget _buildProfileOption(String title) {
    return Row(
      children: [
        Image.asset(
          AppImages.intakeImage,
          height: 20,
          width: 20,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: doctorTextColor),
        ),
      ],
    );
  }

  Widget _buildCategoryContainer(int index, String label, String image) {
    return Obx(() {
      // Check if the current category index is selected
      bool isSelected = controller.selectedCategory.value == index;
      return GestureDetector(
        onTap: () {
          controller.updateCategory(index); // Update category by index
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? Colors.blueAccent : Colors.grey[300],
            border:
                isSelected ? Border.all(color: Colors.blue, width: 2) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage(image), height: 20, width: 20),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.black, // Change text color
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Add Item Button based on the selected category
  Widget _buildAddItemButton(int selectedCategory) {
    return GestureDetector(
      onTap: () {
        if (selectedCategory == 0) {
          controller
              .pickImages(); // Add images if selectedCategory is 0 (images)
        } else if (selectedCategory == 1) {
          controller
              .pickDocument(); // Add documents if selectedCategory is 1 (documents)
        } else if (selectedCategory == 2) {
          controller
              .addVideoLink(); // Add video links if selectedCategory is 2 (links)
        }
      },
      child: Container(
        width: 70,
        height: 70,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
        ),
        child: const Icon(Icons.add, size: 40, color: Colors.black54),
      ),
    );
  }
// Inside AddRecommendationScreen class...

  Widget _buildItemContainer(
      int selectedCategory, dynamic item, BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(5),
          height: 70,
          width: 70,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: selectedCategory == 0
                ? Image.file(File(item.path),
                    fit: BoxFit.cover, height: 70, width: 70)
                : selectedCategory == 1
                    ? InkWell(
                        onTap: () {
                          controller.previewPDF(item.path, context);
                        },
                        child: Center(child: Image.asset(AppIcons.pdfIcon)),
                      )
                    : selectedCategory == 2
                        ? InkWell(
                            onTap: () async {
                              URLLauncherHelper.openURL(item);
                              // Open the link in a browser when tapped
                            },
                            child: Center(
                                child: Image.asset(AppIcons.videoLinkIcon)),
                          )
                        : const SizedBox.shrink(),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => controller.removeItem(selectedCategory, item),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}
