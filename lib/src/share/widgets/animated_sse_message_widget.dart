import 'package:flutter/material.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';

/// the Widget for animation the opacity of the sse event
class AnimatedSseMessageWidget extends StatefulWidget {
  const AnimatedSseMessageWidget({super.key, required this.message});
  final SSEModel message;

  @override
  State<AnimatedSseMessageWidget> createState() =>
      _AnimatedSseMessageWidgetState();
}

class _AnimatedSseMessageWidgetState extends State<AnimatedSseMessageWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Opacity(
        opacity: _animation.value,
        child: child,
      ),
      child: Column(
        children: [
          Text(
            widget.message.id ?? '',
          ),
          Text(
            widget.message.event ?? '',
          ),
          Text(
            widget.message.data ?? '',
          ),
        ],
      ),
    );
  }
}
