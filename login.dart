import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter_localizations/flutter_localizations.dart' hide GlobalMaterialLocalizations, GlobalCupertinoLocalizations;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await Firebase.initializeApp();
  }catch (e){
    debugPrint("Erro: $e");
  }
  

  // Configura os provedores do Firebase UI Auth
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(clientId: 'CLIENT_ID'), 
    // Nota: No Android/iOS o GoogleProvider costuma ler direto do arquivo de configuração do Firebase, 
    // mas o clientId web pode ser exigido dependendo da plataforma.
  ]);

  runApp(const MyApp());
}

// Notifier simples para gerenciar o idioma globalmente na UI de login
class LanguageController extends ChangeNotifier {
  Locale _locale = const Locale('pt', 'BR');

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}

final languageController = LanguageController();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: languageController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Firebase Auth App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          locale: languageController.locale,
          localizationsDelegates: [
            // Delegações nativas do Firebase UI Auth traduzidas
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            //FirebaseUIAuthLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
            Locale('en', 'US'),
          ],
          home: const AuthGate(),
        );
      },
    );
  }
}

/// Gerencia se o usuário está logado ou deve ver a tela de login
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Usuário não autenticado: Exibe a tela de login personalizada com seletor de idioma
          return const CustomLoginScreen();
        }

        // Usuário autenticado: Tela principal do app
        return const HomeScreen();
      },
    );
  }
}

class CustomLoginScreen extends StatelessWidget {
  const CustomLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isPortuguese = languageController.locale.languageCode == 'pt';

    return SignInScreen(
      // Adiciona o seletor de idioma com bandeiras no topo da tela de login
      headerBuilder: (context, constraints, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Botão Português (Bandeira do Brasil)
              InkWell(
                onTap: () => languageController.setLocale(const Locale('pt', 'BR')),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isPortuguese ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('🇧🇷 PT', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 12),
              // Botão Inglês (Bandeira dos EUA)
              InkWell(
                onTap: () => languageController.setLocale(const Locale('en', 'US')),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: !isPortuguese ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('🇺🇸 EN', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        );
      },
      providers: [
        EmailAuthProvider(),
        GoogleProvider(clientId: ''), // Ajuste se necessário para sua plataforma
      ],
      subtitleBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            isPortuguese 
              ? 'Bem-vindo! Faça login para continuar.' 
              : 'Welcome! Please sign in to continue.',
            textAlign: TextAlign.center,
          ),
        );
      },
      footerBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            isPortuguese
              ? 'Ao continuar, você concorda com os termos.'
              : 'By continuing, you agree to the terms.',
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            Text(
              'Logado com sucesso!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('E-mail: ${user?.email ?? "Usuário Google"}'),
          ],
        ),
      ),
    );
  }
}