var nodemailer = require("nodemailer");
const fs = require("fs");
const path = require("path");

const email = [];

const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: Number(process.env.SMTP_PORT) || 465,
  secure: true,
  auth: {
    user: process.env.USER_EMAIL,
    pass: process.env.PASS_EMAIL,
  },
});

const transporter2 = transporter;

email.sendEmail = async (params, result) => {

  const { variables_template = [], template_path = null, data_email, mode = 'admin' } = params;
  let template = ""
  let attachments = [];
  if(template_path){
    template = await readTemplate(template_path, variables_template);
  }
  if(data_email.attachments && data_email.attachments.length > 0){
    for (const item of data_email.attachments) {
      let buffer = fs.readFileSync(item.content);
      attachments.push({ filename: item.filename, content: buffer })
    }
  }

  var mail_options = {
    from: `"Kintok" <${process.env.USER_EMAIL}>`,
    to: [...data_email.email],
    subject: data_email.subject,
    bcc: data_email.bcc ?? [],
    html: template,
    attachments: attachments,
  };

  console.log(mail_options)

  if(mode === 'admin'){
    transporter.sendMail(mail_options, function (error, info) {
      if (error) {
        console.log(error);
      } else {
        console.log("Email sent: " + info.response);
      }
    });
  }else{
    transporter2.sendMail(mail_options, function (error, info) {
      if (error) {
        console.log(error);
      } else {
        console.log("Email sent: " + info.response);
      }
    });
  }
};

async function readTemplate (template_path, template_variables){
  return new Promise((resolve, reject) => {
    fs.readFile(path.join(__dirname,template_path), "utf8", (err, content) => {
      if (err) {
        resolve(false);
      } else {
        template_variables.forEach((element) => {
          var regex = new RegExp(element.name, "g");
          content = content.replace(regex, element.value);
        });
        resolve(content);
      }
    });
  });
};

module.exports = email;
