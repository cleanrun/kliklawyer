import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;
String uid, phoneNumber;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  // final DatabaseReference dbs =
  //     FirebaseDatabase.instance.reference().child('users');

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  // Checking if email and name is null
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;

  // Only taking the first part of the name, i.e., First Name
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  uid = user.uid.toString();
  phoneNumber = user.phoneNumber.toString();

  // dbs.child(uid).set({
  //   'id': uid,
  //   'fullName': name,
  //   'password': '',
  //   'phoneNumber': '',
  // });

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  await FirebaseAuth.instance.signOut();

  SharedPreferences pref = await SharedPreferences.getInstance();
  int hasChat = pref.getInt('hasChat');
  String count = pref.getString('konsultasiChat');
  print("HASCHAT LOGOUT : $hasChat");

  pref.setString('numberPhone', null);
  pref.clear();
  //messages.clear();
  //pref.setBool('hasUser', false);
  pref.setBool('onBoarding', true);
  pref.setInt('hasChat', 0);
  pref.setString('konsultasiChat', count);

  print("User Sign Out");
}