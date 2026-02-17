import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// DATA_MODEL
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class SkateShopData extends ChangeNotifier {
  final List<Product> _allProducts;
  String? _selectedSortOption;
  int _cartItemCount;
  final List<String> _sortOptions = ['Price', 'Name', 'Newest'];

  SkateShopData()
      : _allProducts = [
          Product(
            id: '1',
            name: "SANTA CRUZ SKATE",
            price: 65.50,
            imageUrl:
                'https://raw.githubusercontent.com/Alex-Villagrana/imagenes_act10/refs/heads/main/skate1.jpg',
          ),
          Product(
            id: '2',
            name: "ELEMENT SKATEBOARD",
            price: 75.00,
            imageUrl:
                'https://raw.githubusercontent.com/Alex-Villagrana/imagenes_act10/refs/heads/main/skate2.webp',
          ),
          Product(
            id: '3',
            name: "PLAN B SKATEBOARD",
            price: 60.99,
            imageUrl:
                'https://raw.githubusercontent.com/Alex-Villagrana/imagenes_act10/refs/heads/main/skate3.webp',
          ),
        ],
        _selectedSortOption = 'Name',
        _cartItemCount = 0;

  List<Product> get products {
    List<Product> sortedProducts = List<Product>.from(_allProducts);
    if (_selectedSortOption == 'Price') {
      sortedProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSortOption == 'Name') {
      sortedProducts.sort((a, b) => a.name.compareTo(b.name));
    }
    // For 'Newest', we'll just keep the default order for simplicity
    return sortedProducts;
  }

  List<String> get sortOptions => _sortOptions;
  String? get selectedSortOption => _selectedSortOption;
  int get cartItemCount => _cartItemCount;

  void updateSortOption(String? newValue) {
    if (newValue != null && newValue != _selectedSortOption) {
      _selectedSortOption = newValue;
      notifyListeners();
    }
  }

  void addToCart() {
    _cartItemCount++;
    notifyListeners();
  }
}

void main() => runApp(const AppSkateshop());

class AppSkateshop extends StatelessWidget {
  const AppSkateshop({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SkateShopData>(
      create: (context) => SkateShopData(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const SkateShopHomePage(),
        );
      },
    );
  }
}

class SkateShopHomePage extends StatelessWidget {
  const SkateShopHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SkateShopAppBar(),
      drawer: const SkateShopDrawer(),
      body: const ProductListScreen(),
    );
  }
}

class SkateShopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SkateShopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Column(
        children: [
          Text("ZON", style: TextStyle(fontSize: 14, color: Colors.white)),
          Text("SKATE SHOP", style: TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF800000),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        Consumer<SkateShopData>(
          builder: (context, skateShopData, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 30),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      skateShopData.cartItemCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SkateShopDrawer extends StatelessWidget {
  const SkateShopDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Remove default padding
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF800000)),
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Implement navigation if needed
            },
          ),
          ListTile(
            leading: const Icon(Icons.skateboarding),
            title: const Text("Skateboards"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Implement navigation if needed
            },
          ),
        ],
      ),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "SKATEBOARDS",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const Text(
              "Home / Skateboards",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            const SortDropdown(),
            const SizedBox(height: 30),
            Consumer<SkateShopData>(
              builder: (context, skateShopData, child) {
                return Column(
                  children: skateShopData.products
                      .map<Widget>((product) => Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: ProductCard(product: product),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SortDropdown extends StatelessWidget {
  const SortDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Consumer<SkateShopData>(
        builder: (context, skateShopData, child) {
          return DropdownButton<String>(
            value: skateShopData.selectedSortOption,
            hint: const Text("Sort By"),
            isExpanded: true,
            underline: const SizedBox(),
            items: skateShopData.sortOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              skateShopData.updateSortOption(newValue);
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: <Widget>[
          Image.network(
            product.imageUrl,
            height: 250,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 250, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // Access SkateShopData to add to cart
                    Provider.of<SkateShopData>(context, listen: false).addToCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} added to cart!')),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text("Add to Cart"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF800000),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}