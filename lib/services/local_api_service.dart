import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:grocery_store/model/category_model.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CatalogSearchResult {
  const CatalogSearchResult({
    required this.query,
    required this.categories,
    required this.products,
  });

  final String query;
  final List<CategoryModel> categories;
  final List<FruitModel> products;
}

class LocalApiService {
  LocalApiService({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ?? _defaultBaseUrl,
        _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  static String get _defaultBaseUrl {
    const definedBaseUrl =
        String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (definedBaseUrl.isNotEmpty) return definedBaseUrl;

    if (kIsWeb) return 'http://127.0.0.1:8000';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://172.20.10.3:8000';
    }
    return 'http://127.0.0.1:8000';
  }

  Future<List<CategoryModel>> listCategories() async {
    final url = '$baseUrl/categories/';
    _logRequest('GET', url);
    final response = await _client.get(Uri.parse(url));
    _logResponse('GET', url, response);
    _ensureSuccess(response);
    final items = _extractList(_decodeBody(response.body),
        listKeys: const ['categories']);
    return items.map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<CategoryModel> createCategory(
    Map<String, dynamic> payload,
  ) async {
    final url = '$baseUrl/categories/';
    final response = await _sendJsonWithRedirect(
      method: 'POST',
      url: url,
      body: payload,
    );
    _ensureSuccess(response);
    return CategoryModel.fromJson(_extractMap(_decodeBody(response.body)));
  }

  Future<CategoryModel> updateCategory(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final url = '$baseUrl/categories/$id/';
    final response = await _sendJsonWithRedirect(
      method: 'PUT',
      url: url,
      body: payload,
    );
    _ensureSuccess(response);
    return CategoryModel.fromJson(_extractMap(_decodeBody(response.body)));
  }

  Future<void> deleteCategory(int id) async {
    final url = '$baseUrl/categories/$id/';
    final response = await _sendJsonWithRedirect(
      method: 'DELETE',
      url: url,
    );
    _ensureSuccess(response);
  }

  Future<List<FruitModel>> listProducts() async {
    final url = '$baseUrl/products/';
    _logRequest('GET', url);
    final response = await _client.get(Uri.parse(url));
    _logResponse('GET', url, response);
    _ensureSuccess(response);
    final items =
        _extractList(_decodeBody(response.body), listKeys: const ['products']);
    return items.map((e) => FruitModel.fromJson(e, baseUrl: baseUrl)).toList();
  }

  Future<FruitModel> createProduct(
    Map<String, dynamic> payload,
  ) async {
    final url = '$baseUrl/products/';
    final response = await _sendJsonWithRedirect(
      method: 'POST',
      url: url,
      body: payload,
    );
    _ensureSuccess(response);
    return FruitModel.fromJson(
      _extractMap(_decodeBody(response.body)),
      baseUrl: baseUrl,
    );
  }

  Future<FruitModel> updateProduct(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final url = '$baseUrl/products/$id/';
    final response = await _sendJsonWithRedirect(
      method: 'PUT',
      url: url,
      body: payload,
    );
    _ensureSuccess(response);
    return FruitModel.fromJson(
      _extractMap(_decodeBody(response.body)),
      baseUrl: baseUrl,
    );
  }

  Future<void> deleteProduct(int id) async {
    final url = '$baseUrl/products/$id/';
    final response = await _sendJsonWithRedirect(
      method: 'DELETE',
      url: url,
    );
    _ensureSuccess(response);
  }

  Future<CatalogSearchResult> searchCatalog(String query) async {
    final trimmed = query.trim();
    final uri = Uri.parse('$baseUrl/search/').replace(
      queryParameters: {'q': trimmed},
    );
    _logRequest('GET', uri.toString());
    final response = await _client.get(uri);
    _logResponse('GET', uri.toString(), response);
    _ensureSuccess(response);

    final decoded = _decodeBody(response.body);
    final root = _extractMap(decoded);
    final categoryItems = _extractList(root, listKeys: const ['categories']);
    final productItems = _extractList(root, listKeys: const ['products']);

    return CatalogSearchResult(
      query: (root['query'] ?? trimmed).toString(),
      categories: categoryItems.map((e) => CategoryModel.fromJson(e)).toList(),
      products: productItems
          .map((e) => FruitModel.fromJson(e, baseUrl: baseUrl))
          .toList(),
    );
  }

  Future<void> updateCategoryImage(int categoryId, XFile imageFile) async {
    await _uploadImageWithFallback(
      method: 'PUT',
      urls: [
        '$baseUrl/categories/$categoryId/image',
        '$baseUrl/categories/$categoryId/image/',
      ],
      imageFile: imageFile,
    );
  }

  Future<void> updateProductImage(int productId, XFile imageFile) async {
    await _uploadImageWithFallback(
      method: 'PUT',
      urls: [
        '$baseUrl/products/$productId/image',
        '$baseUrl/products/$productId/image/',
      ],
      imageFile: imageFile,
    );
  }

  Future<Map<String, dynamic>> submitTableOrder({
    required String tableCode,
    required List<Map<String, dynamic>> items,
    String? notes,
  }) async {
    final url = '$baseUrl/orders/';
    final response = await _sendJsonWithRedirect(
      method: 'POST',
      url: url,
      body: {
        'table_code': tableCode,
        'items': items,
        'notes': notes?.trim().isEmpty == true ? null : notes?.trim(),
      },
    );
    _ensureSuccess(response);
    return _extractMap(_decodeBody(response.body));
  }

  Future<Map<String, dynamic>> getInvoice(int orderId) async {
    final url = '$baseUrl/orders/$orderId/invoice';
    _logRequest('GET', url);
    final response = await _client.get(Uri.parse(url));
    _logResponse('GET', url, response);
    _ensureSuccess(response);
    return _extractMap(_decodeBody(response.body));
  }

  Future<Map<String, dynamic>> validateTableCode(String tableCode) async {
    final code = tableCode.trim();
    final url = '$baseUrl/tables/validate/$code';
    _logRequest('GET', url);
    final response = await _client.get(Uri.parse(url));
    _logResponse('GET', url, response);
    _ensureSuccess(response);
    return _extractMap(_decodeBody(response.body));
  }

  Future<List<Map<String, dynamic>>> listOrders() async {
    final url = '$baseUrl/orders/';
    _logRequest('GET', url);
    final response = await _client.get(Uri.parse(url));
    _logResponse('GET', url, response);
    _ensureSuccess(response);
    return _extractList(_decodeBody(response.body));
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    throw Exception('API ${response.statusCode}: ${response.body}');
  }

  dynamic _decodeBody(String body) {
    if (body.trim().isEmpty) return null;
    return jsonDecode(body);
  }

  List<Map<String, dynamic>> _extractList(dynamic decoded,
      {List<String> listKeys = const []}) {
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    if (decoded is Map<String, dynamic>) {
      for (final key in ['data', ...listKeys, 'items', 'results']) {
        final value = decoded[key];
        if (value is List) {
          return value
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
      }

      final firstList = decoded.values.firstWhere(
        (value) => value is List,
        orElse: () => const <dynamic>[],
      );
      if (firstList is List) {
        return firstList
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    }

    return const <Map<String, dynamic>>[];
  }

  Map<String, dynamic> _extractMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      final nested = decoded['data'];
      if (nested is Map) return Map<String, dynamic>.from(nested);
      return decoded;
    }
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    return <String, dynamic>{};
  }

  Future<http.Response> _sendJsonWithRedirect({
    required String method,
    required String url,
    Map<String, dynamic>? body,
    int maxRedirects = 2,
  }) async {
    var currentUri = Uri.parse(url);
    var response = await _sendJson(
      method: method,
      uri: currentUri,
      body: body,
    );

    var redirects = 0;
    while (_isRedirect(response.statusCode) && redirects < maxRedirects) {
      final nextUri = _resolveRedirectUri(response, currentUri);
      if (nextUri == null || nextUri == currentUri) break;

      currentUri = nextUri;
      response = await _sendJson(
        method: method,
        uri: currentUri,
        body: body,
      );
      redirects++;
    }

    return response;
  }

  Future<http.Response> _sendJson({
    required String method,
    required Uri uri,
    Map<String, dynamic>? body,
  }) async {
    _logRequest(method, uri.toString(), body: body);

    final request = http.Request(method, uri);
    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }

    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);
    _logResponse(method, uri.toString(), response);
    return response;
  }

