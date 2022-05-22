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

  static const String insertUser = ''' 
   mutation CreateUser(\$name: String!, \$age: Int!, \$profession: String!){
      CreateUser(name: \$name, age: \$age, profession: \$profession) {
        id
        name
      }
  }
  ''';

  static const String updateUser = '''
    mutation UpdateUser(\$id: String!, \$name: String!, \$profession: String!, \$age: Int!) {
      UpdateUser(id: \$id, name: \$name, profession: \$profession, age: \$age){
         
         name
      }   
    }
  ''';

  static const String removeUser = '''
         mutation RemoveUser(\$id: String!) {
           RemoveUser(id: \$id){
             name
               }
           }
        ''';
}

String insertPost() {
  return """
    mutation CreatePost(\$comment: String!, \$userId: String!) {
      CreatePost(comment: \$comment, userId: \$userId){
         id
         comment
      }   
    }
    """;
}

String insertHobby() {
  return """
    mutation CreateHobby(\$title: String!, \$description: String!, \$userId: String!) {
      CreateHobby(title: \$title, description: \$description, userId: \$userId){
         id
         title
      }   
    }
    """;
}

String removePosts() {
  return """ 
    mutation RemovePosts(\$ids: [String]) {
      RemovePosts(ids: \$ids){
         
      }   
    }
    """;
}

String removeHobbies() {
  return """
    mutation RemoveHobbies(\$ids: [String]) {
      RemoveHobbies(ids: \$ids){
      
         
      }   
    }
     """;
}
