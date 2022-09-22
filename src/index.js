const express = require("express");
const http = require("http");
const mongoose = require("mongoose");
const { ApolloServer } = require("apollo-server-express");
const {
  ApolloServerPluginDrainHttpServer,
  ApolloServerPluginLandingPageLocalDefault,
} = require("apollo-server-core");
require("dotenv").config();

const typeDefs = require("./graphql/typeDefs");
const resolvers = require("./graphql/resolvers");

// Constants
const HOST = process.env.HOST || "http://127.0.0.1";
const PORT = process.env.PORT || 4000;
// const env = process.env.NODE_ENV || "development";
const MONGO_DB_URI = process.env.MONGO_DB_URI || "mongodb://localhost:27017";

async function run() {
  // Connect to MongoDB
  await mongoose.connect(MONGO_DB_URI);

  // Start Apollo Server
  const app = express();
  const httpServer = http.createServer(app);
  const server = new ApolloServer({
    typeDefs,
    resolvers,
    csrfPrevention: true,
    cache: "bounded",
    plugins: [
      ApolloServerPluginDrainHttpServer({ httpServer }),
      ApolloServerPluginLandingPageLocalDefault({ embed: true }),
    ],
  });

  await server.start();
  server.applyMiddleware({ app });
  await new Promise((resolve) => httpServer.listen({ port: PORT }, resolve));
  console.log(`🚀 Server ready at ${HOST}:${PORT}${server.graphqlPath}`);
}

run().catch((err) => console.log(err));
