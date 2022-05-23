import 'package:client_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  await initHiveForFlutter();
  final link = HttpLink(
    'http://graphql-flutter-course-coe.herokuapp.com/graphql',
  );
  final client = ValueNotifier<GraphQLClient>(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.client}) : super(key: key);

  final ValueNotifier<GraphQLClient> client;
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: const CacheProvider(
        child: MaterialApp(
          title: 'Client App',
          home: HomePage(),
        ),
      ),
    );
  }
}
