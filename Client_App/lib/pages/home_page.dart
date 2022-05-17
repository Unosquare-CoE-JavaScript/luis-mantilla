import 'package:client_app/pages/add_user_page.dart';
import 'package:client_app/pages/users_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users & Hobbies'),
        centerTitle: true,
      ),
      body: const UsersWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddUserPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
