import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieboxclone/Commerce/components/product_component.dart';
import 'package:movieboxclone/Commerce/constants/app_constants.dart';
import 'package:movieboxclone/Commerce/models.dart/cartegory.dart';
import 'package:movieboxclone/Commerce/models.dart/product.dart';
import 'package:movieboxclone/Commerce/offline_Api/offline_api.dart';

import '../components/category_component.dart';
import '../models.dart/productgroup.dart';

class CommerceDashboard extends StatelessWidget {
  const CommerceDashboard({super.key});

  Future<List> _fetchCategories() async {
    final OfflineApi offlineApi = OfflineApi();
    final response = await offlineApi.getCartegory();

    return response;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: _fetchCategories(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List cartegory = snapshot.data ?? [];
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  titleTextStyle: const TextStyle(color: Colors.white),
                  backgroundColor: Colors.purple[800],

                  // bottom: TabBar(
                  //   isScrollable: true,
                  //   tabs: cartegory
                  //       .map((category) => Tab(
                  //             child: CategoryComponent(
                  //               imgUrl: category["imgurl"],
                  //               cartName: category["name"],
                  //               isonline: false,
                  //             ),
                  //           ))
                  //       .toList(),
                  // ),
                  actions: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.search)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_cart)),
                  ],
                  centerTitle: true,
                  title: const Text(
                    "Commerce",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // TODO: Remove navigator and inkwell
                  leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(whiteIcon),
                    ),
                  ),
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Divider(height: 2, color: Colors.white),
                    Container(
                      height: 100,
                      color: Colors.purple[800],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: cartegory
                            .map((category) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CategoryComponent(
                                    imgUrl: category["imgurl"],
                                    cartName: category["name"],
                                    isonline: false,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: TabBar(
                        padding: EdgeInsets.zero,
                        tabs: [
                          Container(
                            width: size.width * .5,
                            padding: EdgeInsets.zero,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8.0)),
                              color: Colors.yellow,
                            ),
                            child: const Text("Top Products"),
                          ),
                          Container(
                            width: size.width * .5,
                            padding: EdgeInsets.zero,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(8.0)),
                              color: Colors.grey,
                            ),
                            child: const Text("Top Products"),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: TabBarView(children: [
                      const TopProducts(),
                      Container(
                        color: Colors.white,
                        child: const Text("Top Products"),
                      )
                    ])),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class TopProducts extends StatelessWidget {
  const TopProducts({super.key});

  Future<List<Productgroup>> _fetchProductGroup() async {
    final OfflineApi offlineApi = OfflineApi();
    final productgroup = await offlineApi.getproductgroup();
    // print(productgroup);
    print(productgroup.length);
    final List<Productgroup> productgrouplist = List.generate(
        productgroup.length,
        (int index) => Productgroup.fromMap(productgroup[index]));

    print(productgrouplist.length);

    return productgrouplist;
  }

  @override
  Widget build(BuildContext context) {
    const Color color = Colors.black;
    return FutureBuilder(
        future: _fetchProductGroup(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<Productgroup> productgroup = snapshot.data ?? [];
            // productgroup.map((product)=>)
            return ListView(
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          const Text(
                            "Business Directory",
                            style: TextStyle(
                                color: color, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Explore our comprehsive business directory that contains all business around the world",
                            style: TextStyle(
                              color: color,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Explore now",
                                // style: TextStyle(color: Colors.blue),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                // ...List.generate(
                //   productgroup.length,
                //   (int index) => ProductGroupView(
                //     title: productgroup[index].title,
                //     product: List.generate(
                //       2,
                //       (int index) => productgroup[index].product,
                //     ),
                //   ),
                // )

                ProductGroupView(title: "Trending user", product: [
                  Product(
                    name: "Thyroid",
                    price: 2200,
                    productImage: "assets/images/food_cupcake.jpg",
                    rating: 4.5,
                  ),
                  Product(
                    name: "Thyroid",
                    price: 2200,
                    productImage: "assets/images/food_cupcake.jpg",
                    rating: 4.5,
                  )
                ]),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class ProductGroupView extends StatelessWidget {
  const ProductGroupView(
      {super.key, required this.title, required this.product});

  final String title;
  // First 2
  final List<Product> product;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title),
                const SizedBox(
                  width: 180,
                ),
                const Text("View all"),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProductComponent(
                imgUrl: product[0].productImage,
                productname: "Minimal chair",
                rating: "${product[0].rating}",
                price: product[0].price,
              ),
              const SizedBox(
                width: 20,
              ),
              ProductComponent(
                imgUrl: product[1].productImage,
                productname: "Minmal chair",
                rating: "${product[1].rating}",
                price: product[0].price,
              ),
            ],
          )
        ],
      ),
    );
  }
}
