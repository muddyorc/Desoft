import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class AuthService {
  static bool isAuthenticated = false; // simulação simples
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rotas Nomeadas',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        // Middleware simples para checar autenticação
        if (settings.name == '/home' || settings.name == '/detalhes') {
          if (!AuthService.isAuthenticated) {
            return MaterialPageRoute(
              builder: (_) => LoginPage(mensagem: "Faça login para continuar!"),
            );
          }
        }

        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginPage());
          case '/home':
            return MaterialPageRoute(builder: (_) => HomePage());
          case '/detalhes':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => DetalhesPage(dados: args),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(child: Text("Rota não encontrada")),
              ),
            );
        }
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  final String? mensagem;
  LoginPage({this.mensagem});

  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  void _login(BuildContext context) {
    if (_userCtrl.text == "admin" && _passCtrl.text == "123") {
      AuthService.isAuthenticated = true;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuário ou senha inválidos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (mensagem != null) Text(mensagem!, style: TextStyle(color: Colors.red)),
            TextField(controller: _userCtrl, decoration: InputDecoration(labelText: "Usuário")),
            TextField(controller: _passCtrl, decoration: InputDecoration(labelText: "Senha"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => _login(context), child: Text("Entrar")),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final Map<String, dynamic> usuario = {
    "nome": "Julio Cezar",
    "nascimento": "19/08/2000",
    "telefone": "(64) 99999-9999"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bem-vindo à Home!"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/detalhes', arguments: usuario);
              },
              child: Text("Ir para Detalhes"),
            ),
          ],
        ),
      ),
    );
  }
}

class DetalhesPage extends StatelessWidget {
  final Map<String, dynamic> dados;
  DetalhesPage({required this.dados});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalhes do Usuário")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Nome: ${dados['nome']}", style: TextStyle(fontSize: 18)),
                Text("Nascimento: ${dados['nascimento']}"),
                Text("Telefone: ${dados['telefone']}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
