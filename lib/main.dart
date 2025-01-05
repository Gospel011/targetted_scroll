// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

extension on GlobalKey {
  Offset? get widgetScreenOffset {
    final renderBox = currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return null;

    Offset screenOffset = renderBox.localToGlobal(Offset.zero);
    return screenOffset;
  }

  Size? get widgetSize {
    if (currentWidget == null) return null;
    final renderBox = currentContext!.findRenderObject() as RenderBox;

    return renderBox.size;
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
  GlobalKey appBarKey = GlobalKey();
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
          key: appBarKey,
          actions: [
            // OF(Object offset), the offset of the target widget from the top of the screen
            // SO(Scroll offset), the current scroll offset from the top of the screen
            Text(
                "OF: ${targetKey.widgetScreenOffset?.dy.round()}, SO: ${scrollController.hasClients ? scrollController.offset.round() : null}"),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  scrollController.scrollWidgetIntoView(
                    targetKey,
                    viewportHeight:
                        ((MediaQuery.sizeOf(context).height +
                            appBarKey.widgetSize!.height) * 1 / 2) -
                            (targetKey.widgetSize!.height / 2),
                  );
                },
                child: const Text('scroll')),
            const SizedBox(
              width: 16,
            )
          ],
        ),
        body: Builder(builder: (context) {
          final renderBox =
              targetKey.currentContext?.findRenderObject() as RenderBox?;

          final screenOffset = renderBox?.localToGlobal(Offset.zero);
          final dx = (screenOffset?.dx ?? 0) - 20;
          final dy =
              (screenOffset?.dy ?? 0) - (appBarKey.widgetSize?.height ?? 0) - 20;

          return Stack(
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.amber,
                ),
              ),
              if (screenOffset != null)
                Positioned(
                  left: dx,
                  top: dy,
                  child: const Center(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.amber,
                    ),
                  ),
                ),
              if (screenOffset != null)
                Positioned(
                  left: dx! + targetKey.widgetSize!.width,
                  top: dy,
                  child: const Center(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.amber,
                    ),
                  ),
                ),
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    ...List<Widget>.generate(posts.length, (index) {
                      final post = posts.elementAt(index);

                      return index == 24
                          ? Container(
                              key: targetKey,
                              width: MediaQuery.sizeOf(context).width - 32,
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withOpacity(0.3),
                                // borderRadius: BorderRadius.circular(16),
                              ),
                            )
                          : ListTile(
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
            ],
          );
        }),
      ),
    );
  }
}
