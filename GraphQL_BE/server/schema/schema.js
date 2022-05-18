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
                return User.findById(parent.userId);
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
                return User.findById(parent.userId);
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
                return User.find({});
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
                return Hobby.findById(args.id);
            },
        },
        hobbies: {
            type: new GraphQLList(HobbyType),
            resolve(parent, args){
                return Hobby.find();
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
                return Post.findById(args.id);
            },
        },
        posts: {
            type: new GraphQLList(PostType),
            resolve(parent, args){
                return Post.find({});
            } 
        },
    },
});

// Mutations: The purpose of mutations is modify data
const Mutation = new GraphQLObjectType({
    name: 'Mutation',
    fields: {
        CreateUser: {
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
        UpdateUser: {
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
        RemoveUser: {
            type: UserType,
            args: {
                id: {type: GraphQLNonNull(GraphQLString)},
            },
            resolve(parent, args){
                let removeUser = User.findByIdAndRemove(args.id).exec();
                if(!removeUser){
                    throw new 'Error'()
                }
                return removeUser;
            }

        },
        CreatePost:{
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
        UpdatePost: {
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
        RemovePost: {
            type: PostType,
            args: {
                id: {type: GraphQLNonNull(GraphQLString)},
            },
            resolve(parent, args){
                let removePost = Post.findByIdAndRemove(args.id).exec();
                if(!removePost){
                    throw new 'Error'()
                }
                return removePost;
            }

        },
        CreateHobby: {
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
        UpdateHobby: {
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
        RemoveHobby: {
            type: HobbyType,
            args: {
                id: {type: GraphQLNonNull(GraphQLString)},
            },
            resolve(parent, args){
                let removeHobby = Hobby.findByIdAndRemove(args.id).exec();
                if(!removeHobby){
                    throw new 'Error'()
                }
                return removeHobby;
            }

        },
    }
});

module.exports = new GraphQLSchema({
    query: RootQuery,
    mutation: Mutation,
});