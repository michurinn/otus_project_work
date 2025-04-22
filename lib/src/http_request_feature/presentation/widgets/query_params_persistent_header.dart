import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_bloc.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/bloc/http_request_feature_state.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/widgets/basic_auth_widget.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/widgets/params_list_widget.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/widgets/requet_body_widget.dart';
import 'package:new_flutter_template/src/share/enum/request_options_enum.dart';

/// The widget contains fields for the data of Headers, Body, etc.
class QueryParamsPersistentHeader implements SliverPersistentHeaderDelegate {
  final TickerProvider ticker;
  final RequestOptionsEnum mode;
  Function(int, Map<String, String>) onEditingComplete;
  Function(int, Map<String, String>) onQueryParamsEditingComplete;
  Function(String, String)? onBaseAuthEdited;
  Function(String)? onBodyEdited;

  QueryParamsPersistentHeader({
    required this.ticker,
    required this.mode,
    required this.onEditingComplete,
    required this.onQueryParamsEditingComplete,
    this.onBaseAuthEdited,
    this.onBodyEdited,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return BlocBuilder<HttpRequestFeatureBloc, HttpRequestFeatureState>(
      builder: (context, state) {
        return switch (mode) {
          RequestOptionsEnum.auth => BasicAuthWidget(
              onBaseAuthEdited: (p0, p1) => onBaseAuthEdited?.call(p0, p1),
            ),
          RequestOptionsEnum.body => RequestBodyWidget(
              onEditingComplete: (data) => onBodyEdited?.call(data),
            ),
          RequestOptionsEnum.headers => ParamsListWidget(
              onEditingComplete: (data) => onEditingComplete(1,
                  {data.keys.first.toString(): data.values.first.toString()}),
              initialList: state.queryParams?['1'] ?? {},
            ),
          RequestOptionsEnum.queryParams => ParamsListWidget(
              onEditingComplete: (data) => onQueryParamsEditingComplete(
                2,
                data.map(
                  (key, value) => MapEntry(
                    key,
                    value.toString(),
                  ),
                ),
              ),
              initialList: state.queryParams?['0'] ?? {},
            ),
        };
      },
    );
  }

  @override
  double get maxExtent => 150;

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
