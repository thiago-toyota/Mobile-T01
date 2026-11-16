import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:login/firebase_options.dart';

// Notifier global para gerenciar o idioma atual da aplicação
final ValueNotifier<Locale> localeNotifier = ValueNotifier<Locale>(const Locale('pt', 'BR'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(clientId: 'SEU_CLIENT_ID_DO_GOOGLE.apps.googleusercontent.com'),
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
          title: 'Firebase Firestore App',
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
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

/// Gerencia o redirecionamento entre a Tela de Login e a Tela Principal
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              // Indicador de progresso diferenciado durante o carregamento do Auth
              child: LoadingAnimationWidget.inkDrop(
                color: Colors.blue,
                size: 50,
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const CustomLoginScreen();
        }

        // Usuário autenticado -> Vai para a tela principal com dados do Firestore
        return UserDataScreen(user: snapshot.data!);
      },
    );
  }
}

/// Tela Principal que lê e escreve dados do Firestore usando FutureBuilder
class UserDataScreen extends StatefulWidget {
  final User user;
  const UserDataScreen({super.key, required this.user});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  // Referência para o documento do usuário atual no Firestore (coleção 'usuarios')
  late final DocumentReference _userDocRef;

  @override
  void initState() {
    super.initState();
    _userDocRef = FirebaseFirestore.instance.collection('usuarios').doc(widget.user.uid);
  }

  // Função para BUSCAR (ler) os dados usando Future
  Future<List<int>> _fetchUserScores() async {
    final docSnapshot = await _userDocRef.get();
    
    if (docSnapshot.exists && docSnapshot.data() != null) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      // Retorna a lista de inteiros guardada no campo 'pontuacoes'
      if (data.containsKey('pontuacoes')) {
        return List<int>.from(data['pontuacoes']);
      }
    }
    return []; // Retorna lista vazia se não existir documento ou campo
  }

  // Função para ADICIONAR (escrever) uma nova pontuação no array do Firestore
  Future<void> _addScore(int newScore) async {
    await _userDocRef.set({
      'email': widget.user.email,
      'pontuacoes': FieldValue.arrayUnion([newScore]), // Adiciona o inteiro ao array no Firestore
    }, SetOptions(merge: true));

    setState(() {}); // Atualiza a tela para o FutureBuilder recarregar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Painel de: ${widget.user.email ?? "Google User"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Suas Pontuações Salvas (Firestore):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              // Uso obrigatório de FutureBuilder para ler dados do Firestore
              child: FutureBuilder<List<int>>(
                future: _fetchUserScores(),
                builder: (context, snapshot) {
                  // Enquanto carrega, exibe o indicador diferenciado
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.indigo,
                        size: 50,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
                  }

                  final scores = snapshot.data ?? [];

                  if (scores.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma pontuação salva ainda. Adicione abaixo!'),
                    );
                  }

                  // Exibe a lista de inteiros recuperada do array
                  return ListView.builder(
                    itemCount: scores.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          title: Text('Pontuação: ${scores[index]}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Pontuação Aleatória'),
                onPressed: () {
                  // Gera uma pontuação aleatória de 1 a 100 e salva no Firestore
                  final randomScore = (DateTime.now().millisecond % 100) + 1;
                  _addScore(randomScore);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tela de Login customizada com seletor de idiomas e bandeirinhas
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _languageButton(flag: '🇧🇷', languageCode: 'pt', countryCode: 'BR'),
                  const SizedBox(width: 12),
                  _languageButton(flag: '🇺🇸', languageCode: 'en', countryCode: 'US'),
                ],
              ),
              const Text("Raul Yoshiyuki Komai",
                style: TextStyle(fontSize:5)
              ),
              const Text("Thiago Masayuki Toyota",
                style: TextStyle(fontSize:5)
              ),
              const SizedBox(height: 10),
              const Icon(Icons.cloud_sync, size: 10, color: Colors.blue),
              const SizedBox(height: 10),
              const Text(
                'Firestore Auth App',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _languageButton({required String flag, required String languageCode, required String countryCode}) {
    final isSelected = localeNotifier.value.languageCode == languageCode;

    return InkWell(
      onTap: () {
        localeNotifier.value = Locale(languageCode, countryCode);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 6),
            Text(languageCode.toUpperCase(), style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}