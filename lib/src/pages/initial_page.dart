import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:good_morning_sunshine/src/pages/picles_of_the_day.dart';
import 'package:google_fonts/google_fonts.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage>
    with TickerProviderStateMixin {
  late final AnimationController _opacityController = AnimationController(
    duration: const Duration(milliseconds: 2200),
    vsync: this,
  );

  late final Animation<double> _opacityAnimation = CurvedAnimation(
    parent: _opacityController,
    curve: Curves.easeIn,
  );

  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  );

  late final Animation<double> _scaleAnimation = CurvedAnimation(
    parent: _scaleController,
    curve: Curves.elasticOut,
  );

  var _animationStarted = false;

  @override
  void dispose() {
    _opacityController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fontSize = 32.0;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: InkWell(
          splashColor: Theme.of(context).primaryColorDark,
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: const Duration(seconds: 1),
                pageBuilder: (_, __, ___) => const PiclesOfTheDay(),
              ),
            );
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                        "Bom dia minha",
                        textAlign: TextAlign.center,
                        textStyle: GoogleFonts.oswald().copyWith(
                          fontSize: fontSize,
                          color: Colors.black87.withAlpha(192),
                        ),
                        speed: const Duration(milliseconds: 80),
                      ),
                    ],
                    onNextBeforePause: (_, __) {
                      setState(() {
                        _animationStarted = true;
                        _opacityController.animateTo(1.0);
                        _scaleController.animateTo(1.0);
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Expanded(
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: _animationStarted
                                ? Hero(
                                    tag: "sunflower",
                                    child: Image.asset(
                                      "assets/girassol_800x800_transparent.png",
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      if (_animationStarted) ...[
                        FadeTransition(
                          opacity: _opacityAnimation,
                          child: Text(
                            "Pressione para iniciar",
                            style: GoogleFonts.oswald(),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
