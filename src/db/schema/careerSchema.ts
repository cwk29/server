import { Schema } from "mongoose";
import { Career } from "../../models";

export const careerSchema = new Schema<Career>({
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
