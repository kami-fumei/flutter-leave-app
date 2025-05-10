import 'package:flutter/material.dart';

Future<dynamic> dialogBox(
  BuildContext context,
  String aTitle,
  aColour,
  aMessage,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text(aTitle, style: TextStyle(color: aColour)),
        contentPadding: EdgeInsets.all(20),
        children: [Text(aMessage)],
      );
    },
  );
}

// 👉 Call this inside a StatefulWidget, having a Scaffold above
void showMessage(BuildContext context, String msg) {
  final snack = SnackBar(
    content: Text(msg),
    behavior: SnackBarBehavior.floating, // 👉 small floating box
    margin: EdgeInsets.all(16),          // 👉 inset from screen edges
    duration: Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snack);
}

//logout
Future<void> confirmLogout(BuildContext ctx) async {
  final bool? confirmed = await showDialog<bool>(
    context: ctx,
    builder: (c) => AlertDialog(
      title: Text('Confirm Logout'),
      content: Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(c).pop(false), // stay logged in
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(c).pop(true),  // confirm
          child: Text('Logout'),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    // todo 👉 perform your logout logic: 
    // await authService.signOut();
    // 👉 then navigate back:
    Navigator.of(ctx).pop(); // or pushNamedAndRemoveUntil(...)
  }
}

