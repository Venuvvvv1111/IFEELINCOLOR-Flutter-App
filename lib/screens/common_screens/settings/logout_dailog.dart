import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LogoutDailog extends StatefulWidget {
  final VoidCallback onpress;
  const LogoutDailog({super.key, required this.onpress});

  @override
  State<LogoutDailog> createState() => _LogoutDailogState();
}

class _LogoutDailogState extends State<LogoutDailog> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/animations/sad.json', height: 150, width: 150),
        ],
      ),
      content: const Text(
        'Are you sure want to Logout?',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: size.width / 4,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.1)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            SizedBox(
              width: size.width / 4,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // First close the dialog
                  Future.delayed(const Duration(milliseconds: 100), () {
                    widget.onpress(); // Then perform logout/navigation
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
