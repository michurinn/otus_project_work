import 'package:flutter/material.dart';

class AnimatedTabWidget extends StatefulWidget {
  const AnimatedTabWidget({
    super.key,
    required this.tabController,
    required this.tab,
    required this.isActive,
    this.newValue,
  });
  final TabController tabController;
  final MapEntry tab;
  final String? newValue;
  final bool isActive;
  @override
  State<AnimatedTabWidget> createState() => __AnimatedTabWidgetState();
}

class __AnimatedTabWidgetState extends State<AnimatedTabWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.tabController.animation!,
      builder: (ctx, snapshot) {
        final forward = widget.tabController.offset > 0;
        final backward = widget.tabController.offset < 0;
        int fromIndex;
        int toIndex;
        double progress;
        int? cachedFromIdx;
        int? cachedToIdx;
        // This value is true during the [animateTo] animation that's triggered when the user taps a [TabBar] tab.
        // It is false when [offset] is changing as a consequence of the user dragging the [TabBarView].
        if (widget.tabController.indexIsChanging) {
          fromIndex = widget.tabController.previousIndex;
          toIndex = widget.tabController.index;
          cachedFromIdx = widget.tabController.previousIndex;
          cachedToIdx = widget.tabController.index;
          progress = (widget.tabController.animation!.value - fromIndex).abs() /
              (toIndex - fromIndex).abs();
        } else {
          if (cachedFromIdx == widget.tabController.previousIndex &&
              cachedToIdx == widget.tabController.index) {
            // When user tap on a tab bar and the animation is completed, it will execute this block
            // This block will not be called when user draging the TabBarView
            fromIndex = cachedFromIdx ?? 0;
            toIndex = cachedToIdx ?? 1;
            progress = 1;
            cachedToIdx = null;
            cachedFromIdx = null;
          } else {
            cachedToIdx = null;
            cachedFromIdx = null;
            fromIndex = widget.tabController.index;
            toIndex = forward
                ? fromIndex + 1
                : backward
                    ? fromIndex - 1
                    : fromIndex;
            progress =
                (widget.tabController.animation!.value - fromIndex).abs();
          }
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: widget.isActive
              ? BoxDecoration(
                  color: widget.tab.key == fromIndex
                      ? Colors.blueGrey
                      : Colors.blueGrey.withOpacity(.3),
                  borderRadius: BorderRadius.circular(200),
                )
              : BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(200),
                ),
          child: Row(
            children: [
              Text(
                widget.tab.value,
                maxLines: 1,
              ),
              if (widget.newValue != null)
                const SizedBox(
                  width: 10,
                ),
              if (widget.newValue != null)
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: (widget.tab.key == toIndex && widget.isActive)
                        ? Colors.blueGrey
                        : Colors.blueGrey,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Center(
                    child: Text(
                      widget.newValue!,
                      maxLines: 1,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
