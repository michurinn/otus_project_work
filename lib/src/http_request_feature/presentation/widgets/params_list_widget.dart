import 'package:flutter/material.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/widgets/query_param_tile_widget.dart';

class ParamsListWidget extends StatelessWidget {
  const ParamsListWidget({
    super.key,
    this.initialList = const <Map<String, String?>>[],
    this.onEditingComplete,
  });

  final Function(Map<String, String>)? onEditingComplete;
  final List<Map<String, String?>> initialList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: initialList
            .expand((data) => [
                  QueryParamTileWidget(
                    data: data,
                    onEditingComplete: onEditingComplete,
                  )
                ])
            .toList(),
      ),
    );
  }
}
