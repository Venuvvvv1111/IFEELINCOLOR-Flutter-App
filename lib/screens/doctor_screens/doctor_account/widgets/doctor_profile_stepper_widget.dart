import 'package:flutter/material.dart';
import 'package:ifeelin_color/models/doctor_models/doctor_profile_model.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:intl/intl.dart';
import 'package:stepper_list_view/stepper_list_view.dart';

class DoctorStepperWidget extends StatelessWidget {
  const DoctorStepperWidget({super.key, required this.careerpathList});

  final List<Careerpath> careerpathList;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Convert careerpathList to stepperData
    final stepperData = List.generate(
      careerpathList.length,
      (index) {
        final data = careerpathList[index];
        return StepperItemData(
          id: '$index',
          content: {
            "startDate": data.startDate ?? "",
            "endDate": data.endDate ?? '',
            "description": data.description ?? "",
            "specialty": data.specialty ?? "",
            "organizationName": data.organizationName ?? "",
            'name': data.name ?? '',
          },
        );
      },
    ).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StepperListView(
        shrinkWrap: true,
        showStepperInLast: false,
        stepperData: stepperData,
        stepAvatar: (_, data) {
          return const PreferredSize(
            preferredSize: Size.fromRadius(8),
            child: CircleAvatar(
              backgroundColor: newIdentitiyPrimaryColor,
              radius: 8,
            ),
          );
        },
        stepWidget: (_, data) {
          String formatDate(String dateStr) {
            if (dateStr.isEmpty) return '';
            final date = DateTime.parse(dateStr);
            return DateFormat('MM/dd/yyyy').format(date);
          }

          final stepData = data as StepperItemData;
          return PreferredSize(
            preferredSize: const Size.fromWidth(30),
            child: Text(
              "${formatDate(stepData.content['startDate'])} \nto ${formatDate(stepData.content['endDate'])}",
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
        stepContentWidget: (_, data) {
          final stepData = data as StepperItemData;
          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              margin: const EdgeInsets.only(
                top: 10,
              ),
              padding: const EdgeInsets.all(
                10,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'role: ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Expanded(
                        child: Text(
                          stepData.content['name'] ?? '',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'specialty: ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Expanded(
                        child: Text(
                          stepData.content['specialty'] ?? '',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'organizationName: ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Expanded(
                        child: Text(
                          stepData.content['organizationName'] ?? '',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'description: ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Expanded(
                        child: Text(
                          stepData.content['description'] ?? '',
                        ),
                      ),
                    ],
                  )
                ],
              )
              // ListTile(
              //   contentPadding: const EdgeInsets.all(7),
              //   title: Text(
              //     stepData.content['name'] ?? '',
              //     style: Theme.of(context).textTheme.titleSmall,
              //   ),
              //   subtitle: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         stepData.content['occupation'] ?? '',
              //         style: Theme.of(context).textTheme.bodySmall,
              //         maxLines: 4,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //     ],
              //   ),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(8),
              //     side: BorderSide(
              //       color: theme.dividerColor,
              //       width: 0.8,
              //     ),
              //   ),
              // ),
              );
        },
        stepperThemeData: StepperThemeData(
          lineColor: theme.primaryColor,
          lineWidth: 5,
        ),
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
