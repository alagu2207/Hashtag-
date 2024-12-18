import 'package:flutter/material.dart';
import 'package:flutter_application_1/model.dart';

// In detailedproducts.dart

class detailedproducts extends StatefulWidget {
  final Product product;

  const detailedproducts({super.key, required this.product});

  @override
  State<detailedproducts> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<detailedproducts> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        " ${widget.product.id}. ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        widget.product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Description:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "  ${widget.product.description}",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "Created At:",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " ${widget.product.createdAt}",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "Updated At:",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " ${widget.product.updatedAt}",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(size: 30, Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
    ;
  }
}
