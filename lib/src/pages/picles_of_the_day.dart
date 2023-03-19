import 'package:flutter/material.dart';
import 'package:good_morning_sunshine/src/pages/initial_page.dart';
import 'package:google_fonts/google_fonts.dart';

class PiclesOfTheDay extends StatefulWidget {
  const PiclesOfTheDay({Key? key}) : super(key: key);

  @override
  State<PiclesOfTheDay> createState() => _PiclesOfTheDayState();
}

class _PiclesOfTheDayState extends State<PiclesOfTheDay> {
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
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: backToHome,
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CircleAvatar(
                child: Hero(
                  tag: "sunflower",
                  child: Image.asset("assets/girassol_800x800_transparent.png"),
                ),
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
                  Text(
                    "PLACEHOLDER TEXT",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oswald().copyWith(
                      fontSize: 20,
                    ),
                  ),
                  Icon(Icons.bolt_sharp),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {},
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
