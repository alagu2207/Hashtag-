import 'package:flutter/material.dart';
import 'package:flutter_application_1/detailedproducts.dart';

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  Future<List<Product>>? _productFuture;
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLiked = false; // This might not be needed globally.
  List<Product> _likedProducts =
      []; // Initialize an empty list for liked products.

  @override
  void initState() {
    super.initState();
    _productFuture = fetchProducts();
    _searchController.addListener(_filterProducts);
  }

  Future<List<Product>> fetchProducts() async {
    final client =
        GraphQLService.client; // Replace with your GraphQL client instance
    const String readProducts = """
     query {
      products {
        items {
          id
          name
          description
          assets {
            name
            source
          }
          createdAt
          updatedAt
        }
      }
    }
    """;

    final QueryOptions options = QueryOptions(
      document: gql(readProducts),
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      print(result.exception.toString());
      return [];
    }

    final List items = result.data?['products']['items'] ?? [];

    return items.map((item) {
      final asset = item['assets'] != null && item['assets'].isNotEmpty
          ? item['assets'][0]
          : null;
      return Product(
        id: item['id'],
        name: item['name'],
        description: item['description'],
        imageUrl: asset != null ? asset['source'] : '',
        createdAt: item['createdAt'],
        updatedAt: item['updatedAt'],
      );
    }).toList();
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        return product.id.toLowerCase().contains(query) ||
            product.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Products",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),

            // Add other navigation options here
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search by ID or Name",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No products available.'));
                }

                if (_products.isEmpty) {
                  _products = snapshot.data!;
                  _filteredProducts = _products;
                }

                if (_filteredProducts.isEmpty) {
                  return Center(child: Text('No results found.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return detailedproducts(product: product);
                          },
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      product.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                              Icons.broken_image,
                                              size: 50,
                                              color: Colors.grey),
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                            child: CircularProgressIndicator());
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      product.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(
                                  product.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: product.isLiked
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    product.isLiked = !product
                                        .isLiked; // Toggle like for the individual product

                                    if (product.isLiked) {
                                      _likedProducts.add(
                                          product); // Add to liked products
                                    } else {
                                      _likedProducts.removeWhere((p) =>
                                          p.id ==
                                          product.id); // Remove if unliked
                                    }

                                    _isLiked = product
                                        .isLiked; // Update global-like state
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
