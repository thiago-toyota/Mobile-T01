
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login com e-mail e senha.
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Cadastro com e-mail e senha.
  // Depois de criar a conta, encerra a sessão para voltar ao login.
  Future<void> register(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await _auth.signOut();
  }

  // Login com Google.
  Future<void> signInWithGoogle() async {
    final provider = GoogleAuthProvider();

    if (kIsWeb) {
      await _auth.signInWithPopup(provider);
    } else {
      await _auth.signInWithProvider(provider);
    }
  }

  // Logout.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Usuário atualmente autenticado.
  User? get currentUser => _auth.currentUser;

  // Observa alterações na autenticação.
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
