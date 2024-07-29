getBaseUrl() {
  return "https://blog-api-nodejs-production-c3e1.up.railway.app";
}

var token = '';
Map<String, dynamic> userDetails = {
  'name': '',
  'photo': '',
  'email': '',
  'id': ''
};

void saveUserDetails(String firstname, String lastname, String profilePhoto,
    String mail, String id) {
  userDetails['name'] = '$firstname $lastname';
  userDetails['photo'] = profilePhoto;
  userDetails['email'] = mail;
  userDetails["id"] = id;
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
