part of gammal_tech;

class User with ChangeNotifier {
  String id;
  final String name;
  final String profilePictureUrl;
  final String bio;
  final String profession;
  List<Map<String, String>>? certificates;
  List<Map<String, String>>? experience;
  List<Map<String, String>>? exams;
  User(
      {required this.id,
      required this.name,
      required this.bio,
      required this.profilePictureUrl,
      required this.profession,
      this.certificates,
      this.experience,
      this.exams});
}

class Users with ChangeNotifier {
  List<User> _users = [];

  Future<void> fetchUsers() async {
    final url = Uri.parse(
        'https://new-project-64c39-default-rtdb.firebaseio.com/users.json');
    final response = await http.get(url);
    final usersData = json.decode(response.body) as Map<String, dynamic>;
    final List<User> loadedUsers = [];
    usersData.forEach((key, value) {
      loadedUsers.add(
        User(
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
      print(loadedUsers[0]);
      _users = loadedUsers;
      notifyListeners();
    });
  }

  List<User> get users {
    return _users;
  }

  User findById(userId) {
    return _users.firstWhere((user) => user.id == userId);
  }
}

class CertificatesScreen extends StatelessWidget {
  final String userId;
  const CertificatesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context).findById(userId);
    List<Map<String, String>> userCertificates =
        user.certificates as List<Map<String, String>>;
    return ListView.builder(
        itemCount: userCertificates.length,
        itemBuilder: (ctx, index) {
          return ExperienceElement(
              title: userCertificates[index]['title']!,
              imageUrl: userCertificates[index]['imageUrl']!);
        });
  }
}

class ExamsScreen extends StatelessWidget {
  final String userId;
  const ExamsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context).findById(userId);
    List<Map<String, String>> userExams =
        user.exams as List<Map<String, String>>;
    return ListView.builder(
        itemCount: userExams.length,
        itemBuilder: (ctx, index) {
          return ExamElement(
              title: userExams[index]['title']!,
              youtubeVideoAdress: userExams[index]['youtubeVideoAdress']!);
        });
  }
}

class ExperienceScreen extends StatelessWidget {
  final String userId;
  const ExperienceScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context).findById(userId);
    List<Map<String, String>> userExperience =
        user.experience as List<Map<String, String>>;
    return ListView.builder(
        itemCount: userExperience.length,
        itemBuilder: (ctx, index) {
          return ExperienceElement(
              title: userExperience[index]['title']!,
              imageUrl: userExperience[index]['imageUrl']!);
        });
  }
}

class UserInfoScreen extends StatelessWidget {
  final String userId;
  const UserInfoScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context).findById(userId);
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

class UserProfileScreen extends StatelessWidget {
  Widget? screen1;
  Widget? screen2;
  Widget? screen3;
  Widget? screen4;
  String? title1;
  String? title2;
  String? title3;
  String? title4;
  final String id;

  UserProfileScreen({
    required this.id,
    this.screen1,
    this.screen2,
    this.screen3,
    this.screen4,
    this.title1,
    this.title2,
    this.title3,
    this.title4,
    Key? key,
  }) : super(key: key);
  static const routeName = '/user-profile-screen';

  @override
  Widget build(BuildContext context) {
    if (screen1 == null) {
      screen1 = UserInfoScreen(userId: id);
    }
    if (screen2 == null) {
      screen2 = CertificatesScreen(userId: id);
    }
    if (screen3 == null) {
      screen3 = ExperienceScreen(userId: id);
    }
    if (screen4 == null) {
      screen4 = ExamsScreen(userId: id);
    }
    if (title1 == null) {
      title1 = 'information';
    }
    if (title2 == null) {
      title2 = 'Certificates';
    }
    if (title3 == null) {
      title3 = 'Experience';
    }
    if (title4 == null) {
      title4 = 'verified Exams';
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
          bottom: TabBar(isScrollable: true, tabs: [
            Tab(
              icon: const Icon(Icons.account_circle_outlined, size: 15),
              text: title1,
              height: 50,
            ),
            Tab(
              icon: const Icon(Icons.beenhere_outlined, size: 15),
              height: 50,
              text: title2,
            ),
            Tab(
              icon: const Icon(Icons.star_border, size: 15),
              text: title3,
              height: 50,
            ),
            Tab(
              icon: const Icon(Icons.verified_outlined, size: 15),
              text: title4,
              height: 50,
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            screen1!,
            screen2!,
            screen3!,
            screen4!,
          ],
        ),
      ),
    );
  }
}

