const graphql = require('graphql');
var _ = require('lodash');
const User = require('../model/user');
const Hobby = require('../model/hobby');
const Post = require('../model/post');

const {
    GraphQLObjectType,
    GraphQLID,
    GraphQLString,
    GraphQLInt,
    GraphQLList,
    GraphQLSchema,
    GraphQLNonNull,
} = graphql;

// Create Types
const UserType = new GraphQLObjectType({
    name: 'User',
    description: 'Add documentation for user...',
    fields: () => ({
        id: {type: GraphQLID},
        name: {type: GraphQLString},
        age: {type: GraphQLInt},
        profession: {type: GraphQLString},
        posts: {
            type: new GraphQLList(PostType),
            resolve(parent, args){
                return Post.find({userId: parent.id})
            }
        },
        hobbies: {
            type: new GraphQLList(HobbyType),
            resolve(parent, args){
                return Hobby.find({userId: parent.id});
            } 
        }
    }),
});

const HobbyType = new GraphQLObjectType({
    name: 'Hobby',
    description: 'Add documentation for Hobby...',
    fields: () => ({
        id: {type: GraphQLID},
        title: {type: GraphQLString},
        description: {type: GraphQLString},
        user: {
            type: UserType,
            resolve(parent, args){
                return _.find(usersData, {id: parent.userId})
            }
        }
    }),
});

const PostType = new GraphQLObjectType({
    name: 'Post',
    description: 'Add documentation for Post...',
    fields: () => ({
        id: {type: GraphQLID},
        comment: {type: GraphQLString},
        user:{
            type: UserType,
            resolve(parent, args){
                return _.find(usersData, {id: parent.userId});
            }
        }
    }),
});

// RootQuery (The path that allows the connection)
const RootQuery = new GraphQLObjectType({
    name: 'RootQueryType',
    description: 'Add a description',
    fields: {
        user: {
            type: UserType,
            args: {
                id: {
                    type: GraphQLID,
                }
            },
            resolve(parent, args){
                // We resolve with data get and return data from a data source
                // parent is the UserType
                return User.findById(args.id);
            },
        },
        users: {
            type: new GraphQLList(UserType),
            resolve(parent, args){
                return usersData;    
            } 
        },
        hobby: {
            type: HobbyType,
            args: {
                id: {
                    type: GraphQLID,
                }
            },
            resolve(parent, args){
                // We resolve with data get and return data from a data source
                // parent is the UserType
                return _.find(hobbyData, {id: args.id});
            },
        },
        hobbies: {
            type: new GraphQLList(HobbyType),
            resolve(parent, args){
                return Hobby.find({userId: parent.id});
            } 
        },
        post: {
            type: PostType,
            args: {
                id: {
                    type: GraphQLID,
                }
            },
            resolve(parent, args){
                // We resolve with data get and return data from a data source
                // parent is the UserType
                return _.find(postData, {id: args.id});
            },
        },
        posts: {
            type: new GraphQLList(PostType),
            resolve(parent, args){
                return Post.find({userId: parent.id});
            } 
        },
    },
});

// Mutations: The purpose of mutations is modify data
const Mutation = new GraphQLObjectType({
    name: 'Mutation',
    fields: {
        createUser: {
            type: UserType,
            args: {
                //id: {type: GraphQLID},
                name: {type: GraphQLNonNull(GraphQLString)},
                age: {type: GraphQLNonNull(GraphQLInt)},
                profession: {type: GraphQLString},             
            },
            resolve(parent, args){
                let user = User({
                    name: args.name,
                    age: args.age,
                    profession: args.profession,
                });
                
                return user.save();
            }
        },
        updateUser: {
            type: UserType,
            args: {
                id: {type: GraphQLNonNull(GraphQLString)},
                name: {type: GraphQLNonNull(GraphQLString)},
                age: {type: GraphQLNonNull(GraphQLInt)},
                profession: {type: GraphQLString},             
            },
            resolve(parent, args){
                return updateUser = User.findByIdAndUpdate(
                    args.id,
                    {
                        $set: {
                            name: args.name,
                            age: args.age,
                            profession: args.profession,
                        }
                    },
                    {new: true} // This is to send back the updated object
                );
            }
        },
        createPost:{
            type: PostType,
            args:{
                comment: {type: GraphQLNonNull(GraphQLString)},
                userId: {type: GraphQLNonNull(GraphQLID)},
            },
            resolve(parent, args){
                let post = Post({
                    comment: args.comment,
                    userId: args.userId,
                });

                return post.save();
            }
        },
        updatePost: {
            type: PostType,
            args:{
                id: {type: GraphQLNonNull(GraphQLString)},
                comment: {type: GraphQLNonNull(GraphQLString)},
            },
            resolve(parent, args){
                return updatePost = Post.findByIdAndUpdate(
                    args.id,
                    {
                        $set: {
                            comment: args.comment,
                        }
                    },
                    {new: true} // This is to send back the updated object
                );
            }
        },
        createHobby: {
            type: HobbyType,
            args:{
                title: {type: GraphQLNonNull(GraphQLString)},
                description: {type: GraphQLNonNull(GraphQLString)},
                userId: {type: GraphQLNonNull(GraphQLID)},
            },
            resolve(parent, args){
                let hobby = Hobby({
                    title: args.title,
                    description: args.description,
                    userId: args.userId,
                });

                return hobby.save();
            }
        },
        updateHobby: {
            type: HobbyType,
            args:{
                id: {type: GraphQLNonNull(GraphQLString)},
                title: {type: GraphQLNonNull(GraphQLString)},
                description: {type: GraphQLNonNull(GraphQLString)},
            },
            resolve(parent, args){
                return hobby = Hobby.findByIdAndUpdate(
                    args.id,
                    {
                        $set:{
                            title: args.title,
                            description: args.description,
                        }
                    },
                    {new: true}
                );
            }
        },
    }
});

module.exports = new GraphQLSchema({
    query: RootQuery,
    mutation: Mutation,
});