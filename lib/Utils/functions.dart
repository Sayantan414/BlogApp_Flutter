getBaseUrl() {
  return "https://blog-api-nodejs-production-c3e1.up.railway.app";
}

var token = '';
saveValidtoken(t) {
  token = "Bearer " + t;
  print(token);
}

getValidToken() {
  return token;
}
