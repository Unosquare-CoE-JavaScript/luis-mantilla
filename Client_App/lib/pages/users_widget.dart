import 'package:client_app/pages/user_page.dart';
import 'package:client_app/utils/queries.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UsersWidget extends StatefulWidget {
  const UsersWidget({Key? key}) : super(key: key);

  @override
  State<UsersWidget> createState() => _UsersWidgetState();
}

class _UsersWidgetState extends State<UsersWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Query(
      options: QueryOptions(
        document: gql(Queries.getUsersQuery),
        fetchPolicy: FetchPolicy.noCache,
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (result.data != null) {
          final List users = result.data!['users'];

          return users.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  user['name'],
                                  style: theme.textTheme.bodyText1!.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Profession: ${user['profession']}',
                                  style: theme.textTheme.subtitle1,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Age: ${user['age']}',
                                  style: theme.textTheme.subtitle1,
                                ),
                              ],
                            ),
                            const Expanded(child: SizedBox.shrink()),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => UserPage.edit(
                                      user: user,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit, color: Colors.grey),
                            ),
                            Mutation(
                              options: MutationOptions(
                                document: gql(Queries.removeUser),
                                onCompleted: (data) {
                                  refetch!();
                                },
                              ),
                              builder: (runMutation, result) {
                                return IconButton(
                                  onPressed: () {
                                    runMutation({'id': user['id']});
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('No users available'),
                );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
