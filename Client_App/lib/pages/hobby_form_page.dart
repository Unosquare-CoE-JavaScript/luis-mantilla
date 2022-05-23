import 'package:client_app/utils/queries.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HobbyFormPage extends StatefulWidget {
  const HobbyFormPage({
    Key? key,
    required this.userId,
    this.hobby,
    this.isEditing = false,
  }) : super(key: key);

  const HobbyFormPage.edit({
    Key? key,
    this.userId,
    required this.hobby,
    this.isEditing = true,
  }) : super(key: key);

  final dynamic hobby;
  final String? userId;
  final bool isEditing;

  @override
  State<HobbyFormPage> createState() => _HobbyFormPageState();
}

class _HobbyFormPageState extends State<HobbyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _titleController.text = widget.hobby['title'];
      _descriptionController.text = widget.hobby['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    const separator = SizedBox(height: 12);
    return Scaffold(
      appBar: AppBar(
        title: widget.isEditing
            ? const Text('Edit Hobby')
            : const Text('New Hobby'),
      ),
      body: SingleChildScrollView(
        child: Mutation(
          options: MutationOptions(
            document: widget.isEditing
                ? gql(Queries.updateHobby)
                : gql(Queries.insertHobby),
            fetchPolicy: FetchPolicy.noCache,
            onCompleted: (data) {
              setState(() {
                isSaving = false;
              });
              var snackBar = SnackBar(
                content: widget.isEditing
                    ? const Text('The hobby was updated successfully!')
                    : const Text('The hobby was created successfully!'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).pop(true);
            },
          ),
          builder: (runMutation, result) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Title cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                  ),
                  separator,
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      label: Text('Description'),
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Description cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
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
                                'id': widget.isEditing
                                    ? widget.hobby['id']
                                    : null,
                                'title': _titleController.text.trim(),
                                'description':
                                    _descriptionController.text.trim(),
                                'userId':
                                    !widget.isEditing ? widget.userId : null,
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
