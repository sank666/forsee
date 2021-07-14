import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foresee_cycles/pages/auth/login.dart';
import 'package:foresee_cycles/utils/styles.dart';
import 'package:foresee_cycles/utils/constant_data.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 26.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? CustomColors.secondaryColor : CustomColors.secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color(0xFFffebbb),
                Color(0xFFfbceac),
                Color(0xFFf48988),
                Color(0xFFef6786),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _currentPage != _numPages - 1  ?
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: CustomColors.primaryColor,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ) : SizedBox(height: 75,),
                Container(
                  height: screenSize.height * 0.8,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  ConstantsData.welcomeOne,
                                ),
                                height: screenSize.height * 0.4,
                                width: screenSize.height * 0.4,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Connect people\naround the world',
                              style: TextStyle(
                                color: CustomColors.yellowLightColor,
                                fontSize: 26.0,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                              style: TextStyle(
                                color: CustomColors.yellowLightColor,
                                fontSize: 18.0,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  ConstantsData.welcomeTwo,
                                ),
                                height: screenSize.height * 0.4,
                                width: screenSize.height * 0.4,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Live your life smarter\nwith us!',
                              style: TextStyle(
                                color: CustomColors.yellowLightColor,
                                fontSize: 26.0,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                              style: TextStyle(
                                color: CustomColors.yellowLightColor,
                                fontSize: 18.0,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  ConstantsData.welcomeThree,
                                ),
                                height: screenSize.height * 0.4,
                                width: screenSize.height * 0.4,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Get a new experience\nof imagination',
                              style: TextStyle(
                                color: CustomColors.yellowLightColor,
                                fontSize: 26.0,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                              style: TextStyle(
                                color: CustomColors.yellowLightColor,
                                fontSize: 18.0,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
      ? GestureDetector(
        onTap: () {
          print('Get started');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        },
        child: Container(
          height: screenSize.height * 0.1,
          width: double.infinity,
          color: CustomColors.secondaryColor,
            child: Center(
              child: Text(
                'Get started',
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
      : SizedBox(),
    );
  }
}