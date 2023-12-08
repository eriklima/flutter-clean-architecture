import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/modules/search/domain/errors/errors.dart';
import 'package:flutter_clean_architecture/modules/search/presenter/search/search_bloc.dart';
import 'package:flutter_clean_architecture/modules/search/presenter/search/states/state.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final bloc = Modular.get<SearchBloc>();

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Github Search'),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
          child: TextField(
            onChanged: bloc.add,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Search..."
            ),
          ),
        ),
        Expanded(
            child: StreamBuilder(
              stream: bloc.stream,
              builder: (context, snapshot) {
                final state = bloc.state;

                if (state is SearchStart) {
                  return const Center(
                    child: Text('Digite um nome.'),
                  );
                }

                if (state is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is SearchError) {
                  return Center(
                    child: (state.error is InvalidTextError) ? const Text("Texto inválido.") :
                    (state.error is DataSourceError) ? Text(
                        (state.error as DataSourceError).message != null
                            ? "Erro no datasource: ${(state.error as DataSourceError).message}"
                            : "Ocorreu um erro genérico no datasource.")
                    : const Text('Ocorreu um erro desconhecido'),
                  );
                }

                final list = (state as SearchSuccess).list;

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, id) {
                    final item = list[id];
                    return ListTile(
                      leading: item.img.isEmpty
                        ? Container()
                        : CircleAvatar(
                          backgroundImage: NetworkImage(item.img),
                        ),
                      title: Text(item.title),
                      subtitle: Text(item.content),
                    );
                  });
              },
            ),
        )
      ]),
    );
  }
}
