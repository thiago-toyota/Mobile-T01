
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = AuthService();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _auth.signIn(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        context.go('/modes');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'invalid-email':
            _error = 'E-mail inválido.';
            break;
          case 'user-not-found':
            _error = 'Conta não encontrada.';
            break;
          case 'wrong-password':
          case 'invalid-credential':
          case 'invalid-login-credentials':
            _error = 'E-mail ou senha incorretos.';
            break;
          case 'user-disabled':
            _error = 'Esta conta foi desativada.';
            break;
          default:
            _error = 'Não foi possível entrar. Tente novamente.';
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Ocorreu um erro inesperado.';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loginGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _auth.signInWithGoogle();

      if (mounted) {
        context.go('/modes');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = 'Não foi possível entrar com Google.';
      });
    } catch (e) {
      setState(() {
        _error = 'Ocorreu um erro ao entrar com Google.';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sopa de Contas',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 24),

                  const Text('Raul Yoshiyuki Komai'),
                  const Text('Thiago Massayuki Toyota'),

                  const SizedBox(height: 24),

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _loading ? null : _login,
                      child: _loading
                          ? const CircularProgressIndicator()
                          : const Text('Entrar'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _loading ? null : _loginGoogle,
                      icon: const Icon(Icons.login),
                      label: const Text('Entrar com Google'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: _loading
                        ? null
                        : () => context.go('/register'),
                    child: const Text('Não tem uma conta? Cadastre-se'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
