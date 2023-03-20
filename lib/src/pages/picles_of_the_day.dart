import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:good_morning_sunshine/src/pages/initial_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class PiclesOfTheDay extends StatefulWidget {
  const PiclesOfTheDay({Key? key}) : super(key: key);

  @override
  State<PiclesOfTheDay> createState() => _PiclesOfTheDayState();
}

class _PiclesOfTheDayState extends State<PiclesOfTheDay>
    with TickerProviderStateMixin {
  static const _jsonConfigMetadata =
      "https://api.github.com/repos/hericles-koelher/bom_dia_flor_do_dia/contents/config/config.json";
  final _random = Random();
  var _isLoadingConfigData = true;
  Map<String, dynamic>? _configData;
  var _configIndex = 0;
  var _isLoadingImage = true;
  Uint8List? _image;
  late final AnimationController _opacityController = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  late final Animation<double> _opacityAnimation = CurvedAnimation(
    parent: _opacityController,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();

    http.get(Uri.parse(_jsonConfigMetadata)).then((configMetadataResponse) {
      var sha = jsonDecode(configMetadataResponse.body)["sha"];

      var configUrl =
          "https://api.github.com/repos/hericles-koelher/bom_dia_flor_do_dia/git/blobs/$sha";

      http.get(Uri.parse(configUrl)).then((response) {
        var bodyContent = (jsonDecode(response.body)["content"] as String)
            .replaceAll("\n", "");

        _configData = jsonDecode(utf8.decode(base64Decode(bodyContent)));
        _isLoadingConfigData = false;

        _choose();
      });
    });
  }

  _choose() {
    if (_configData != null) {
      _configIndex = _random.nextInt(_configData!["count"] as int);

      http
          .get(Uri.parse(_configData!["images"][_configIndex]))
          .then((response) {
        setState(() {
          _image = response.bodyBytes;
          _isLoadingImage = false;
          _opacityController.animateTo(1.0);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    backToHome() {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const InitialPage()),
        (route) => route.isCurrent,
      );
    }

    return WillPopScope(
      onWillPop: () {
        backToHome();

        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: backToHome,
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Hero(
                tag: "sunflower",
                child: Image.asset("assets/girassol_800x800_transparent.png"),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  if (!_isLoadingConfigData && !_isLoadingImage) ...[
                    FadeTransition(
                      opacity: _opacityAnimation,
                      child: Text(
                        _configData!["phrases"][_configIndex],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.oswald().copyWith(
                          fontSize: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    FadeTransition(
                      opacity: _opacityAnimation,
                      child: Image.memory(_image!),
                    ),
                  ],
                  if (_isLoadingImage) ...[const CircularProgressIndicator()],
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isLoadingImage = true;
                        _opacityController.reset();
                      });

                      _choose();
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      "Recarregar",
                      style: GoogleFonts.oswald(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
