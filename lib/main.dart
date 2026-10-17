
import 'package:flutter/material.dart';

void main() => runApp(const MonmonApp());
const primary = Color(0xFF365CF5);
const ink = Color(0xFF122044);
const bg = Color(0xFFF4F7FD);

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
  Widget build(BuildContext context) => MaterialApp(
    title: 'MONMON', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(seedColor: primary),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: ink, centerTitle: false),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: primary)),
    ),
    home: const LoginScreen(),
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final name = TextEditingController();
  final password = TextEditingController();
  bool register = false;
  @override void dispose() { name.dispose(); password.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl,
    child: Scaffold(body: SafeArea(child: Center(child: SingleChildScrollView(
      padding: const EdgeInsets.all(26), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440),
      child: Column(children: [
        Container(width: 92,height: 92, decoration: BoxDecoration(color: primary,borderRadius: BorderRadius.circular(25)),
          child: const Center(child: Text('M',style: TextStyle(fontSize: 57,color: Colors.white,fontWeight: FontWeight.w900)))),
        const SizedBox(height: 15), const Text('MONMON',style: TextStyle(fontSize: 34,fontWeight: FontWeight.w900,color: ink)),
        const Text('تواصل · شارك · اكتشف',style: TextStyle(color: Colors.blueGrey)),
        const SizedBox(height: 45),
        Text(register ? 'إنشاء حساب جديد' : 'مرحباً بعودتك',style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم المستخدم',prefixIcon: Icon(Icons.person_outline),border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور',prefixIcon: Icon(Icons.lock_outline),border: OutlineInputBorder())),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity,child: FilledButton(onPressed: () {
          if(name.text.trim().isEmpty || password.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أدخل اسم المستخدم وكلمة المرور'))); return;
          }
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => HomeScreen(username: name.text.trim())));
        },child: Padding(padding: const EdgeInsets.all(12),child: Text(register ? 'إنشاء الحساب' : 'تسجيل الدخول')))),
        TextButton(onPressed: () => setState(() => register = !register),
          child: Text(register ? 'لديك حساب؟ تسجيل الدخول' : 'ليس لديك حساب؟ إنشاء حساب')),
        const SizedBox(height: 22),
        const Text('نسخة تجريبية: يتم الدخول محلياً دون إنشاء حساب على خادم.',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 12))
      ])))))));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,required this.username});
  final String username;
  @override State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  final posts = <Post>[
    Post('أحمد محمد','من أجمل اللحظات في الحياة هي تلك التي نشاركها مع الأشخاص الذين نحبهم 💙',likes: 248,comments: 45),
    Post('سارة علي','صباح الخير يا أصدقاء! ما هي خططكم لهذا اليوم؟ ☀️',likes: 81,comments: 13),
  ];
  final friends = ['سارة علي','محمد خالد','ليلى أحمد','عمر حسن','نور محمد','يوسف سمير'];
  final requests = <String>{};
  final chats = <String,List<String>>{};
  Widget avatar(String name, {double radius=20}) => CircleAvatar(radius: radius,backgroundColor: const Color(0xFFE4EAFF),
    child: Text(name.characters.first,style: const TextStyle(color: primary,fontWeight: FontWeight.bold)));
  void compose() {
    final c = TextEditingController();
    showModalBottomSheet(context: context,isScrollControlled: true,showDragHandle: true,builder: (ctx) =>
      Padding(padding: EdgeInsets.fromLTRB(20,12,20,MediaQuery.of(ctx).viewInsets.bottom+28),
        child: Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.stretch,children: [
          const Text('إنشاء منشور',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),TextField(controller: c,maxLines: 5,minLines: 3,
            decoration: const InputDecoration(hintText: 'ما الذي يدور في ذهنك؟',border: OutlineInputBorder())),
          const SizedBox(height: 12),FilledButton(onPressed: () {
            if(c.text.trim().isEmpty) return;
            setState(() { posts.insert(0,Post(widget.username,c.text.trim())); tab=0; });
            Navigator.pop(ctx);
          },child: const Text('نشر'))
        ])));
  }
  @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl,
    child: Scaffold(appBar: AppBar(title: const Text('MONMON',style: TextStyle(fontWeight: FontWeight.w900,color: primary,letterSpacing: 1)),
      actions: [IconButton(onPressed: () => setState(() => tab=3),icon: const Icon(Icons.search)),
        IconButton(onPressed: () => setState(() => tab=4),icon: const Icon(Icons.notifications_none))]),
      body: IndexedStack(index: tab,children: [feed(),friendsPage(),groupsPage(),messagesPage(),notificationsPage(),profilePage()]),
      floatingActionButton: tab==0 ? FloatingActionButton(backgroundColor: primary,foregroundColor: Colors.white,onPressed: compose,child: const Icon(Icons.add)) : null,
      bottomNavigationBar: NavigationBar(height: 72,selectedIndex: tab,onDestinationSelected: (v) => setState(() => tab=v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined),selectedIcon: Icon(Icons.home),label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.people_outline),label: 'الأصدقاء'),
          NavigationDestination(icon: Icon(Icons.groups_outlined),label: 'المجموعات'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline),label: 'المحادثات'),
          NavigationDestination(icon: Icon(Icons.notifications_none),label: 'الإشعارات'),
          NavigationDestination(icon: Icon(Icons.person_outline),label: 'حسابي'),
        ])));
  Widget feed() => ListView(padding: const EdgeInsets.all(12),children: [
    Card(child: ListTile(leading: avatar(widget.username),title: Text(widget.username),subtitle: const Text('بماذا تفكر اليوم؟'),
      trailing: IconButton(icon: const Icon(Icons.edit_square,color: primary),onPressed: compose),onTap: compose)),
    SizedBox(height: 98,child: ListView(scrollDirection: Axis.horizontal,children: [
      for(final n in [widget.username,...friends.take(5)]) Padding(padding: const EdgeInsets.all(6),child: Column(children: [
       avatar(n,radius: 27),const SizedBox(height: 4),Text(n,style: const TextStyle(fontSize: 11))]))])),
    for(final p in posts) Card(margin: const EdgeInsets.only(bottom: 12),child: Padding(padding: const EdgeInsets.all(14),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
      Row(children: [avatar(p.author),const SizedBox(width: 10),Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        Text(p.author,style: const TextStyle(fontWeight: FontWeight.bold)),const Text('الآن · 🌐',style: TextStyle(fontSize: 11,color: Colors.grey))])]),
      const SizedBox(height: 18),Text(p.body,style: const TextStyle(fontSize: 16,height: 1.5)),const SizedBox(height: 18),
      Text('${p.likes} إعجاب   ·   ${p.comments} تعليق',style: const TextStyle(color: Colors.blueGrey,fontSize: 12)),
      const Divider(),Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
        TextButton.icon(onPressed: () => setState(() { p.liked=!p.liked; p.likes+=p.liked?1:-1; }),
          icon: Icon(p.liked?Icons.favorite:Icons.favorite_border,color: p.liked?Colors.red:Colors.blueGrey),label: const Text('إعجاب')),
        TextButton.icon(onPressed: () => comment(p),icon: const Icon(Icons.mode_comment_outlined),label: const Text('تعليق')),
        TextButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ميزة المشاركة الخارجية قيد التطوير'))),
          icon: const Icon(Icons.share_outlined),label: const Text('مشاركة')),
      ])
    ])))
  ]);
  void comment(Post p) {
    final c=TextEditingController();
    showDialog(context: context,builder: (ctx) => AlertDialog(title: const Text('إضافة تعليق'),
      content: TextField(controller:c,decoration: const InputDecoration(hintText: 'اكتب تعليقك')),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx),child: const Text('إلغاء')),
        FilledButton(onPressed: () { if(c.text.trim().isNotEmpty) setState(() => p.comments++); Navigator.pop(ctx); },child: const Text('إرسال'))]));
  }
  Widget friendsPage() => ListView(padding: const EdgeInsets.all(16),children: [
    const Text('اكتشف أصدقاء جدد',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),const SizedBox(height: 12),
    for(final n in friends) Card(child: ListTile(leading: avatar(n),title: Text(n),
      trailing: FilledButton.tonal(onPressed: () => setState(() => requests.contains(n)?requests.remove(n):requests.add(n)),
        child: Text(requests.contains(n)?'تم إرسال الطلب':'إضافة صديق'))))
  ]);
  Widget groupsPage() => ListView(padding: const EdgeInsets.all(16),children: [
    const Text('المجموعات',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
    for(final n in ['عشاق السفر','التقنية والذكاء الاصطناعي','أصدقاء الجامعة','الرياضة والصحة','التصوير الفوتوغرافي'])
      Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.groups)),title: Text(n),subtitle: const Text('مجتمع MONMON'),
        trailing: const Icon(Icons.chevron_left),onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('مجموعة $n: العرض التفصيلي قيد التطوير')))))
  ]);
  Widget messagesPage() => ListView(padding: const EdgeInsets.all(16),children: [
    const Text('المحادثات',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
    for(final n in friends) Card(child: ListTile(leading: avatar(n),title: Text(n),
      subtitle: Text(chats[n]?.isNotEmpty==true?chats[n]!.last:'ابدأ محادثة جديدة'),
      trailing: const Icon(Icons.chevron_left),onTap: () => Navigator.push(context,MaterialPageRoute(builder: (_) => ChatScreen(name:n,messages:chats.putIfAbsent(n,()=>[]),avatar:avatar(n)))).then((_)=>setState((){}))))
  ]);
  Widget notificationsPage() => ListView(padding: const EdgeInsets.all(16),children: [
    const Text('الإشعارات',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
    for(final n in ['مرحباً بك في مجتمع MONMON!','ابدأ بإضافة أصدقائك ومشاركة أول منشور.'])
      Card(child: ListTile(leading: const Icon(Icons.notifications_active_outlined,color:primary),title: Text(n)))
  ]);
  Widget profilePage() => ListView(children: [
    Container(height: 145,decoration: const BoxDecoration(gradient: LinearGradient(colors: [primary,Color(0xFF8F9FFF)]))),
    Transform.translate(offset: const Offset(0,-36),child: Column(children: [
      CircleAvatar(radius: 48,backgroundColor: Colors.white,child: avatar(widget.username,radius: 43)),
      const SizedBox(height: 8),Text(widget.username,style: const TextStyle(fontSize: 23,fontWeight: FontWeight.bold)),
      const Text('مرحباً بكم في صفحتي على MONMON 💙'),const SizedBox(height: 16),
      FilledButton.tonal(onPressed: compose,child: const Text('إضافة منشور')),
      const SizedBox(height: 12),const Divider(),const Text('منشوراتي',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
      for(final p in posts.where((p)=>p.author==widget.username))
        Card(margin: const EdgeInsets.all(12),child: Padding(padding: const EdgeInsets.all(18),child: Text(p.body))),
      TextButton.icon(onPressed: () => Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => const LoginScreen())),
        icon: const Icon(Icons.logout),label: const Text('تسجيل الخروج'))
    ]))
  ]);
}
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key,required this.name,required this.messages,required this.avatar});
  final String name;
  final List<String> messages;
  final Widget avatar;
  @override State<ChatScreen> createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final c=TextEditingController();
  @override void dispose(){c.dispose();super.dispose();}
  @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl,
    child: Scaffold(appBar: AppBar(title: Row(children: [widget.avatar,const SizedBox(width: 10),Text(widget.name)])),
      body: Column(children: [
        Expanded(child: ListView(padding: const EdgeInsets.all(16),children: [
          for(final m in widget.messages) Align(alignment: Alignment.centerRight,child: Container(
            margin: const EdgeInsets.only(bottom: 9),padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(color: const Color(0xFFDDE6FF),borderRadius: BorderRadius.circular(17)),child: Text(m)))
        ])),
        SafeArea(child: Padding(padding: const EdgeInsets.all(10),child: Row(children: [
          Expanded(child: TextField(controller:c,decoration: const InputDecoration(hintText:'اكتب رسالة...',border: OutlineInputBorder()))),
          IconButton(onPressed: () {if(c.text.trim().isEmpty)return;setState(() {widget.messages.add(c.text.trim());c.clear();});},
            icon: const Icon(Icons.send,color:primary))
        ])))
      ])));
}
