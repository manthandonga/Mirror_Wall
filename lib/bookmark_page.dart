import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'global.dart';
import 'main.dart';

class bookmark_Page extends StatefulWidget {
  const bookmark_Page({Key? key}) : super(key: key);

  @override
  State<bookmark_Page> createState() => _bookmark_PageState();
}

class _bookmark_PageState extends State<bookmark_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              "BOOK MARK",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black),
        body: ListView.separated(
            separatorBuilder: (context, index) => Column(
              children: const [
                Divider(thickness: 5, color: Colors.black,endIndent: 10,indent: 10),
              ],
            ),
            itemCount: global.all_link.length,
            itemBuilder: (context, i) {
              int item = i;
              item = ++item;
              return Column(
                children: [
                  SizedBox(height: 10),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black,
                      child: Text(
                        "$item",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: GestureDetector(
                      onTap: () {
                        inAppWebViewController.loadUrl(
                            urlRequest: URLRequest(
                                url: Uri.parse("${global.all_link[i]}")));
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "${global.all_link[i]}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            global.all_link.remove(global.all_link[i]);
                          });
                        },
                        icon: const Icon(Icons.delete,color: Colors.redAccent,)),
                  ),
                  SizedBox(height: 10),
                ],
              );
            }));
  }
}
