import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: FormularioIdade()));

class FormularioIdade extends StatefulWidget {
  @override
  _FormularioIdadeState createState() => _FormularioIdadeState();
}

class _FormularioIdadeState extends State<FormularioIdade> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  DateTime? dataNascimento;
  String sexo = 'Homem';

  int calcularIdade(DateTime nascimento) {
    final hoje = DateTime.now();
    int idade = hoje.year - nascimento.year;
    if (hoje.month < nascimento.month ||
        (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
      idade--;
    }
    return idade;
  }

  void _selecionarData() async {
    DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (data != null) {
      setState(() {
        dataNascimento = data;
      });
    }
  }

  void _validarFormulario() {
    if (_formKey.currentState!.validate()) {
      int idade = calcularIdade(dataNascimento!);
      if (idade < 18) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Idade deve ser maior que 18 anos")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Formulário válido!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulário Flutter')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Nome Completo'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Informe o nome completo'
                  : null,
              onChanged: (value) => nome = value,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(dataNascimento == null
                    ? 'Selecione a data de nascimento'
                    : 'Data: ${dataNascimento!.day}/${dataNascimento!.month}/${dataNascimento!.year}'),
                Spacer(),
                ElevatedButton(
                  onPressed: _selecionarData,
                  child: Text('Escolher Data'),
                ),
              ],
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: sexo,
              items: ['Homem', 'Mulher']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (value) => setState(() => sexo = value!),
              decoration: InputDecoration(labelText: 'Sexo'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _validarFormulario,
              child: Text('Cadastrar'),
            ),
          ]),
        ),
      ),
    );
  }
}
