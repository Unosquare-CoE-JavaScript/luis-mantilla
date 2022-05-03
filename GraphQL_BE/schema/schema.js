const graphql = require('graphql');
var _ = require('lodash');

// dummy data
var usersData = [
    {id: '1', name: 'Bond', age: 31, profession: 'Test'},
    {id: '12', name: 'Bond 1', age: 32, profession: 'Test'},
    {id: '123', name: 'Bond 2', age: 33, profession: 'Test'},
    {id: '1234', name: 'Bond 4', age: 34, profession: 'Test'},
];

var hobbyData = [
    {id: '1', title: 'Hobby 1', description: 'description'},
    {id: '2', title: 'Hobby 2', description: 'description'},
    {id: '3', title: 'Hobby 3', description: 'description'},
    {id: '4', title: 'Hobby 4', description: 'description'},
];

var postData = [
    {id: '1', title: 'Post 1', description: 'description'},
    {id: '2', title: 'Post 2', description: 'description'},
    {id: '3', title: 'Post 3', description: 'description'},
    {id: '4', title: 'Post 4', description: 'description'},
];

const {
    GraphQLObjectType,
    GraphQLID,
    GraphQLString,
    GraphQLInt,
    GraphQLSchema,
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
    }),
});

const HobbyType = new GraphQLObjectType({
    name: 'Hobby',
    description: 'Add documentation for Hobby...',
    fields: () => ({
        id: {type: GraphQLID},
        title: {type: GraphQLString},
        description: {type: GraphQLString},
    }),
});

const PostType = new GraphQLObjectType({
    name: 'Post',
    description: 'Add documentation for Post...',
    fields: () => ({
        id: {type: GraphQLID},
        comment: {type: GraphQLString},
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
                    type: GraphQLString,
                }
            },
            resolve(parent, args){
                // We resolve with data get and return data from a data source
                // parent is the UserType
                return _.find(usersData, {id: args.id});
            },
        },
        hobby: {
            type: HobbyType,
            args: {
                id: {
                    type: GraphQLString,
                }
            },
            resolve(parent, args){
                // We resolve with data get and return data from a data source
                // parent is the UserType
                return _.find(hobbyData, {id: args.id});
            },
        },
        post: {
            type: PostType,
            args: {
                id: {
                    type: GraphQLString,
                }
            },
            resolve(parent, args){
                // We resolve with data get and return data from a data source
                // parent is the UserType
                return _.find(postData, {id: args.id});
            },
        },
    },
});

module.exports = new GraphQLSchema({
    query: RootQuery,
});