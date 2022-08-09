import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:galleryimage/galleryimage.dart';

class ExtraTab with ChangeNotifier {
  String? extraTitle;
  Icon? extraIcon;
  Widget? extraScreen;

  ExtraTab(
      {this.extraIcon = const Icon(Icons.add),
      this.extraScreen = const SizedBox(),
      this.extraTitle = 'Extra'});

  String get title {
    return extraTitle!;
  }

  Icon get icon {
    return extraIcon!;
  }

  Widget get screen {
    return extraScreen!;
  }
}

class _User with ChangeNotifier {
  String id;
  final String name;
  final String profilePictureUrl;
  final String bio;
  final String profession;
  List<Map<String, String>>? certificates;
  List<Map<String, String>>? experience;
  List<Map<String, String>>? exams;
  _User(
      {required this.id,
      required this.name,
      required this.bio,
      required this.profilePictureUrl,
      required this.profession,
      this.certificates,
      this.experience,
      this.exams});
}

class _Users with ChangeNotifier {
  List<_User> _users = [];

  Future<void> fetchUsers() async {
    const dburl =
        'https://new-project-64c39-default-rtdb.firebaseio.com/users.json';
    final url = Uri.parse(dburl);
    final response = await http.get(url);
    final usersData = json.decode(response.body) as Map<String, dynamic>;
    final List<_User> loadedUsers = [];
    usersData.forEach((key, value) {
      loadedUsers.add(
        _User(
          id: key,
          name: value['name'],
          bio: value['bio'],
          profilePictureUrl: value['profilePictureUrl'],
          profession: value['profession'],
          certificates: (value['certificates'] as List).map((e) {
            Map<String, String> temp = {
              'imageUrl': e['imageUrl'],
              'title': e['title']
            };

            return temp;
          }).toList(),
          experience: (value['experience'] as List).map((e) {
            Map<String, String> temp = {
              'imageUrl': e['imageUrl'],
              'title': e['title']
            };

            return temp;
          }).toList(),
          exams: (value['exams'] as List).map((e) {
            Map<String, String> temp = {
              'youtubeVideoAdress': e['youtubeVideoAdress'],
              'title': e['title']
            };

            return temp;
          }).toList(),
        ),
      );

      _users = loadedUsers;
      notifyListeners();
    });
  }

  List<_User> get users {
    return _users;
  }

  _User findById(userId) {
    return _users.firstWhere((user) => user.id == userId);
  }
}

class _CertificatesScreen extends StatelessWidget {
  final String userId;
  const _CertificatesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<_Users>(context).findById(userId);
    List<Map<String, String>> userCertificates =
        user.certificates as List<Map<String, String>>;
    return ListView.builder(
        itemCount: userCertificates.length,
        itemBuilder: (ctx, index) {
          return _ExperienceElement(
              title: userCertificates[index]['title']!,
              imageUrl: userCertificates[index]['imageUrl']!);
        });
  }
}

class _ExamsScreen extends StatelessWidget {
  final String userId;
  const _ExamsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<_Users>(context).findById(userId);
    List<Map<String, String>> userExams =
        user.exams as List<Map<String, String>>;
    return ListView.builder(
        itemCount: userExams.length,
        itemBuilder: (ctx, index) {
          return _ExamElement(
              title: userExams[index]['title']!,
              youtubeVideoAdress: userExams[index]['youtubeVideoAdress']!);
        });
  }
}

class _ExperienceScreen extends StatelessWidget {
  final String userId;
  const _ExperienceScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<_Users>(context).findById(userId);
    List<Map<String, String>> userExperience =
        user.experience as List<Map<String, String>>;
    return ListView.builder(
        itemCount: userExperience.length,
        itemBuilder: (ctx, index) {
          return _ExperienceElement(
              title: userExperience[index]['title']!,
              imageUrl: userExperience[index]['imageUrl']!);
        });
  }
}

class _UserInfoScreen extends StatelessWidget {
  final String userId;
  const _UserInfoScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<_Users>(context).findById(userId);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              user.profilePictureUrl,
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Text(
            user.name,
            style: const TextStyle(
                color: Colors.teal, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            user.profession,
            style: const TextStyle(
                color: Colors.teal, fontWeight: FontWeight.w400),
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Text(user.bio),
        ],
      ),
    );
  }
}

