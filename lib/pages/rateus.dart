import 'package:flutter/material.dart';

class RateUs extends StatefulWidget {
  const RateUs({Key? key}) : super(key: key);

  @override
  State<RateUs> createState() => _RateUsState();
}

class _RateUsState extends State<RateUs> {
  int? _rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Us'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Rate Our App',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            _buildStarRating(),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: _rating != null ? _submitRating : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white), // Background color
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // Rounded corners
                  ),
                ),
                elevation: MaterialStateProperty.all<double>(5.0), // Shadow
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.deepPurpleAccent.withOpacity(
                          0.5); // Change to accent color when pressed
                    return null; // Use the default overlay color
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildStar(1),
        _buildStar(2),
        _buildStar(3),
        _buildStar(4),
        _buildStar(5),
      ],
    );
  }

  Widget _buildStar(int index) {
    return IconButton(
      iconSize: _rating != null && index <= _rating! ? 45.0 : 40.0,
      icon: Icon(
        _rating == null || _rating! < index ? Icons.star_border : Icons.star,
        color:
            _rating != null && index <= _rating! ? Colors.amber : Colors.grey,
      ),
      onPressed: () => _setRating(index),
    );
  }

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  void _submitRating() {
    if (_rating != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thank You!'),
            content: Text(
                'Thank you for rating us $_rating stars! Your feedback is valuable to us.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: RateUs(),
  ));
}
