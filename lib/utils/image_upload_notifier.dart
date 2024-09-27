import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lost_items/controller/repository/auth_repo.dart';
import 'package:lost_items/utils/app_theme.dart';

final imageUploader = ImageUploadNotifier();

class ImageUploadNotifier extends ChangeNotifier {
  double percentage = 0;

  updatePercentage(double upload) {
    percentage = upload;
    // print(percentage);
    notifyListeners();
  }

  Future<List<String>> uploadMultipleImagesNative(BuildContext context,
      {required List<String> imageFiles}) async {
    updatePercentage(0);

    List<String> returnedUrl = [];
    // int number = imageFiles.length;
    double uploadedFiles = 0;
    double accumulatedValue = 0;

    for (String image in imageFiles) {
      accumulatedValue = 0;
      try {
        FormData uploadForm = FormData.fromMap({
          'file': await MultipartFile.fromFile(
              filename: image,
              image,
              contentType: DioMediaType("image", image.split(".").last))
        });
        final response = await Dio().post(
          onSendProgress: (count, total) {
            double currentPercentage = count / total;
            uploadedFiles -= accumulatedValue;
            accumulatedValue = currentPercentage;

            uploadedFiles += accumulatedValue;
            updatePercentage(uploadedFiles);
          },
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
              "app_id": "7d1b5fb2-0979-465a-82ef-2194da68600d",
              "authorization": "Bearer ${AuthRepository.instance.token}"
            },
          ),
          'https://fndrly.4runnerglobal.org/api/v1/secure/upload-missing-item',
          data: uploadForm,
        );
        if (response.statusCode == 200 &&
            response.data?["data"] != null) {
          returnedUrl.add(response.data?["data"]);
        }
      } on DioException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppTheme.primaryColor,
            content: Text(
              e.response?.data["message"] ?? "Unable to upload image",
              style: AppTheme.buttonTextStyle.copyWith(fontSize: 12),
            )));
        uploadedFiles -= accumulatedValue;
        updatePercentage(uploadedFiles);
      } catch (e) {
        uploadedFiles -= accumulatedValue;
        updatePercentage(uploadedFiles);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppTheme.primaryColor,
            content: Text(
              "Unable to upload image",
              style: AppTheme.buttonTextStyle.copyWith(fontSize: 12),
            )));
      }
    }
    updatePercentage(0);
    return returnedUrl;
  }
}
