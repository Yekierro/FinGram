import 'package:fingram/shop/product.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Product> products = [];
  int userCoins = 0;

  @override
  void initState() {
    super.initState();
    loadUserCoins();
    initLoad();
    loadPurchases();
  }

  Future<void> initLoad() async {
    await loadProducts();
  }

  Future<void> loadProducts() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('products');
    DataSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      List<Product> loadedProducts = [];
      for (var child in snapshot.children) {
        Map<String, dynamic> productData =
            Map<String, dynamic>.from(child.value as Map);
        loadedProducts.add(Product.fromMap(productData, child.key!));
      }
      setState(() {
        products = loadedProducts;
      });
    }
  }

  void loadUserCoins() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference coinsRef =
        FirebaseDatabase.instance.ref('users/$userId/coins');
    DataSnapshot snapshot = await coinsRef.get();
    if (snapshot.exists) {
      setState(() {
        userCoins = int.parse(snapshot.value.toString());
      });
    }
  }

  void loadPurchases() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference purchasesRef =
        FirebaseDatabase.instance.ref('users/$userId/purchases');
    DataSnapshot snapshot = await purchasesRef.get();

    if (snapshot.exists && snapshot.value != null) {
      Map<String, bool> purchases = {};
      var data = snapshot.value;

      if (data is Map) {
        purchases = Map<String, bool>.from(data);
      } else if (data is List) {
        data.asMap().forEach((index, value) {
          if (value is Map) {
            purchases[value['key'].toString()] = value['isPurchased'] as bool;
          }
        });
      }

      setState(() {
        for (var product in products) {
          product.isPurchased = purchases[product.id] ?? false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Магазин"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.yellow),
                const SizedBox(width: 5),
                Text('$userCoins', style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: Image.asset(product.imageUrl),
            title: Text(product.name),
            subtitle: Text('${product.price} монет'),
            trailing: ElevatedButton(
              onPressed: product.isPurchased
                  ? () => applyProduct(product)
                  : () => buyProduct(product),
              child: Text(product.isPurchased ? 'Применить' : 'Купить'),
            ),
          );
        },
      ),
    );
  }

  void buyProduct(Product product) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference userCoinsRef =
        FirebaseDatabase.instance.ref('users/$userId/coins');
    DatabaseReference productRef =
        FirebaseDatabase.instance.ref('users/$userId/purchases/${product.id}');

    final snapshot = await userCoinsRef.get();
    int currentCoins = snapshot.exists && snapshot.value != null
        ? int.parse(snapshot.value.toString())
        : 0;

    if (currentCoins >= product.price) {
      int newCoinTotal = currentCoins - product.price;
      await userCoinsRef.set(newCoinTotal);
      await productRef.set(true);
      setState(() {
        userCoins = newCoinTotal;
        product.isPurchased = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не хватает монет для покупки')));
    }
  }

  void applyProduct(Product product) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseDatabase.instance
        .ref('users/$userId/selectedBasket')
        .set(product.imageUrl);
  }
}
