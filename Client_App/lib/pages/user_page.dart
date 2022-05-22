import 'package:client_app/pages/home_page.dart';
import 'package:client_app/utils/queries.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserPage extends StatefulWidget {
  const UserPage({
    Key? key,
    this.user,
    this.isEditing = false,
  }) : super(key: key);

  const UserPage.edit({
    Key? key,
    required this.user,
    this.isEditing = true,
  }) : super(key: key);

  final dynamic user;
  final bool isEditing;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _professionController = TextEditingController();
  final _ageController = TextEditingController();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _nameController.text = widget.user['name'];
      _professionController.text = widget.user['profession'];
      _ageController.text = widget.user['age'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    const separator = SizedBox(height: 12);
    return Scaffold(
      appBar: AppBar(
        title:
            widget.isEditing ? const Text('Edit User') : const Text('New User'),
      ),
      body: SingleChildScrollView(
        child: Mutation(
          options: MutationOptions(
            document: widget.isEditing
                ? gql(Queries.updateUser)
                : gql(Queries.insertUser),
            fetchPolicy: FetchPolicy.noCache,
            onCompleted: (data) {
              setState(() {
                isSaving = false;
              });
              var snackBar = SnackBar(
                content: widget.isEditing
                    ? const Text('The user was updated successfully!')
                    : const Text('The user was created successfully!'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
                (route) => false,
              );
            },
          ),
          builder: (runMutation, result) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      label: Text('Name'),
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                  ),
                  separator,
                  TextFormField(
                    controller: _professionController,
                    decoration: const InputDecoration(
                      label: Text('Profession'),
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Profession cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                  ),
                  separator,
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      label: Text('Age'),
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Age cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                  ),
                  separator,
                  isSaving
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isSaving = true;
                              });
                              runMutation({
                                'id':
                                    widget.isEditing ? widget.user['id'] : null,
                                'name': _nameController.text.trim(),
                                'profession': _professionController.text.trim(),
                                'age': int.parse(_ageController.text.trim()),
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 36,
                              vertical: 8,
                            ),
                            child: widget.isEditing
                                ? const Text('Update')
                                : const Text('Create'),
                          ),
                        ),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