class UsersScreen extends StatefulWidget {
  static const routeName = '/users-screen';
  Widget? screen1;
  Widget? screen2;
  Widget? screen3;
  Widget? screen4;
  String? title1;
  String? title2;
  String? title3;
  String? title4;

  UsersScreen({
    this.screen1,
    this.screen2,
    this.screen3,
    this.screen4,
    this.title1,
    this.title2,
    this.title3,
    this.title4,
    Key? key,
  }) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  bool x = true;
  bool isLoading = true;
  @override
  void didChangeDependencies() {
    if (x) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Users>(context).fetchUsers().then((_) {
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
      body: isLoading
          ? CircularProgressIndicator()
          : UsersList(
              screen1: widget.screen1,
              screen2: widget.screen2,
              screen3: widget.screen3,
              screen4: widget.screen4,
              title1: widget.title1,
              title2: widget.title2,
              title3: widget.title3,
              title4: widget.title4,
            ),
    );
  }
}

class ExamElement extends StatefulWidget {
  final String title;
  final String youtubeVideoAdress;
  const ExamElement({
    Key? key,
    required this.title,
    required this.youtubeVideoAdress,
  }) : super(key: key);

  @override
  State<ExamElement> createState() => _ExamElementState();
}

class _ExamElementState extends State<ExamElement> {
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
              YoutubePlayer(
                  bottomActions: [], width: 300, controller: _controller),
              SizedBox(
                height: 10,
              ),
              Text(widget.title),
            ],
          ),
        ));
  }
}

class ExperienceElement extends StatelessWidget {
  final String title;
  final String imageUrl;
  const ExperienceElement({
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

class UserListItem extends StatelessWidget {
  Widget? screen1;
  Widget? screen2;
  Widget? screen3;
  Widget? screen4;
  String? title1;
  String? title2;
  String? title3;
  String? title4;
  final String id;

  UserListItem({
    required this.id,
    this.screen1,
    this.screen2,
    this.screen3,
    this.screen4,
    this.title1,
    this.title2,
    this.title3,
    this.title4,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
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
          return UserProfileScreen(
            id: user.id,
            screen1: screen1,
            screen2: screen2,
            screen3: screen3,
            screen4: screen4,
            title1: title1,
            title2: title2,
            title3: title3,
            title4: title4,
          );
        }));
      },
    );
  }
}

class UsersList extends StatelessWidget {
  Widget? screen1;
  Widget? screen2;
  Widget? screen3;
  Widget? screen4;
  String? title1;
  String? title2;
  String? title3;
  String? title4;

  UsersList({
    this.screen1,
    this.screen2,
    this.screen3,
    this.screen4,
    this.title1,
    this.title2,
    this.title3,
    this.title4,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users>(context).users;

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: users[index],
          child: UserListItem(
            id: users[index].id,
            screen1: screen1,
            screen2: screen2,
            screen3: screen3,
            screen4: screen4,
            title1: title1,
            title2: title2,
            title3: title3,
            title4: title4,
          ),
        );
      },
    );
  }
}

class GTechApp extends StatelessWidget {
  Widget? tab1;
  Widget? tab2;
  Widget? tab3;
  Widget? tab4;
  String? title1;
  String? title2;
  String? title3;
  String? title4;

  GTechApp({
    this.tab1,
    this.tab2,
    this.tab3,
    this.tab4,
    this.title1,
    this.title2,
    this.title3,
    this.title4,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((ctx) => Users())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: UsersScreen(
          screen1: tab1,
          screen2: tab2,
          screen3: tab3,
          screen4: tab4,
          title1: title1,
          title2: title2,
          title3: title3,
          title4: title4,
        ),
      ),
    );
  }
}
