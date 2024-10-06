/// The enum for Request Type (GET, POST, PUT, REPLACE)
enum RequestTypeEnum {
  get(stringRepresentation: 'GET'),
  post(stringRepresentation: 'POST');

  final String stringRepresentation;
  const RequestTypeEnum({required this.stringRepresentation});
}
