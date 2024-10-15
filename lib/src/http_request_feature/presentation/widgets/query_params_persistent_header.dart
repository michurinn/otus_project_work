import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/widgets/basic_auth_widget.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/widgets/params_list_widget.dart';
import 'package:new_flutter_template/src/share/enum/request_options_enum.dart';

/// The widget contains fields for the data of Headers, Body, etc.
class QueryParamsPersistentHeader implements SliverPersistentHeaderDelegate {
  final TickerProvider ticker;
  final RequestOptionsEnum mode;
  Function(int, Map<String, String>) onEditingComplete;
  Function(String, String)? onBaseAuthEdited;

  QueryParamsPersistentHeader({
    required this.ticker,
    required this.mode,
    required this.onEditingComplete,
    this.onBaseAuthEdited,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return switch (mode) {
      RequestOptionsEnum.auth => BasicAuthWidget(
          onBaseAuthEdited: (p0, p1) => onBaseAuthEdited?.call(p0, p1),
        ),
      RequestOptionsEnum.body => const SizedBox.shrink(),
      /// TODO(me): add the feature here
      // ParamsListWidget(
      //     onEditingComplete: (data) => onEditingComplete(0, data),
      //   ),
      RequestOptionsEnum.headers =>
        ParamsListWidget(
          onEditingComplete: (data) => onEditingComplete(1, data),
        ),
      RequestOptionsEnum.queryParams => const SizedBox.shrink(),
      /// TODO(me): add the feature here
      //  ParamsListWidget(
      //     onEditingComplete: (data) => onEditingComplete(2, data),
      //   ),
    };
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      null;

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration => null;

  @override
  TickerProvider? get vsync => ticker;
}
