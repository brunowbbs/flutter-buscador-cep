import 'package:cep_app/models/endereco_model.dart';
import 'package:cep_app/repositories/cep_repositoriy.dart';
import 'package:cep_app/repositories/cep_repositoriy_impl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryIml();
  EnderecoModel? enderecoModel;
  bool loading = false;

  final formKey = GlobalKey<FormState>();

  //SEMPRE QUE USAR UM CONTROLLER, PRECISA DECARTÁ_LA. (DISPOSE)
  final textEC = TextEditingController();

  @override
  void dispose() {
    textEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BUSCAR CEP'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: textEC,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'CEP Obrigatório';
                    }
                    return null;
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 30),
                  child: ElevatedButton(
                    onPressed: () async {
                      final isValid = formKey.currentState?.validate() ?? false;

                      if (isValid) {
                        try {
                          setState(() {
                            loading = true;
                          });
                          setState(() {
                            enderecoModel = null;
                          });
                          final endereco =
                              await cepRepository.getCep(textEC.text);
                          setState(() {
                            enderecoModel = endereco;
                          });
                        } catch (e) {
                          setState(() {
                            enderecoModel = null;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Erro ao buscar endereço"),
                            ),
                          );
                        } finally {
                          setState(() {
                            loading = false;
                          });
                        }
                      }
                    },
                    child: const Text("Buscar"),
                  ),
                ),
                Visibility(
                  visible: loading,
                  child: const CircularProgressIndicator(),
                ),
                Visibility(
                  visible: enderecoModel != null,
                  child: Text(
                    '${enderecoModel?.logradouro} ${enderecoModel?.complemento} ${enderecoModel?.cep}',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
