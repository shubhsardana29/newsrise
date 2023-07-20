import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsrise/newsscreen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _buttonAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _buttonAnimationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add the image from assets folder
            Image.asset(
              'assets/images/newsrise.png', // Replace with the actual image path
              width: 300, // Set the desired width
              height: 300, // Set the desired height
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            _isLoading
                ? CircularProgressIndicator()
                : InkWell(
                    onTap: () {
                      _signIn();
                      _animateButton();
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (_) => NewsScreen(name: "Shubh")),
                      // );
                    },
                    child: AnimatedBuilder(
                      animation: _buttonScaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _buttonScaleAnimation.value,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
                _animateButton();
              },
              child: Text(
                'Create Account',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.black,
                onSurface: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _animateButton() {
    _buttonAnimationController.forward(from: 0.0);
  }
Future<void> _signIn() async {
  final String email = _emailController.text.trim();
  final String password = _passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Sign In Error'),
        content: Text('Please enter both email and password.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
    return; // Return here to prevent further execution
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Only navigate to NewsScreen when sign-in is successful
    navigateToNewsScreen();
  } on FirebaseAuthException catch (e) {
    String errorMessage = 'An error occurred, please try again later.';
    if (e.code == 'user-not-found') {
      errorMessage = 'No user found with this email.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Invalid password.';
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Sign In Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            child: Text('OK'),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}



  void navigateToNewsScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => NewsScreen(name: "Shubh")),
    );
  }
}
