getBaseUrl() {
  return "https://blog-api-nodejs-production-c3e1.up.railway.app";
}

var token = '';
Map<String, dynamic> userDetails = {};

void saveUserDetails(Map<String, dynamic> data) {
  userDetails = data;
}

Map<String, dynamic> getUserDetails() {
  return userDetails;
}

saveValidtoken(t) {
  token = "Bearer " + t;
}

getValidToken() {
  return token;
}
