// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

extension on GlobalKey {
  Offset? get widgetScreenOffset {
    final renderBox = currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return null;

    Offset screenOffset = renderBox.localToGlobal(Offset.zero);
    return screenOffset;
  }
}

extension on ScrollController {
  void scrollWidgetIntoView(
    GlobalKey key, {
    double viewportHeight = 100,
    Duration duration = const Duration(milliseconds: 800),
    Curve curve = Curves.fastEaseInToSlowEaseOut,
  }) {
    if (key.currentWidget == null) return;
    double screenOffset = (key.widgetScreenOffset?.dy ?? 0);

    double scrollOffset = offset;

    animateTo(screenOffset + scrollOffset - viewportHeight,
        duration: const Duration(milliseconds: 800),
        curve: Curves.fastEaseInToSlowEaseOut);
  }
}

void main() => runApp(const MyApp());

class Post {
  final String name;
  final String post;
  final int index;
  Post({
    required this.name,
    required this.post,
    required this.index,
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Size get screenSize => MediaQuery.sizeOf(context);
  GlobalKey targetKey = GlobalKey();
  String position = '';
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {});
    });
  }

  List<Post> get posts => List.generate(50, (index) {
        return Post(
            name: "FirstName LastName",
            post: "This is the post for user ${index + 1}",
            index: index + 1);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Text(
                "OF: ${targetKey.widgetScreenOffset?.dy.round()}, SO: ${scrollController.hasClients ? scrollController.offset.round() : null}"),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  scrollController.scrollWidgetIntoView(
                    targetKey,
                    viewportHeight: MediaQuery.sizeOf(context).height * 1 / 2,
                  );
                },
                child: const Text('scroll')),
            const SizedBox(
              width: 16,
            )
          ],
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              ...List<Widget>.generate(posts.length, (index) {
                final post = posts.elementAt(index);

                return ListTile(
                  key: index == 24 ? targetKey : null,
                  leading: Text('${post.index}'),
                  title: Text(
                    post.name,
                    style: index == 24
                        ? const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold)
                        : null,
                  ),
                  subtitle: Text(post.post),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
