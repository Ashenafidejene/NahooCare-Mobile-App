import 'dart:async';
import 'dart:io';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';

class ImageUploadException implements Exception {
  final String message;
  ImageUploadException(this.message);

  @override
  String toString() => 'ImageUploadException: $message';
}

abstract class CloudinaryDataSource {
  Future<String> uploadImage(File imageFile);
}

class CloudinaryDataSourceImpl implements CloudinaryDataSource {
  final String _cloudName;
  final String _uploadPreset;
  final String _apiKey;
  final String _apiSecret;
  final Cloudinary _cloudinary;

  CloudinaryDataSourceImpl({
    required String apiKey,
    required String cloudName,
    required String apiSecret,
    required String uploadPreset,
  }) : _cloudName = cloudName,
       _apiKey = apiKey,
       _apiSecret = apiSecret,
       _uploadPreset = uploadPreset,
       _cloudinary = Cloudinary.full(
         apiKey: apiKey,
         apiSecret: apiSecret,
         cloudName: cloudName,
       );

  @override
  Future<String> uploadImage(File imageFile) async {
    try {
      final response = await _cloudinary.uploadResource(
        CloudinaryUploadResource(
          filePath: imageFile.path,
          resourceType: CloudinaryResourceType.image,
          uploadPreset: _uploadPreset,
        ),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ImageUploadException('Upload failed: $e');
    }
  }

  String _handleResponse(CloudinaryResponse response) {
    if (response.isSuccessful && response.secureUrl != null) {
      return response.secureUrl!;
    } else {
      throw ImageUploadException(
        response.error ?? 'Upload failed with no error message',
      );
    }
  }
}
