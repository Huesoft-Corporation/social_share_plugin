import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:social_share_plugin/social_share_plugin.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SocialSharePlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  static Future<dynamic> _doNothing() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            RaisedButton(
              child: Text('Share to Instagram'),
              onPressed: () async {
                PickedFile? picked = await ImagePicker.platform
                    .pickImage(source: ImageSource.gallery);
                if (picked == null) return;
                await SocialSharePlugin.shareToFeedInstagram(path: picked.path);
              },
            ),
            RaisedButton(
              child: Text('Share to Facebook'),
              onPressed: () async {
                PickedFile? picked = await ImagePicker.platform
                    .pickImage(source: ImageSource.gallery);
                if (picked == null) return;
                await SocialSharePlugin.shareToFeedFacebook(
                    path: picked.path,
                    onSuccess: (_) {
                      print('FACEBOOK SUCCESS');
                      return _doNothing();
                    },
                    onCancel: () {
                      print('FACEBOOK CANCELLED');
                      return _doNothing();
                    },
                    onError: (error) {
                      print('FACEBOOK ERROR $error');
                      return _doNothing();
                    });
              },
            ),
            RaisedButton(
              child: Text('Share to Facebook Link'),
              onPressed: () async {
                String url = 'https://flutter.dev/';
                final quote =
                    'Flutter is Google???s portable UI toolkit for building beautiful, natively-compiled applications for mobile, web, and desktop from a single codebase.';
                final result = await SocialSharePlugin.shareToFeedFacebookLink(
                  quote: quote,
                  url: url,
                  onSuccess: (_) {
                    print('FACEBOOK SUCCESS');
                    return _doNothing();
                  },
                  onCancel: () {
                    print('FACEBOOK CANCELLED');
                    return _doNothing();
                  },
                  onError: (error) {
                    print('FACEBOOK ERROR $error');
                    return _doNothing();
                  },
                );

                print(result);
              },
            ),
          ],
        ),
      ),
    );
  }
}
