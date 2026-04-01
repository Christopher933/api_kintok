const JWT = require('jsonwebtoken');

exports.generateToken = (data, expire_in = null) => {
  let token;
  try {
    if (data) {
      token = JWT.sign(data, process.env.TOKEN_KEY, {
        expiresIn: expire_in ? expire_in : '30d',
      });
    } else {
      token = "Didn't received Token";
    }
  } catch (err) {
    token = err;
  }
  return token;
};

exports.validateToken = (token) => {
  if (!token) return null;
  try {
    return JWT.verify(token, process.env.TOKEN_KEY);
  } catch (err) {
    return null;
  }
};

exports.verifyAccess = (req, res, next) => {
  const auth = req.headers.authorization || "";
  const token = auth.startsWith("Bearer ") ? auth.slice(7) : auth;

  if (!token) {
    return res.status(401).json({
      status: false,
      message: "jwt must be provided",
    });
  }

  try {
    const decoded = JWT.verify(token, process.env.TOKEN_KEY);
    req.user = decoded; // opcional, útil para controllers
    return next();
  } catch (err) {
    return res.status(401).json({
      status: false,
      message: err.message || "Unauthorized access",
    });
  }
};


exports.generateTokenEmail = (data) => {
  let token;
  try {
    if (data) {
      token = JWT.sign(data, process.env.TOKEN_EMAIL, {
        expiresIn: '60m',
      });
    } else {
      token = null;
    }
  } catch (err) {
    token = err;
  }
  return token;
};

exports.validateTokenEmail = (token) => {
  let token_verificated;
  JWT.verify(token, process.env.TOKEN_EMAIL, (err, verifiedJwt) => {
    if (err) {
      token_verificated = { message: err.message, status: false };
    } else {
      token_verificated = { message: "Token valido", status: true, info_token: verifiedJwt };
    }
  });
  return token_verificated;
};