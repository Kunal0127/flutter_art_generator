import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_openai_test/model/image_generation_response_model.dart';

class ShowGeneratedArtScreen extends StatelessWidget {
  final String prompt;
  final ImageGenerationResponseModel imageGenerationResponseModel;
  const ShowGeneratedArtScreen({
    super.key,
    required this.prompt,
    required this.imageGenerationResponseModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generated Art"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                color: Colors.green[100],
                padding: EdgeInsets.all(4),
                child: CachedNetworkImage(
                    height: 32,
                    fit: BoxFit.contain,
                    imageUrl: "${imageGenerationResponseModel.data?.first.url}",
                    progressIndicatorBuilder: (context, url, progress) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
              SizedBox(height: 12),
              Text(
                "Revised Prompt",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${imageGenerationResponseModel.data?.first.revisedPrompt}",
                textAlign: TextAlign.justify,
              ),
              Text(
                "Your Prompt",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${prompt}",
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 64),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("BACK")),
      ),
    );
  }
}
