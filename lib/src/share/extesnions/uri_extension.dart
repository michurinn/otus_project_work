extension IsUri on Uri? {
  bool get isValid => this != null;
}

extension AddQueryParams on Uri {
  Uri addQueryParams(Map<String, dynamic> newQuery) => Uri(
        fragment: fragment,
        host: host,
        path: path,
        //pathSegments: pathSegments,
        port: port,
        query: query,
        queryParameters: newQuery,
        scheme: scheme,
        userInfo: userInfo,
      );
}
