import 'package:flutter/material.dart';
import 'package:new_flutter_template/src/http_request_feature/presentation/widgets/query_param_tile_widget.dart';
import 'package:new_flutter_template/src/share/typedefs/typedef_json.dart';

class ParamsListWidget extends StatefulWidget {
  const ParamsListWidget({
    super.key,
    this.initialList = const {},
    this.onEditingComplete,
  });

  final Function(Json)? onEditingComplete;
  final Json initialList;

  @override
  State<ParamsListWidget> createState() => _ParamsListWidgetState();
}

class _ParamsListWidgetState extends State<ParamsListWidget> {
  late Json paramsList;

  @override
  void initState() {
    super.initState();
    paramsList = widget.initialList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        ...paramsList.keys.expand((key) => [
              QueryParamTileWidget(
                data: {key: paramsList[key]},
                onEditingComplete: widget.onEditingComplete,
              )
            ]),
        Center(
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              /// Add the new fileds for additional params here
              setState(() {
                paramsList.addEntries([const MapEntry('', '')]);
              });
            },
          ),
        )
      ]),
    );
  }
}