  Future<http.Response> _sendImageMultipart({
    required String method,
    required String url,
    required bool includeFilenameQuery,
    required XFile imageFile,
  }) async {
    var uri = includeFilenameQuery
        ? Uri.parse(url).replace(
            queryParameters: {
              'filename': imageFile.name,
            },
          )
        : Uri.parse(url);

    http.Response? response;
    for (var attempt = 0; attempt < 3; attempt++) {
      _logRequest(
        method,
        uri.toString(),
        body: {
          'multipart': true,
          'fields': ['image'],
          'filename': includeFilenameQuery ? imageFile.name : null,
        },
      );

      final request = http.MultipartRequest(method, uri);
      final imagePart =
          await http.MultipartFile.fromPath('image', imageFile.path);
      request.files.add(imagePart);

      final streamed = await _client.send(request);
      response = await http.Response.fromStream(streamed);
      _logResponse(method, uri.toString(), response);

      if (!_isRedirect(response.statusCode)) {
        return response;
      }

      final nextUri = _resolveRedirectUri(response, uri);
      if (nextUri == null || nextUri == uri) {
        return response;
      }
      uri = nextUri;
    }

    return response!;
  }

  Future<void> _uploadImageWithFallback({
    required String method,
    required List<String> urls,
    required XFile imageFile,
  }) async {
    http.Response? lastResponse;

    for (final url in urls) {
      for (final includeFilenameQuery in [true, false]) {
        final response = await _sendImageMultipart(
          method: method,
          url: url,
          includeFilenameQuery: includeFilenameQuery,
          imageFile: imageFile,
        );
        if (response.statusCode >= 200 && response.statusCode < 300) return;
        lastResponse = response;
      }
    }

    if (lastResponse != null) {
      _ensureSuccess(lastResponse);
    }
  }

  void _logRequest(String method, String url, {Map<String, dynamic>? body}) {
    debugPrint('[API][REQ] $method $url');
    if (body != null) {
      debugPrint('[API][REQ][BODY] ${jsonEncode(body)}');
    }
  }

  void _logResponse(String method, String url, http.Response response) {
    debugPrint('[API][RES] $method $url -> ${response.statusCode}');
    debugPrint('[API][RES][BODY] ${response.body}');
  }

  bool _isRedirect(int statusCode) =>
      statusCode == 301 ||
      statusCode == 302 ||
      statusCode == 303 ||
      statusCode == 307 ||
      statusCode == 308;

  Uri? _resolveRedirectUri(http.Response response, Uri currentUri) {
    final location = response.headers['location'];
    if (location != null && location.trim().isNotEmpty) {
      return currentUri.resolve(location.trim());
    }

    if (response.statusCode == 307 || response.statusCode == 308) {
      final path = currentUri.path.endsWith('/')
          ? currentUri.path.substring(0, currentUri.path.length - 1)
          : '${currentUri.path}/';
      return currentUri.replace(path: path);
    }

    return null;
  }
}
