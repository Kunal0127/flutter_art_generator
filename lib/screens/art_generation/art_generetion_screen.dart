import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_openai_test/model/image_generation_response_model.dart';
import 'package:flutter_openai_test/provider/api_key_provider.dart';
import 'package:flutter_openai_test/screens/art_generation/show_generated_art_screen.dart';
import 'package:http/http.dart' as http;
import 'package:change_case/change_case.dart';
import 'package:flutter_openai_test/constant/constants.dart';
import 'package:flutter_openai_test/enum/enum.dart';
import 'package:provider/provider.dart';

class ArtGenerationScreen extends StatefulWidget {
  const ArtGenerationScreen({super.key});

  @override
  State<ArtGenerationScreen> createState() => _ArtGenerationScreenState();
}

class _ArtGenerationScreenState extends State<ArtGenerationScreen> {
  // ArtStyle selected = ArtStyle.cubism;
  // Set<String> style = artStyle.first;
  // Set<String> size = imageSize.first;
  bool isLoading = false;
  TextEditingController _subjectController = TextEditingController();
  Set<String> style = {};
  Set<String> size = {};
  Set<String> mood = {};
  Set<String> lighting = {};
  Set<String> model = {imageModel[0]};
  Set<String> composition = {};

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generate Art"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _subjectController,
                minLines: 3,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Red elephants playing golf with humans",
                  border: OutlineInputBorder(),
                ),
              ),
              CustomSegmentedButton(
                  title: "Art Style",
                  segments: artStyle.map((String style) {
                    return ButtonSegment<String>(
                        value: style, label: Text(style.toNoCase()));
                  }).toList(),
                  selected: style,
                  emptySelectionAllowed: true,
                  onSelectionChanged: (Set newSelection) {
                    setState(() {
                      style = newSelection.whereType<String>().toSet();
                    });
                  }),
              CustomSegmentedButton(
                  title: "Mood",
                  segments: artMood.map((String mood) {
                    return ButtonSegment<String>(
                        value: mood, label: Text(mood));
                  }).toList(),
                  selected: mood,
                  emptySelectionAllowed: true,
                  onSelectionChanged: (Set newMood) {
                    debugPrint("$newMood");
                    setState(() {
                      mood = newMood.whereType<String>().toSet();
                    });
                  }),
              CustomSegmentedButton(
                  title: "Lighting",
                  segments: artLighting.map((String light) {
                    return ButtonSegment<String>(
                        value: light, label: Text(light));
                  }).toList(),
                  selected: lighting,
                  emptySelectionAllowed: true,
                  onSelectionChanged: (Set newLighting) {
                    debugPrint("$newLighting");
                    setState(() {
                      lighting = newLighting.whereType<String>().toSet();
                    });
                  }),
              CustomSegmentedButton(
                  title: "Composition",
                  segments: artComposition.map((String composition) {
                    return ButtonSegment<String>(
                        value: composition, label: Text(composition));
                  }).toList(),
                  selected: composition,
                  emptySelectionAllowed: true,
                  onSelectionChanged: (Set newComposition) {
                    debugPrint("$newComposition");
                    setState(() {
                      composition = newComposition.whereType<String>().toSet();
                    });
                  }),
              CustomSegmentedButton(
                  title: "Image Size",
                  segments: model.first == imageModel[0]
                      ? artImageSize.sublist(0, 3).map((String size) {
                          print(size);
                          return ButtonSegment<String>(
                              value: size, label: Text(size));
                        }).toList()
                      : artImageSize.sublist(2).map((String size) {
                          print(size);
                          return ButtonSegment<String>(
                              value: size, label: Text(size));
                        }).toList(),
                  selected: size,
                  emptySelectionAllowed: true,
                  onSelectionChanged: (Set newSelection) {
                    debugPrint("$newSelection");
                    setState(() {
                      size = newSelection.whereType<String>().toSet();
                    });
                  }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 20 + 28,
              child: CustomSegmentedButton(
                  // title: "Model",
                  segments: imageModel.map((String size) {
                    return ButtonSegment<String>(
                        value: size, label: Text(size));
                  }).toList(),
                  selected: model,
                  emptySelectionAllowed: false,
                  onSelectionChanged: (Set newModel) {
                    debugPrint("$newModel");
                    setState(() {
                      model = newModel.whereType<String>().toSet();
                    });
                  }),
            ),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: () async {
                      debugPrint("${_subjectController}");
                      debugPrint("${_subjectController.text.length}");
                      if (_subjectController.text.isEmpty ||
                          _subjectController.text == null) {
                        debugPrint("please give subject");
                      } else {
                        debugPrint(
                            "an art image of ${_subjectController.text.trim()} ${style.isEmpty ? "" : ", in artstyle of ${style.first},"} ${mood.isEmpty ? "" : "atmosphere ${mood.first},"} ${lighting.isEmpty ? "" : "${lighting.first} lighting,"} ${composition.isEmpty ? "" : "${composition.first} composition"}"
                                .trim());
                        debugPrint(model.first);
                        debugPrint(size.first);
                        String imagePrompt =
                            "an art image of ${_subjectController.text.trim()}${style.isEmpty ? "" : ", in artstyle of ${style.first},"} ${mood.isEmpty ? "" : "atmosphere ${mood.first},"} ${lighting.isEmpty ? "" : "${lighting.first} lighting,"} ${composition.isEmpty ? "" : "${composition.first} composition"}"
                                .trim();
                        final generatedImageModel = await generateArt(
                            image_prompt: imagePrompt,
                            model: model.first,
                            size: size.first);
                        if (generatedImageModel != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowGeneratedArtScreen(
                                    prompt: imagePrompt,
                                    imageGenerationResponseModel:
                                        generatedImageModel),
                              ));
                        } else {
                          debugPrint("generatedImageModel is null");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: Size(160, 48),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromARGB(255, 101, 187, 75)),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    icon: Icon(
                      Icons.next_plan,
                      color: Colors.white,
                    ),
                    label: Text(
                      "GENERATE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<ImageGenerationResponseModel?> generateArt({
    required String image_prompt,
    required String model,
    required String size,
  }) async {
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
            "model": model,
            "prompt": image_prompt,
            "n": 1,
            "size": size,
            'response_format': "url", // "url" or "b64_json"
            'style': "vivid", // "vivid" or "natural"
          },
        ),
      );
      debugPrint("response: $response");
      log("response.body : ${response.body}");
      debugPrint("response.statuscode : ${response.statusCode}");
      if (response.statusCode == 200) {
        late ImageGenerationResponseModel imageGenerationResponseModel;
        setState(() {
          imageGenerationResponseModel =
              ImageGenerationResponseModel.fromJson(jsonDecode(response.body));
          print("Image generate successfully");
          // imageUrl = "${imageGenerationResponseModel.data?[0].url}";
          isLoading = false;
        });
        return imageGenerationResponseModel;
      }
    } catch (e) {
      print("error $e");
      setState(() {
        isLoading = false;
      });
    }
    return null;
  }
}

class CustomSegmentedButton extends StatelessWidget {
  final String? title;
  final List<ButtonSegment<String>> segments;
  final Set<String> selected;
  final bool? emptySelectionAllowed;
  final Function(Set<String>)? onSelectionChanged;
  // final bool  showSelectedIcon;

  const CustomSegmentedButton({
    super.key,
    this.title,
    required this.segments,
    required this.selected,
    required this.emptySelectionAllowed,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        title == null
            ? SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(top: 8, left: 2),
                child: Text(title ?? "",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<String>(
            segments: segments,
            selected: selected,
            emptySelectionAllowed: emptySelectionAllowed ?? false,
            onSelectionChanged: onSelectionChanged,
            showSelectedIcon: false,
          ),
        ),
      ],
    );
  }
}