class _UserProfileScreen extends StatelessWidget {
  final String id;

  _UserProfileScreen({
    required this.id,
    Key? key,
  }) : super(key: key);
  static const routeName = '/user-profile-screen';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
          bottom: TabBar(isScrollable: true, tabs: [
            Tab(
              icon: const Icon(Icons.account_circle_outlined, size: 15),
              text: 'information',
              height: 50,
            ),
            Tab(
              icon: const Icon(Icons.beenhere_outlined, size: 15),
              height: 50,
              text: 'Certificates',
            ),
            Tab(
              icon: const Icon(Icons.star_border, size: 15),
              text: 'Experience',
              height: 50,
            ),
            Tab(
              icon: const Icon(Icons.verified_outlined, size: 15),
              text: 'verified Exams',
              height: 50,
            ),
            Tab(
              icon: Provider.of<ExtraTab>(context, listen: false).extraIcon,
              text: Provider.of<ExtraTab>(context, listen: false).extraTitle,
              height: 50,
            )
          ]),
        ),
        body: TabBarView(
          children: [
            _UserInfoScreen(userId: id),
            _CertificatesScreen(userId: id),
            _ExperienceScreen(userId: id),
            _ExamsScreen(userId: id),
            Provider.of<ExtraTab>(context, listen: false).extraScreen!,
          ],
        ),
      ),
    );
  }
}

class _UsersScreen extends StatefulWidget {
  static const routeName = '/users-screen';

  _UsersScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<_UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<_UsersScreen> {
  bool x = true;
  bool isLoading = true;
  @override
  void didChangeDependencies() {
    if (x) {
      setState(() {
        isLoading = true;
      });
      Provider.of<_Users>(context).fetchUsers().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    x = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text(
          'Users',
          style: TextStyle(
            color: Colors.teal,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: isLoading ? CircularProgressIndicator() : _UsersList(),
    );
  }
}

class _ExamElement extends StatefulWidget {
  final String title;
  final String youtubeVideoAdress;
  const _ExamElement({
    Key? key,
    required this.title,
    required this.youtubeVideoAdress,
  }) : super(key: key);

  @override
  State<_ExamElement> createState() => _ExamElementState();
}

class _ExamElementState extends State<_ExamElement> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    _controller =
        YoutubePlayerController(initialVideoId: widget.youtubeVideoAdress);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        height: 220,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Card(
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              YoutubePlayerBuilder(
                  player: YoutubePlayer(
                      bottomActions: [], width: 300, controller: _controller),
                  builder: (ctx, player) {
                    return Column(
                      children: [player],
                    );
                  }),
              SizedBox(
                height: 10,
              ),
              Text(widget.title),
            ],
          ),
        ));
  }
}

class _ExperienceElement extends StatelessWidget {
  final String title;
  final String imageUrl;
  const _ExperienceElement({
    Key? key,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        elevation: 5,
        child: Column(children: [
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(children: [
              WidgetSpan(
                child: Icon(
                  Icons.check_circle_outline_outlined,
                  size: 16,
                ),
              ),
              TextSpan(
                text: '${title}',
                style: const TextStyle(color: Colors.teal, fontSize: 17),
              )
            ]),
          ),
          GalleryImage(
            imageUrls: [imageUrl],
            numOfShowImages: 1,
            titleGallery: title,
          ),
        ]),
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  final String id;

  _UserListItem({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<_User>(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          user.profilePictureUrl,
        ),
      ),
      title: Text(user.name),
      subtitle: Text(user.profession),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return _UserProfileScreen(
            id: user.id,
          );
        }));
      },
    );
  }
}

class _UsersList extends StatelessWidget {
  _UsersList({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<_Users>(context).users;

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: users[index],
          child: _UserListItem(
            id: users[index].id,
          ),
        );
      },
    );
  }
}

class GTMembersApp extends StatelessWidget {
  final ExtraTab? extraTab;

  GTMembersApp({
    this.extraTab,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((ctx) => _Users()),
        ),
        ChangeNotifierProvider(
          create: ((ctx) => ExtraTab(
                extraIcon: extraTab!.extraIcon,
                extraScreen: extraTab!.extraScreen,
                extraTitle: extraTab!.extraTitle,
              )),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: _UsersScreen(),
      ),
    );
  }
}
