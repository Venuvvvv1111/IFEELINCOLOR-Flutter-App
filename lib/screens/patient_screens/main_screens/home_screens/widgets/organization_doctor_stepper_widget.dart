import 'package:flutter/material.dart';
import 'package:ifeelin_color/models/patient_models/organization_doctors_model.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:stepper_list_view/stepper_list_view.dart';

import 'package:ifeelin_color/models/patient_models/organization_doctors_model.dart'
    as organization_doctor;

class OrganizationDoctorStepperWidget extends StatelessWidget {
  const OrganizationDoctorStepperWidget(
      {super.key, required this.careerpathList});

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
            'name': data.name ?? '',
            'occupation': data.description ?? '',
            'born_date': data.duration ?? '',
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
          final stepData = data as StepperItemData;
          return PreferredSize(
            preferredSize: const Size.fromWidth(30),
            child: Text(
              stepData.content['born_date'] ?? '',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
        stepContentWidget: (_, data) {
          final stepData = data as StepperItemData;
          return Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            padding: const EdgeInsets.all(
              10,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(7),
              title: Text(
                stepData.content['name'] ?? '',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stepData.content['occupation'] ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: theme.dividerColor,
                  width: 0.8,
                ),
              ),
            ),
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

class SubscribedOrganizationDoctorStepperWidget extends StatelessWidget {
  const SubscribedOrganizationDoctorStepperWidget(
      {super.key, required this.careerpathList});

  final List<organization_doctor.Careerpath> careerpathList;

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
            'name': data.name ?? '',
            'occupation': data.description ?? '',
            'born_date': data.duration ?? '',
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
          final stepData = data as StepperItemData;
          return PreferredSize(
            preferredSize: const Size.fromWidth(30),
            child: Text(
              stepData.content['born_date'] ?? '',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
        stepContentWidget: (_, data) {
          final stepData = data as StepperItemData;
          return Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            padding: const EdgeInsets.all(
              10,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(7),
              title: Text(
                stepData.content['name'] ?? '',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stepData.content['occupation'] ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: theme.dividerColor,
                  width: 0.8,
                ),
              ),
            ),
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
