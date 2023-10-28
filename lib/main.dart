import 'package:flutter/material.dart'; // Importando o framework Flutter para construir interfaces de usuário.
import 'package:shared_preferences/shared_preferences.dart'; // Importando o pacote shared_preferences para armazenar dados no dispositivo.

void main() {
  runApp(
      const TarefaApp()); // Iniciando o aplicativo Flutter ao renderizar a classe TarefaApp.
}

class TarefaApp extends StatelessWidget {
  const TarefaApp(
      {super.key}); // Definindo a classe TarefaApp, que é um widget StatelessWidget.

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:
          TelaTarefa(), // Definindo o aplicativo com MaterialApp e configurando a tela inicial para TelaTarefa.
    );
  }
}

class TelaTarefa extends StatefulWidget {
  const TelaTarefa(
      {super.key}); // Definindo a classe TelaTarefa, que é um widget StatefulWidget.

  @override
  State<TelaTarefa> createState() =>
      _TelaTarefaState(); // Criando o estado da tela TelaTarefa.
}

class _TelaTarefaState extends State<TelaTarefa> {
  final TextEditingController _tarefaController =
      TextEditingController(); // Controlador de texto para o campo de entrada de tarefas.
  List<String> _tarefas = []; // Lista para armazenar as tarefas.

  @override
  void initState() {
    super.initState();
    _carregarTarefas(); // Carregar tarefas salvas ao iniciar o aplicativo.
  }

  void _carregarTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tarefas = prefs.getStringList('tarefas') ??
          []; // Carregar tarefas salvas no SharedPreferences.
    });
  }

  void _salvarTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'tarefas', _tarefas); // Salvar tarefas no SharedPreferences.
  }

  void _adicionarTarefa() {
    setState(() {
      final novaTarefa = _tarefaController.text;
      if (novaTarefa.isNotEmpty) {
        _tarefas.add(novaTarefa); // Adicionar uma nova tarefa à lista.
        _tarefaController.clear();
        _salvarTarefas(); // Salvar as tarefas atualizadas.
      }
    });
  }

  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index); // Remover tarefa da lista.
      _salvarTarefas(); // Salvar as tarefas atualizadas.
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
                  _tarefas[index] =
                      value; // Atualizar a tarefa editada na lista.
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
                _salvarTarefas(); // Salvar as tarefas atualizadas após a edição.
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
                      _adicionarTarefa(); // Adicionar tarefa quando o botão "Adicionar" é pressionado.
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
