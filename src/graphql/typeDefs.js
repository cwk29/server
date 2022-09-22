const { gql } = require("apollo-server-express");

module.exports = gql`
  input ContactFormInput {
    name: String!
    email: String!
    organization: String!
    topic: String!
    message: String!
  }

  type Query {
    hello: String
  }

  type Subscription {
    countdown(from: Int!): Int!
  }

  type Mutation {
    postContactForm(
      contactFormInput: ContactFormInput!
      token: String!
    ): Boolean
  }
`;
