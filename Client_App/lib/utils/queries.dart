class Queries {
  static const String getUsersQuery = '''
    query {
      users{
        name
        id
        profession
        age
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

  static const String removePosts = '''
    mutation RemovePosts(\$ids: [String]) {
      RemovePosts(ids: \$ids){
      }   
    }
  ''';

  static const String getPosts = '''
    query User(\$id: ID!){
      user(id: \$id){
        id
        posts{
          id
          comment
        }
      }
    }
  ''';

  static const String getHobbies = '''
    query Hobbies(\$id: ID!){
      user(id: \$id){
        id
        hobbies{
          id
          title
          description
        }
      }
    }
  ''';

  static const String insertPost = '''
    mutation CreatePost(\$comment: String!, \$userId: ID!) {
      CreatePost(comment: \$comment, userId: \$userId){
         id
         comment
      }   
    }
    ''';

  static const String updatePost = '''
    mutation UpdatePost(\$id: String!, \$comment: String!) {
      UpdatePost(id: \$id, comment: \$comment){
         comment
      }   
    }
    ''';

  static const String removePost = '''
    mutation RemovePost(\$id: String!) {
      RemovePost(id: \$id){
        comment
          }
      }
  ''';

  static const String insertHobby = '''
    mutation CreateHobby(\$title: String!, \$description: String!, \$userId: ID!) {
      CreateHobby(title: \$title, description: \$description, userId: \$userId){
         id
         title
      }   
    }
    ''';

  static const String updateHobby = '''
    mutation UpdateHobby(\$id: String!, \$title: String!, \$description: String!) {
      UpdateHobby(id: \$id, title: \$title, description: \$description){
         title
      }
    }
    ''';

  static const String removeHobby = '''
    mutation RemoveHobby(\$id: String!) {
      RemoveHobby(id: \$id){
        title
          }
      }
  ''';
}
