import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:investigator/core/api_constants.dart';
import 'package:investigator/features/analysis/model/analysis_response.dart';

@lazySingleton
class VideoAnalysisApi {
  Future<AnalysisResponse> detectVideo(File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(APIConstants.detectVideo),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return AnalysisResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed: ${response.statusCode}');
  }
}
