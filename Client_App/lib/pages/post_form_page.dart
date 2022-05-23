import 'package:client_app/utils/queries.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PostFormPage extends StatefulWidget {
  const PostFormPage({
    Key? key,
    required this.userId,
    this.post,
    this.isEditing = false,
  }) : super(key: key);

  const PostFormPage.edit({
    Key? key,
    this.userId,
    required this.post,
    this.isEditing = true,
  }) : super(key: key);

  final dynamic post;
  final String? userId;
  final bool isEditing;

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _commentController.text = widget.post['comment'];
    }
  }

  @override
  Widget build(BuildContext context) {
    const separator = SizedBox(height: 12);
    return Scaffold(
      appBar: AppBar(
        title:
            widget.isEditing ? const Text('Edit Post') : const Text('New Post'),
      ),
      body: SingleChildScrollView(
        child: Mutation(
          options: MutationOptions(
            document: widget.isEditing
                ? gql(Queries.updatePost)
                : gql(Queries.insertPost),
            fetchPolicy: FetchPolicy.noCache,
            onCompleted: (data) {
              setState(() {
                isSaving = false;
              });
              var snackBar = SnackBar(
                content: widget.isEditing
                    ? const Text('The post was updated successfully!')
                    : const Text('The post was created successfully!'),
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
                    controller: _commentController,
                    decoration: const InputDecoration(
                      label: Text('Comment'),
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Comment cannot be empty';
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
                                'id':
                                    widget.isEditing ? widget.post['id'] : null,
                                'comment': _commentController.text.trim(),
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
