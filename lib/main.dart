import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MonmonApp());
}

const primary = Color(0xFF365CF5);
const ink = Color(0xFF122044);
const bg = Color(0xFF4F7FD);

class Post {
  Post(this.author, this.body, {this.likes = 0, this.comments = 0, this.liked = false});
  final String author;
  final String body;
  int likes, comments;
  bool liked;
}

class MonmonApp extends StatelessWidget {
  const MonmonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MONMON',
      theme: ThemeData(
        primaryColor: primary,
        scaffoldBackgroundColor: bg,
        fontFamily: 'GE SS Two',
      ),
      home: const MainFeedScreen(),
    );
  }
}

class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen({super.key});

  @override
  State<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen> {
  final List<Post> posts = [
    Post('أحمد محمد', 'أهلاً بكُم جميعاً في منصة MONMON الاجتماعية الجديدة! 🚀'),
    Post('مؤمن سعد', 'جاري تطوير وتحديث ميزات التطبيق وربطه بقواعد البيانات بنجاح 🔥'),
  ];

  final TextEditingController _postController = TextEditingController();

  void _addPost() {
    if (_postController.text.trim().isEmpty) return;
    setState(() {
      posts.insert(0, Post('مستخدم MONMON', _postController.text.trim()));
      _postController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'MONMON',
          style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: InputDecoration(
                      hintText: 'ماذا يدور في ذهنك؟',
                      filled: true,
                      fillColor: bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: primary),
                  onPressed: _addPost,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: primary,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              post.author,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: ink, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          post.body,
                          style: const TextStyle(color: ink, fontSize: 15),
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  post.liked = !post.liked;
                                  post.liked ? post.likes++ : post.likes--;
                                });
                              },
                              icon: Icon(
                                post.liked ? Icons.favorite : Icons.favorite_border,
                                color: post.liked ? Colors.red : Colors.grey,
                              ),
                              label: Text('${post.likes} إعجاب'),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.comment_outlined, color: Colors.grey),
                              label: Text('${post.comments} تعليق'),
                            ),
                          ],
                        ),
                      ],
                    ),
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
