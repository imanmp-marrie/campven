import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_service.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login dengan Google
  static Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        // Simpan ke SharedPreferences
        final authService = AuthService();
        await authService.saveLogin(
          user.displayName ?? 'User',
          user.email ?? '',
        );
      }

      return user;
    } catch (e) {
      print('Error Google Sign In: $e');
      return null;
    }
  }

  // Logout Google
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    final authService = AuthService();
    await authService.logout();
  }

  // Cek user yang sedang login
  static User? getCurrentUser() {
    return _auth.currentUser;
  }
}