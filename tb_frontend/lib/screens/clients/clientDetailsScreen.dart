
import 'package:flutter/material.dart';


class ClientDetailsScreen extends StatefulWidget {
  static const routeName = '/client-details-screen';

  const ClientDetailsScreen({super.key});

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}


class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Details'),
      ),
      body: Container(),);
  }
}