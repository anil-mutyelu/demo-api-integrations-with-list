import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model_file.dart';

class ApiState extends StatefulWidget {
  const ApiState({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ApiState();
  }
}

class _ApiState extends State<ApiState> {
  List<PostModel> dataList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          for (Map<String, dynamic> a in data) {
            dataList.add(PostModel.fromJson(a));
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error appropriately, like showing a Snackbar or retry button.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("API Data")),
      ),
      body: Column(
        children: [
          Expanded(
            child: dataList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Body DESCRIPTIONS\n' + dataList[index].body.toString()),
                      Text('Title\n' + dataList[index].title.toString()),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
