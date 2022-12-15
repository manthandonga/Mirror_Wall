import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'bookmark_Page.dart';
import 'global.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => home(),
        'bookmark_Page': (context) => bookmark_Page(),
      },
    ),
  );
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

late InAppWebViewController inAppWebViewController;
late PullToRefreshController pullToRefreshController;
bool isback = false;
bool isforwer = false;
int select = 0;
int onselect = 0;
double _progress = 0;

class _homeState extends State<home> {
  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (Platform.isAndroid) {
          await inAppWebViewController.reload();
        } else {
          Uri? uri = await inAppWebViewController.getUrl();
          await inAppWebViewController.loadUrl(
              urlRequest: URLRequest(url: uri));
        }
      },
      options: PullToRefreshOptions(color: Colors.blueAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("WEB BROWSER",
              style: TextStyle(fontSize: 20, color: Colors.white)),
          // centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  await inAppWebViewController.loadUrl(
                      urlRequest: URLRequest(
                          url: Uri.parse(global.google)));
                },
                icon: const Icon(Icons.home)),
            (isback == true)
                ? IconButton(
                    onPressed: () async {
                      select = 0;
                      onselect = 0;
                      if (await inAppWebViewController.canGoBack()) {
                        await inAppWebViewController.goBack();
                      }
                    },
                    icon: const Icon(Icons.arrow_back_ios))
                : Container(),
            IconButton(
                onPressed: () async {
                  if (Platform.isIOS) {
                    Uri? uri = await inAppWebViewController.getUrl();
                    await inAppWebViewController.loadUrl(
                        urlRequest: URLRequest(url: uri));
                  } else {
                    await inAppWebViewController.reload();
                  }
                },
                icon: const Icon(Icons.refresh)),
            (isforwer == true)
                ? IconButton(
                    onPressed: () async {
                      if (await inAppWebViewController.canGoForward()) {
                        await inAppWebViewController.goForward();
                      }
                    },
                    icon: const Icon(Icons.arrow_forward_ios_sharp))
                : Container(),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
                // heroTag: null,
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Search"),
                            content: TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Search Your Content Here..'),
                              onChanged: (val) {
                                inAppWebViewController.loadUrl(
                                    urlRequest: URLRequest(
                                        url: Uri.parse(
                                            "https://www.google.co.in/search?q=$val")));
                              },
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.black),
                                  child: Text(
                                    "save",
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ));
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                backgroundColor: Colors.black),
            const SizedBox(width: 10),
            FloatingActionButton(
                backgroundColor: Colors.black,
                heroTag: null,
                onPressed: () async {
                  Uri? uri = await inAppWebViewController.getUrl();
                  global.all_link.add(uri.toString());
                },
                child: const Icon(
                  Icons.bookmark_add,
                  color: Colors.white,
                )),
            const SizedBox(width: 10),
            FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  Navigator.of(context).pushNamed('bookmark_Page');
                },
                child: const Icon(
                  Icons.bookmark,
                  color: Colors.white,
                ),
                backgroundColor: Colors.black),
            const SizedBox(width: 10),
            FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  await inAppWebViewController.stopLoading();
                },
                child: const Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                backgroundColor: Colors.black),
          ],
        ),
        body: Column(
          children: [
            _progress < 1
                ? SizedBox(
                    height: 3,
                    child: LinearProgressIndicator(
                      value: _progress,
                      color: Colors.blue,
                      backgroundColor: Colors.grey,
                    ),
                  )
                : SizedBox(),
            Container(
                height: height * 0.87,
                child: InAppWebView(
                  initialOptions: InAppWebViewGroupOptions(
                      android: AndroidInAppWebViewOptions(
                          useHybridComposition: true)),
                  pullToRefreshController: pullToRefreshController,
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(global.google)),
                  onWebViewCreated: (val) async {
                    inAppWebViewController = val;
                  },
                  onProgressChanged: (controller, i) async {
                    setState(() {
                      _progress = i / 100;
                    });
                    iscanback();

                    if (await inAppWebViewController.canGoForward()) {
                      setState(() {
                        isforwer = true;
                      });
                    } else {
                      setState(() {
                        isforwer = false;
                      });
                    }
                  },
                  onLoadStop: (context, uri) async {
                    await pullToRefreshController.endRefreshing();
                  },
                ))
          ],
        ));
  }

  iscanback() async {
    if (await inAppWebViewController.canGoBack()) {
      setState(() {
        isback = true;
      });
    } else {
      setState(() {
        isback = false;
      });
    }
  }
}
