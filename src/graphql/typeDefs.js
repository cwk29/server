const { gql } = require("apollo-server-express");

module.exports = gql`
  input ContactFormInput {
    name: String!
    email: String!
    organization: String!
    topic: String!
    message: String!
  }

  input ShopFormInput {
    name: String!
    company: String!
    email: String!
    telephone: String!
    specifications: String!
  }

  type Query {
    hello: String
  }

  type Subscription {
    countdown(from: Int!): Int!
  }

  type Mutation {
    postContactForm(contactFormInput: ContactFormInput!, token: String!): Boolean
    postShopForm(shopFormInput: ShopFormInput!, token: String!): Boolean
  }
`;
