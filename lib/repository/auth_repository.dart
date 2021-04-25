import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository() : _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signInWithCredentials(
      String email, String password) async {
      return await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = (await GoogleSignIn().signIn())!;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await _firebaseAuth.signInWithCredential(credential);
  }


  Future<UserCredential> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<List<void>> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> isSignedIn() async {
    if (_firebaseAuth.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<User?> getUser() async {
    return _firebaseAuth.currentUser;
  }
}
