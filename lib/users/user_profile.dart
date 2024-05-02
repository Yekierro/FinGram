import 'package:fingram/button/rounded_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  int completedLessons = 0;
  int totalLessons = 0;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadUserLessons();
  }

  void _loadUserProfile() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref('users/$userId/information');

    DatabaseEvent event = await userRef.once();
    if (event.snapshot.exists) {
      Map<dynamic, dynamic> data =
          event.snapshot.value as Map<dynamic, dynamic>;
      _nameController.text = data['name'] ?? '';
      _ageController.text = data['age']?.toString() ?? '';
    }
  }

  void _loadUserLessons() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference progressRef =
        FirebaseDatabase.instance.ref('users/$userId/progress');

    DatabaseEvent progressEvent = await progressRef.once();
    if (progressEvent.snapshot.exists) {
      Map<dynamic, dynamic> progressMap =
          progressEvent.snapshot.value as Map<dynamic, dynamic>;
      int completed = progressMap.values
          .where((value) => value['isCompleted'] == true)
          .length;
      int total = progressMap.length;

      setState(() {
        completedLessons = completed;
        totalLessons = total;
      });
    }
  }

  void _updateInformation(String field, String value) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref('users/$userId/information');

    userRef.update({field: value}).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$field обновлен')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка: $error')));
    });
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
        'welcome_screen', (Route<dynamic> route) => false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int uncompletedLessons = totalLessons - completedLessons;
    List<PieChartSectionData> sections = [
      PieChartSectionData(
        color: Colors.green,
        value: completedLessons.toDouble(),
        title: 'Выполнено',
        showTitle: true,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: uncompletedLessons.toDouble(),
        title: 'Осталось',
        showTitle: true,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль пользователя'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Имя'),
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zа-яА-Я ]')),
              ],
            ),
            ElevatedButton(
              onPressed: () => _updateInformation('name', _nameController.text),
              child: const Text('Изменить имя'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Возраст'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(
                    RegExp(r'^[1-9][0-9]?$|^100$')),
              ],
            ),
            ElevatedButton(
              onPressed: () => _updateInformation('age', _ageController.text),
              child: const Text('Изменить возраст'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 5,
                  startDegreeOffset: -90,
                ),
              ),
            ),
            Text(
              'Уроков выполнено: $completedLessons/$totalLessons',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            RoundedButton(
                colour: Colors.red,
                title: 'Выйти из аккаунта',
                onPressed: _signOut),
          ],
        ),
      ),
    );
  }
}
