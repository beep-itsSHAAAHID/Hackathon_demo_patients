import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorDetailsPage extends StatefulWidget {
  final Map<String, String> doctor;

  const DoctorDetailsPage({Key? key, required this.doctor}) : super(key: key);

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String selectedDate = '';
  TimeOfDay selectedTime = TimeOfDay.now();
  Map<String, dynamic> appointmentData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctor['name']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage(widget.doctor['image']!),
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.doctor['name']!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Specialization: ${widget.doctor['specialization'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 20),
                Text(
                  'Experience: ${widget.doctor['experience'] ?? 'N/A'} years',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 40),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildDateButtons(),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildTimeButtons(),
              ),
            ),
            SizedBox(height: 40),


            ElevatedButton(
              onPressed: () async {
                try {
                  // Show Snackbar
                  _showSnackbar('Booking appointment...');

                  // Get current user
                  User? user = _auth.currentUser;

                  if (user != null) {
                    // Save appointment data locally
                    appointmentData = {
                      'doctor': widget.doctor['name']!,
                      'date': selectedDate,
                     'time':
                     '${_formatHour(selectedTime.hour)}:${selectedTime.minute == 0 ? '00' : selectedTime.minute} ${_getAmPm(selectedTime)}',
                      'user': user.displayName ?? 'Anonymous',
                    };

                    // Increment the token in Firestore
                    int currentToken = await _incrementToken();
                    appointmentData['token'] = currentToken.toString();

                    // Add appointment data to Firestore
                    await _firestore.collection('bookingdetails').add(appointmentData);

                    // Show completion Snackbar after saving
                    _showSnackbar('Appointment booked successfully!');
                    print('Appointment Data: $appointmentData');

                  } else {
                    // Handle the case where the user is not logged in
                    _showSnackbar('User not logged in!');
                  }
                } catch (e, stackTrace) {
                  print('Error: $e');
                  print('StackTrace: $stackTrace');
                  _showSnackbar('Error booking appointment. Please try again.');
                }
              },
              child: Text('Book Appointment'),
            ),





          ],
        ),
      ),
    );
  }

  List<Widget> _buildDateButtons() {
    List<Widget> buttons = [];
    for (int i = 0; i < 7; i++) {
      DateTime currentDate = DateTime.now().add(Duration(days: i));
      String formattedDate = "${currentDate.day}";
      String weekday = _getWeekday(currentDate);
      buttons.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate =
              "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
            });
          },
          child: Container(
            width: 80,
            margin: EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
              color: selectedDate ==
                  "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}"
                  ? Colors.blue
                  : Colors.grey,
              borderRadius: BorderRadius.circular(22.0),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: selectedDate ==
                        "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}"
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                Text(
                  weekday,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: selectedDate ==
                        "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}"
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return buttons;
  }

  List<Widget> _buildTimeButtons() {
    List<Widget> buttons = [];
    for (int i = 1; i < 4; i++) {
      TimeOfDay currentTime = TimeOfDay(hour: i, minute: 0);
      buttons.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedTime = currentTime;
            });
          },
          child: Container(
            width: 150,
            margin: EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
              color: selectedTime == currentTime
                  ? Colors.blue
                  : Colors.grey,
              borderRadius: BorderRadius.circular(22.0),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  '${_formatHour(currentTime.hour)}:${currentTime.minute == 0 ? '00' : currentTime.minute} ${_getAmPm(currentTime)}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: selectedTime == currentTime
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return buttons;
  }

  String _getWeekday(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  String _formatHour(int hour) {
    if (hour > 12) {
      return (hour - 12).toString();
    } else if (hour == 0) {
      return '12';
    } else {
      return hour.toString();
    }
  }

  String _getAmPm(TimeOfDay time) {
    return time.period == DayPeriod.am ? 'AM' : 'PM';
  }

  void _submitAppointment() async {
    _showSnackbar('Booking appointment...');

    User? user = _auth.currentUser;

    if (user != null) {
      appointmentData = {
        'doctor': widget.doctor['name']!,
        'date': selectedDate,
        'time':
        '${_formatHour(selectedTime.hour)}:${selectedTime.minute == 0 ? '00' : selectedTime.minute} ${_getAmPm(selectedTime)}',
        'user': user.displayName ?? 'Anonymous',
      };

      int currentToken = await _incrementToken();
      appointmentData['token'] = currentToken.toString();

      await _firestore.collection('bookingdetails').add(appointmentData);

      _showSnackbar('Appointment booked successfully!');
    } else {
      _showSnackbar('User not logged in!');
    }
  }

  Future<int> _incrementToken() async {
    DocumentReference tokenRef = _firestore.collection('tokens').doc('current_token');

    return await _firestore.runTransaction((transaction) async {
      DocumentSnapshot tokenSnapshot = await transaction.get(tokenRef);

      if (!tokenSnapshot.exists) {
        // If the document does not exist, create it with a 'value' of 0
        transaction.set(tokenRef, {'value': 0});
        return 1; // Return 1 as the first token number
      }

      // If the document exists, proceed with incrementing the token
      int currentToken = tokenSnapshot.get('value') ?? 0;
      int newToken = currentToken + 1;
      transaction.update(tokenRef, {'value': newToken});
      return newToken;
    });
  }


  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
