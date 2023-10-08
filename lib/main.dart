import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TarefaApp());
}
//teste

class TarefaApp extends StatelessWidget {
  const TarefaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TelaTarefa(),
    );
  }
}

class TelaTarefa extends StatefulWidget {
  const TelaTarefa({super.key});

  @override
  State<TelaTarefa> createState() => _TelaTarefaState();
}

class _TelaTarefaState extends State<TelaTarefa> {
  final TextEditingController _tarefaController = TextEditingController();
  List<String> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  void _carregarTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tarefas = prefs.getStringList('tarefas') ?? [];
    });
  }

  void _salvarTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tarefas', _tarefas);
  }

  void _adicionarTarefa() {
    setState(() {
      final novaTarefa = _tarefaController.text;
      if (novaTarefa.isNotEmpty) {
        _tarefas.add(novaTarefa);
        _tarefaController.clear();
        _salvarTarefas();
      }
    });
  }

  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
      _salvarTarefas();
    });
  }

  void _editarTarefa(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Tarefa'),
          content: TextField(
              controller: TextEditingController(text: _tarefas[index]),
              decoration: const InputDecoration(labelText: 'Tarefa'),
              onChanged: (value) {
                setState(() {
                  _tarefas[index] = value;
                });
              }),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                _salvarTarefas();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: _tarefas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_tarefas[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editarTarefa(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removerTarefa(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Adicionar Tarefa'),
                content: TextField(
                  controller: _tarefaController,
                  decoration: const InputDecoration(labelText: 'Tarefa'),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Adicionar'),
                    onPressed: () {
                      _adicionarTarefa();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
