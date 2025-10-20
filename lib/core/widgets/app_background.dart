import 'package:flutter/material.dart';

class AppBackground extends StatefulWidget {
  final Widget child;
  final bool isScrollable; // <-- Tambahan

  const AppBackground({
    super.key,
    required this.child,
    this.isScrollable = true, // default scrollable
  });

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground> {
  final ScrollController _scrollController = ScrollController();
  double scrollY = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        scrollY = _scrollController.offset;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          // 🔵 Animated background
          Positioned(
            top: 100 - scrollY * 0.1,
            left: 30,
            child: _buildBlurCircle(500, Colors.tealAccent.withOpacity(0.15)),
          ),
          Positioned(
            top: 400 + scrollY * 0.08,
            right: 40,
            child: _buildBlurCircle(400, Colors.cyanAccent.withOpacity(0.1)),
          ),
          Positioned(
            bottom: 120 - scrollY * 0.05,
            left: 100,
            child: _buildBlurCircle(350, Colors.teal.withOpacity(0.08)),
          ),

          // 🔹 Page Content
          widget.isScrollable
              ? SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: widget.child,
                ),
              )
              : Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(16),
                child: widget.child,
              ),
        ],
      ),
    );
  }

  Widget _buildBlurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 80)],
      ),
    );
  }
}
