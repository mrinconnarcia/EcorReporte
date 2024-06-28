import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('../assets/eco_reporte_logo.png', height: 200),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Iniciar sesión'),
                style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(8),
                        // ),
                      ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Registrase'),
                style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(8),
                        // ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}