import 'package:flutter/material.dart';


class AppointmentDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var globals;
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor: ${globals.appointmentData['doctor']}'),
            Text('Date: ${globals.appointmentData['date']}'),
            Text('Time: ${globals.appointmentData['time']}'),
            // Add more details if needed
          ],
        ),
      ),
    );
  }
}