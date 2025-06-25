import 'dart:io';
import "package:flutter/material.dart";
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_url_gen/transformation/effect/effect.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';

class UploadService {
   late Cloudinary cloudinary;
   var cloudName = 'drqdk45dr';
   var apiKey = '271452153872785';
   var apiSecret ="Voc7JxhiQJ3UmTvvR1dXdyI7T-0";

   UploadService(){
    cloudinary = Cloudinary.fromStringUrl('cloudinary://$apiKey:$apiSecret@$cloudName');
    cloudinary.config.urlConfig.secure = true;
  }

  Future<String?> uploadImage(File image) async {
      var response = await cloudinary.uploader().upload(image);
      if(response==null) {
        throw Exception("Failed to upload image");
      }
      debugPrint("Image uploaded successfully: ${response.data?.url}");
      return response.data?.url;
  }

}



