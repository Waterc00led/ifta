import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'About Us',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'We are a team of passionate individuals who love to create amazing applications. Our mission is to deliver the best user experience and make our customers happy.',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Card(
  child: ListTile(
    title: Text(
      'Email Us',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w800,
        fontSize: 20,
      ),
    ),
    subtitle: GestureDetector(
      onTap: () async {
        const url = 'mailto:info@ourcompany.com';
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Text(
        'info@ourcompany.com',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
      ),
    ),
  ),
),
SizedBox(height: 20),
Card(
  child: ListTile(
    title: Text(
      'Call Us',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w800,
        fontSize: 20,
      ),
    ),
    subtitle: GestureDetector(
      onTap: () async {
        const url = 'tel:+1 888 276 3009';
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Text(
        '+1 888 276 3009',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
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
}