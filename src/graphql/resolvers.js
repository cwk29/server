const mailer = require("./helpers/mailer");

module.exports = {
  Query: {
    hello: () => "world",
  },
  Subscription: {
    countdown: {
      // This will return the value on every 1 sec until it reaches 0
      subscribe: async function* (_, { from }) {
        for (let i = from; i >= 0; i--) {
          await new Promise((resolve) => setTimeout(resolve, 1000));
          yield { countdown: i };
        }
      },
    },
  },
  Mutation: {
    // Mutation resolvers have 4 parameters:
    // have First parameter is the parent object, which is not used here
    // Second parameter is the arguments passed to the field in the query
    postContactForm: async (_, { contactFormInput, token }) => {
      if (!token) {
        throw new Error("Token not provided");
      }

      return await mailer.sendEmail(contactFormInput).catch(console.error);
    },
    postShopForm: async (_, { shopFormInput, token }) => {
      if (!token) {
        throw new Error("Token not provided");
      }

      return await mailer.sendEmail(shopFormInput).catch(console.error);
    },
  },
};
