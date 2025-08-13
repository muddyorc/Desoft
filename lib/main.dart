import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: CarrosselFormularios()));

class CarrosselFormularios extends StatefulWidget {
  @override
  _CarrosselFormulariosState createState() => _CarrosselFormulariosState();
}

class _CarrosselFormulariosState extends State<CarrosselFormularios> {
  List<FormularioData> formularios = List.generate(5, (_) => FormularioData());

  int calcularIdade(DateTime nascimento) {
    final hoje = DateTime.now();
    int idade = hoje.year - nascimento.year;
    if (hoje.month < nascimento.month ||
        (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
      idade--;
    }
    return idade;
  }

  void _selecionarData(int index) async {
    DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (data != null) {
      setState(() {
        formularios[index].dataNascimento = data;
      });
    }
  }

  void _validarFormulario(int index) {
    var form = formularios[index];
    if (form.nome.isEmpty || form.dataNascimento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }
    int idade = calcularIdade(form.dataNascimento!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Carrossel de Formulários")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: formularios.length,
          itemBuilder: (context, index) {
            var form = formularios[index];
            return Container(
              width: 300,
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: "Nome Completo"),
                        onChanged: (value) => form.nome = value,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(form.dataNascimento == null
                                ? "Data de Nascimento"
                                : "${form.dataNascimento!.day}/${form.dataNascimento!.month}/${form.dataNascimento!.year}"),
                          ),
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selecionarData(index),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: form.sexo,
                        decoration: InputDecoration(labelText: "Sexo"),
                        items: ["Homem", "Mulher"]
                            .map((s) =>
                                DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (value) => setState(() => form.sexo = value!),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () => _validarFormulario(index),
                        child: Text("Cadastrar"),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FormularioData {
  String nome = '';
  DateTime? dataNascimento;
  String sexo = "Homem";
}
