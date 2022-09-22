import { Schema, model, connect } from "mongoose";
import { Career } from "../models";

// 2. Create a mongoose schema from the interface above
const careerSchema = new Schema<Career>({
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

// 3. Create a model from the schema
const Career = model<Career>("Career", careerSchema);

run().catch((err) => console.log(err));

async function run() {
  // 4. Connect to MongoDB
  await connect("mongodb://localhost:27017/test");

  // 4. Declare a new career object
  const career = new Career({
    clearanceLevel: "Top Secret",
    polyLevel: "FSP",
    category: "Software Engineering",
    location: "New York, NY",
    title: "Software Engineer",
    description: "Full-Stack Software Engineer",
    capabilities: ["Java", "C#", "Angular"],
    experience: ["3 years"],
    certifications: ["AWS"],
  });

  // 6. Save the career object to MongoDB
  await career.save();

  console.log(career.title); // 'Software Engineer'
}

// todo - run this in a docker container and verify that the data is saved to mongodb
