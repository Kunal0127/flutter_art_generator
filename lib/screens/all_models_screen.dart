import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_openai_test/constant/constants.dart';
import 'package:flutter_openai_test/model/all_model_list_model.dart';
import 'package:flutter_openai_test/provider/api_key_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AllModelsScreen extends StatefulWidget {
  const AllModelsScreen({super.key});

  @override
  State<AllModelsScreen> createState() => _AllModelsScreenState();
}

class _AllModelsScreenState extends State<AllModelsScreen> {
  bool isLoading = false;
  AllModelListModel? allModelListModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllAvailableModel();
  }

  Future<void> fetchAllAvailableModel() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse(ALL_MODEL_URL),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $OPENAI_API",
          "Authorization": "Bearer ${Provider.of<ApiKeyProvider>(context).apiKey}",

        },
      );
      debugPrint("response: $response");
      log("response.body : ${response.body}");
      debugPrint("response.statuscode : ${response.statusCode}");
      if (response.statusCode == 200) {
        allModelListModel =
            AllModelListModel.fromJson(jsonDecode(response.body));
        print(" successfully");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Models"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : allModelListModel == null
              ? Text("Something went wrong!")
              : ListView.builder(
                  itemCount: allModelListModel?.data?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(
                          "${allModelListModel?.data?[index].id}",
                        ),
                        subtitle:
                            Text("${allModelListModel?.data?[index].ownedBy}"),
                        trailing: Text(
                          "Created at\n${(allModelListModel?.data?[index].created?.toUnixTime(isUtc: true))}",
                          textAlign: TextAlign.end,
                        )
                        // Text("${allModelListModel?.data?[index].ownedBy}"),
                        );
                  },
                ),
    );
  }
}

extension DateTimeUnixTimeExtention on DateTime {
  /// The number of seconds since the "Unix epoch" 1970-01-01T00:00:00Z (UTC).
  int get unixtime {
    return (millisecondsSinceEpoch / Duration.millisecondsPerSecond).round();
  }
}

extension IntUnixTimeExtention on int {
  /// Convert this number as unix time.
  DateTime toUnixTime({bool isUtc = false}) {
    return DateTime.fromMillisecondsSinceEpoch(
      this * Duration.millisecondsPerSecond,
      isUtc: isUtc,
    );
  }
}
