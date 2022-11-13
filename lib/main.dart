import 'package:flutter/material.dart';
import 'Web.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Web View",
      routes: {
        "/": (context) => const WebPage(),
        "web": (context) => const WebLoad(),
      },
    ),
  );
}

class WebPage extends StatefulWidget {
  const WebPage({Key? key}) : super(key: key);

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  Map web = <String, String>{
    "assets/images/wikipedioa.jpg": "https://en.wikipedia.org/wiki/Main_Page",
    "assets/images/w3schools.jpg": "https://www.w3schools.com/",
    "assets/images/java.jpg": "https://www.javatpoint.com/",
    "assets/images/unnamed.png": "https://www.tutorialspoint.com/index.htm",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Web View"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
              children: web.entries
                  .map((e) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed("web", arguments: e);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 5),
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(e.key),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)),
                        ),
                      ))
                  .toList()),
        )
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Wrap(
        //       direction: Axis.horizontal,
        //       children: web.entries
        //           .map(
        //             (e) => GestureDetector(
        //               onTap: () {
        //                 Navigator.of(context).pushNamed("web", arguments: e);
        //               },
        //               child: Container(
        //                 margin: const EdgeInsets.symmetric(
        //                     horizontal: 7, vertical: 30),
        //                 height: 150,
        //                 width: 160,
        //                 decoration: BoxDecoration(
        //                     image: DecorationImage(
        //                       image: NetworkImage(e.key),
        //                     ),
        //                     color: const Color(0xff54759e).withOpacity(0.5),
        //                     borderRadius: BorderRadius.circular(10)),
        //               ),
        //             ),
        //           )
        //           .toList(),
        //     ),
        //   ],
        // ),
        );
  }
}
