// ignore_for_file: unused_element, unused_local_variable

/// Example usage of ApiServices in repositories
///
/// Import:
/// ```dart
/// import 'package:looklabs/Core/Network/network.dart';
/// ```

void exampleUsage() {
  // GET
  // ApiServices.get(ApiEndpoints.profile);

  // GET with query params
  // ApiServices.get(ApiEndpoints.workout, queryParams: {'page': '1', 'limit': '10'});

  // POST
  // ApiServices.post(ApiEndpoints.login, body: {'email': 'user@mail.com', 'password': '***'});

  // PUT
  // ApiServices.put(ApiEndpoints.userById('123'), body: {'name': 'John'});

  // DELETE
  // ApiServices.delete(ApiEndpoints.userById('123'));

  // Multipart (file upload)
  // ApiServices.multipartPost(
  //   ApiEndpoints.uploadImage,
  //   files: [
  //     MultipartFileItem(fieldName: 'image', filePath: '/path/to/image.jpg'),
  //   ],
  //   fields: {'userId': '123'},
  // );

  // Set auth token (e.g. after login)
  // ApiServices.setAuthToken('your_jwt_token');

  // Handle response
  // final response = await ApiServices.get(ApiEndpoints.profile);
  // if (response.success) {
  //   final data = response.data;
  // } else {
  //   final message = response.message ?? 'Request failed';
  // }
}
