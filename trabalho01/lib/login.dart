import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:login/firebase_options.dart';

// Notifier global para gerenciar o idioma atual da aplicação
final ValueNotifier<Locale> localeNotifier = ValueNotifier<Locale>(const Locale('pt', 'BR'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialize o Firebase (Certifique-se de configurar o firebase_options.dart gerado pelo FlutterFire CLI)
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);

  // Configure os provedores do Firebase UI Auth
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(clientId: 'SEU_CLIENT_ID_DO_GOOGLE.apps.googleusercontent.com'), // Opcional no Android/iOS se usar o google-services.json/GoogleService-Info.plist
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, child) {
        return MaterialApp(
          title: 'Firebase Auth App',
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate, // Localizações do pacote Firebase UI
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
            Locale('en', 'US'),
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: const AuthGate(),
        );
      },
    );
  }
}

/// Gerencia o redirecionamento entre a Tela de Login e a Tela Principal após a autenticação
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData) {
          // Usuário não autenticado -> Exibe a tela de login customizada
          return const CustomLoginScreen();
        }

        // Usuário autenticado -> Tela principal
        return Scaffold(
          appBar: AppBar(
            title: const Text('Bem-vindo!'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => FirebaseAuth.instance.signOut(),
              ),
            ],
          ),
          body: Center(
            child: Text('Logado como: ${snapshot.data?.email ?? "Usuário Google"}'),
          ),
        );
      },
    );
  }
}

/// Tela de Login customizada utilizando o Firebase UI Auth + Seletor de Idioma com Bandeirinhas
class CustomLoginScreen extends StatelessWidget {
  const CustomLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [
        EmailAuthProvider(),
        GoogleProvider(clientId: 'SEU_CLIENT_ID_DO_GOOGLE.apps.googleusercontent.com'),
      ],
      headerBuilder: (context, constraints, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Seletor de Idioma com Bandeirinhas
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _languageButton(
                      flag: '🇧🇷',
                      languageCode: 'pt',
                      countryCode: 'BR',
                    ),
                    const SizedBox(width: 12),
                    _languageButton(
                      flag: '🇺🇸',
                      languageCode: 'en',
                      countryCode: 'US',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Icon(Icons.lock_outline, size: 10, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  'Acesse sua conta',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                const Text("Raul Yoshiyuki Komai"),
                const Text("Thiago Masayuki Toyota")
              ],
            ),
          ),
        );
      },
      subtitleBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            action == AuthAction.signIn
                ? 'Entre para continuar'
                : 'Crie sua conta para começar',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  /// Widget auxiliar para criar os botões de bandeirinha
  Widget _languageButton({
    required String flag,
    required String languageCode,
    required String countryCode,
  }) {
    final isSelected = localeNotifier.value.languageCode == languageCode;

    return InkWell(
      onTap: () {
        localeNotifier.value = Locale(languageCode, countryCode);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 6),
            Text(
              languageCode.toUpperCase(),
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}