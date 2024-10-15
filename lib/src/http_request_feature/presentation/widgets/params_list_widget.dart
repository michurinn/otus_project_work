import 'package:flutter/material.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/widgets/query_param_tile_widget.dart';

class ParamsListWidget extends StatefulWidget {
  const ParamsListWidget({
    super.key,
    this.initialList = const <Map<String, String?>>[],
    this.onEditingComplete,
  });

  final Function(Map<String, String>)? onEditingComplete;
  final List<Map<String, String?>> initialList;

  @override
  State<ParamsListWidget> createState() => _ParamsListWidgetState();
}

class _ParamsListWidgetState extends State<ParamsListWidget> {
  late List<Map<String?, String?>> initialList;
  @override
  void initState() {
    super.initState();
    initialList = List.of(widget.initialList)..add({null: null});
  }

  @override
  void didUpdateWidget(covariant ParamsListWidget oldWidget) {
    initialList = List.of(widget.initialList)..add({null: null});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: initialList
            .expand((data) => [
                  QueryParamTileWidget(
                    data: data,
                    onEditingComplete: widget.onEditingComplete,
                  )
                ])
            .toList(),
      ),
    );
  }
}
