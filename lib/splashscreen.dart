import 'package:flutter/material.dart';
import 'package:newsrise/authscreen.dart';
import 'package:newsrise/newsscreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500), // Adjust the duration as needed
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5), // Start fading in from 0.0 to 0.5 of the animation
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1.0), // Start scaling from 0.5 to 1.0 of the animation
      ),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(Duration(milliseconds: 500)); // Add a small delay before starting the animation

    // Start the animation
    _animationController.forward().whenComplete(() {
      // When the animation completes, navigate to the AuthScreen
      navigateToAuthScreen();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> navigateToAuthScreen() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate a delay of 1 second

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image with Positioned to control the size
            Positioned.fill(
              child: Center(
                child: FractionalTranslation(
                  translation: Offset(0.0, 0.2), // Adjust the offset to center the image vertically
                  child: Image.asset(
                    'assets/images/newsrise.png',
                    width: 300, // Set the desired width for the image
                    height: 300, // Set the desired height for the image
                  ),
                ),
              ),
            ),
            // Column containing the image and text
            Column(
              mainAxisAlignment: MainAxisAlignment.end, // Align the text to the bottom
              children: [
                // Animated Fading and Scaling Text wrapped in Padding
                Padding(
                  padding: EdgeInsets.only(bottom: 50.0), // Adjust the spacing as needed
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Center(
                            child: Text(
                              'News Rise',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
