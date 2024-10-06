import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_openai_test/constant/constants.dart';
import 'package:flutter_openai_test/model/image_generation_response_model.dart';
import 'package:flutter_openai_test/provider/api_key_provider.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class ImageGenerationScreen extends StatefulWidget {
  const ImageGenerationScreen({super.key});

  @override
  State<ImageGenerationScreen> createState() => _ImageGenerationScreenState();
}

class _ImageGenerationScreenState extends State<ImageGenerationScreen> {
  final TextEditingController _textController = TextEditingController();

  String? imageUrl = '';
  bool isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Generation"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: isLoading
                    ? CircularProgressIndicator()
                    : imageUrl != null && imageUrl?.isEmpty != true
                        ? CachedNetworkImage(imageUrl: "${imageUrl}")
                        : null,
              ),
            ),
            TextField(
              controller: _textController,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Enter image prompt",
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _textController.text.isEmpty == true &&
                        _textController.text == null
                    ? null
                    : generateImage(image_prompt: _textController.text.trim());
              },
              child: Text("Generate Image"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateImage({required String image_prompt}) async {
    print("generateImage called");
    // const apiKey = OPENAI_API;
    final apiKey = Provider.of<ApiKeyProvider>(context).apiKey;
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse(IMAGE_GENERATION_URL),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode(
          {
            "model": "dall-e-3",
            "prompt": image_prompt,
            "n": 1,
            "size": "1024x1024",
            'response_format': "url", // "url" or "b64_json"
            'style': "vivid", // "vivid" or "natural"
          },
        ),
      );
      debugPrint("response: $response");
      log("response.body : ${response.body}");
      debugPrint("response.statuscode : ${response.statusCode}");
      if (response.statusCode == 200) {
        setState(() {
          final imageGenerationResponseModel =
              ImageGenerationResponseModel.fromJson(jsonDecode(response.body));
          print("Image generate successfully");
          imageUrl = "${imageGenerationResponseModel.data?[0].url}";
          isLoading = false;
        });
      }
    } catch (e) {
      print("error $e");
      setState(() {
        isLoading = false;
      });
    }
  }
}


/*
response.body : {
I/flutter ( 8691):   "created": 1721040883,
I/flutter ( 8691):   "data": [
I/flutter ( 8691):     {
I/flutter ( 8691):       "revised_prompt": "A vivid red panther, standing on her hind legs, clutching a colourful bunch of birthday balloons in her front paws. The balloons are a mix of different shapes and sizes, filled with helium and tied with shimmering strings. The panther wears a gentle smile as the birthday balloons float above her, creating a joyful and festive atmosphere.",
I/flutter ( 8691):       "url": "https://oaidalleapiprodscus.blob.core.windows.net/private/org-BsIIXcBik20kTXOEpcCvMDxx/user-dropjK4GqN4KWKnhqT0oUvql/img-44qBh9JVGEMNzogtKtYCOyO3.png?st=2024-07-15T09%3A54%3A43Z&se=2024-07-15T11%3A54%3A43Z&sp=r&sv=2023-11-03&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2024-07-14T14%3A11%3A33Z&ske=2024-07-15T14%3A11%3A33Z&sks=b&skv=2023-11-03&sig=CZ9VEDOaXS4D2fAE3pwynXSoDMFhWL6PAFwSScHnmBs%3D"
I/flutter ( 8691):     }
 */