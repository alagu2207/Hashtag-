import 'package:flutter/material.dart';
import 'package:flutter_application_1/ProductListPage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hashtag billing solutions',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: ProductListPage(),
    );
  }
}

class GraphQLService {
  static final HttpLink httpLink = HttpLink(
    'http://localhost:3000/shop-api',
  );

  static final GraphQLClient _client = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  );

  static GraphQLClient get client => _client;
}





