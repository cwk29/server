const { model, Schema } = require("mongoose");
// export interface Career {
//   clearanceLevel: String,
//   polyLevel: String,
//   category: String,
//   location: String,
//   title: String,
//   description: String,
//   capabilities: Array<string>;
//   experience: Array<string>;
//   certifications?: Array<string>;
// }

const CareerSchema = new Schema({
  clearanceLevel: String,
  polyLevel: String,
  category: String,
  location: String,
  title: String,
  description: String,
  capabilities: Array<String>,
  experience: Array<String>,
  certifications: Array<String>,
});

const Model = model("Career", CareerSchema);

module.exports = Model;
