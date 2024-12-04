import 'package:flutter/material.dart';
import 'home_page.dart'; // Pastikan file HomePage diimpor dengan benar

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menavigasi ke HomePage setelah 3 detik
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
           
          Image.network(
            'https://plus.unsplash.com/premium_photo-1732730224379-8a0805fa27ef?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyfHx8ZW58MHx8fHx8', 
            fit: BoxFit.cover,
          ),
          
          Container(
            color: Colors.black.withOpacity(0.5), 
          ),
          
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Text(
                  'MovieApp',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                
                Text(
                  'Discover Movies & TV Shows',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
