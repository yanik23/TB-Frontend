
import 'dart:html';

import 'package:flutter_riverpod/flutter_riverpod.dart';



class ClientsNotifier extends StateNotifier<List<Client>> {
  ClientsNotifier() : super([]);

  void addClient(Client client) {
    state = [...state, client];
  }

  void updateClient(Client client) {
    state = state.map((c) => c.id == client.id ? client : c).toList();
  }

  void removeClient(Client client) {
    state = state.where((c) => c.id != client.id).toList();
  }




}

final clientsProvider = StateNotifierProvider<ClientsNotifier, List<Client>>((ref) {
  return ClientsNotifier();
});

