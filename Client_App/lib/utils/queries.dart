class Queries {
  static const String getUsersQuery = '''
    query {
      users{
        name
        id
        profession
        age
        posts{
          id
          comment
        }
        hobbies{
          id
          title
          description
        }
      }
    }
''';
}
