const nodemailer = require("nodemailer");
const NODEMAILER_USER = process.env.NODEMAILER_USER;
const NODEMAILER_PASS = process.env.NODEMAILER_PASS;

module.exports = {
  sendEmail: async (data) => {
    console.log("Starting transporter");

    // create reusable transporter object using the default SMTP transport
    let transporter = nodemailer.createTransport({
      host: "smtp.hostcentric.com",
      port: 465,
      secure: true, // true for 465, false for other ports
      auth: {
        user: NODEMAILER_USER, // hostcentric email
        pass: NODEMAILER_PASS, // hostcentric password
      },
      tls: {
        // do not fail on invalid certs
        rejectUnauthorized: false,
      },
    });

    console.log("Sending email");

    // send mail with defined transport object
    let info = await transporter.sendMail({
      from: NODEMAILER_USER, // sender address
      to: `${NODEMAILER_USER}, ckuykendall@wortechcorp.com`, // list of receivers
      subject: `📩 ${data.topic}`, // Subject line
      html: `
          <h1>New inquiry from, ${data.name}</h1>
          <p><b>Organization:</b> ${data.organization}</p>
          <p><b>Email:</b> ${data.email}</p>
          <p>${data.message}</p>
        `, // html body
    });

    console.log("Message sent: %s", info.messageId);

    if (info.messageId) {
      return true;
    }
    return false;
  },
};
