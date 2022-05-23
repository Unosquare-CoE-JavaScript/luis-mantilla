import 'package:client_app/pages/hobby_form_page.dart';
import 'package:client_app/pages/post_form_page.dart';
import 'package:client_app/utils/queries.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<QueryResult<Object?>?> Function()? refetchHobbies;
Future<QueryResult<Object?>?> Function()? refetchPosts;

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({Key? key, required this.user}) : super(key: key);

  final dynamic user;

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user['name']),
      ),
      body: Column(
        children: [
          UserCard(user: widget.user),
          if (_selectedIndex == 0) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Hobbies',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Expanded(
              child: _HobbiesList(userId: widget.user['id']),
            ),
          ],
          if (_selectedIndex == 1) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Posts',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Expanded(
              child: _PostsList(userId: widget.user['id']),
            ),
          ]
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_selectedIndex == 0) {
            final reload = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HobbyFormPage(userId: widget.user['id']),
              ),
            );
            if (reload != null && reload) {
              refetchHobbies!();
            }
          } else {
            final reload = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PostFormPage(userId: widget.user['id']),
              ),
            );
            if (reload != null && reload) {
              refetchPosts!();
            }
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            label: 'Hobbies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Posts',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class UserCard extends StatelessWidget {
  const UserCard({Key? key, required this.user}) : super(key: key);

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        ]),
      ),
    );
  }
}

class _PostsList extends StatelessWidget {
  const _PostsList({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.getPosts),
          variables: {
            'id': userId,
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
        builder: (result, {fetchMore, refetch}) {
          refetchPosts = refetch;
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (result.data != null) {
            final List posts = result.data!['user']['posts'];
            if (posts.isEmpty) {
              return const Center(
                child: Text('No posts available'),
              );
            }
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  onTap: () async {
                    final reload = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PostFormPage.edit(post: post),
                      ),
                    );

                    if (reload != null && reload) {
                      refetch!();
                    }
                  },
                  title: Text('Post ${index + 1}'),
                  subtitle: Text(post['comment']),
                  trailing: Mutation(
                    options: MutationOptions(
                      document: gql(Queries.removePost),
                      onCompleted: (data) {
                        refetch!();
                      },
                    ),
                    builder: (runMutation, result) {
                      return IconButton(
                        onPressed: () {
                          runMutation({'id': post['id']});
                        },
                        icon: const Icon(
                          Icons.delete,
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text('No posts available'),
          );
        });
  }
}

class _HobbiesList extends StatelessWidget {
  const _HobbiesList({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.getHobbies),
          variables: {
            'id': userId,
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
        builder: (result, {fetchMore, refetch}) {
          refetchHobbies = refetch;
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (result.data != null) {
            final List hobbies = result.data!['user']['hobbies'];
            if (hobbies.isEmpty) {
              return const Center(
                child: Text('No hobbies available'),
              );
            }
            return ListView.builder(
              itemCount: hobbies.length,
              itemBuilder: (context, index) {
                final hobby = hobbies[index];
                return ListTile(
                  onTap: () async {
                    final reload = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HobbyFormPage.edit(hobby: hobby),
                      ),
                    );
                    if (reload != null && reload) {
                      refetch!();
                    }
                  },
                  title: Text(hobby['title']),
                  subtitle: Text(hobby['description']),
                  trailing: Mutation(
                    options: MutationOptions(
                      document: gql(Queries.removeHobby),
                      onCompleted: (data) {
                        refetch!();
                      },
                    ),
                    builder: (runMutation, result) {
                      return IconButton(
                        onPressed: () {
                          runMutation({'id': hobby['id']});
                        },
                        icon: const Icon(
                          Icons.delete,
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text('No hobbies available'),
          );
        });
  }
}
