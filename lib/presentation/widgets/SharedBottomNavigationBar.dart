import 'package:flutter/material.dart';

class SharedBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  SharedBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Ajusta esta altura según tus necesidades
      decoration: BoxDecoration(
        color: Color(0xFF9DE976),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_outlined, 0),
          _buildNavItem(Icons.info_outline, 1),
          _buildNavItem(Icons.add_circle_outline, 2),
          _buildNavItem(Icons.article_outlined, 3),
          _buildNavItem(Icons.person_outline, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.blue : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Color.fromARGB(255, 61, 61, 61),
          size: 24,
        ),
      ),
    );
  }
}