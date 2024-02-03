import 'package:flutter/material.dart';

Widget buildSpecializationList() {
  List<String> doctorSpecializations = [
    'Cardiologist',
    'Dermatologist',
    'Gynecologist',
    'Orthopedic',
    // Add more specializations as needed
  ];

  return ListView(
    scrollDirection: Axis.horizontal, // Set the scroll direction to horizontal
    children: [
      for (var specialization in doctorSpecializations)
        Padding(
          padding: EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              // Implement logic to handle when a specialization is selected
              // For example, you can navigate to a screen with doctors in the selected specialization.
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(8.0),
              child: Text(specialization),
            ),
          ),
        ),
    ],
  );
}