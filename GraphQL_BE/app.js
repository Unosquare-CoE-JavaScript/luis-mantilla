var express = require('express');
var { graphqlHTTP } = require('express-graphql');

const schema = require('./schema/schema');

const mongoose = require('mongoose');
const app = express();
const port = process.env.PORT || 4000;

app.use('/graphql', graphqlHTTP({
    schema: schema,
    graphiql: true,
}));
  
mongoose.connect(
    `mongodb+srv://${process.env.mongoUserName}:${process.env.mongoUserPassword}@graphqlcluster.klrp2.mongodb.net/${process.env.mongoDatabase}?retryWrites=true&w=majority`,
    {
        useNewUrlParser: true,
        useUnifiedTopology: true
    }
).then(() => {
    app.listen({port: port}, () => {
        console.log(`Listening port: ${port}`);
    });
}).catch((e) => console.log(e));