class OfflineApi {
  final cartegory = [
    {
      "name": "Phone",
      "imgurl": "assets/images/food_cupcake.jpg",
    },
    {
      "name": "Automobile",
      "imgurl": "assets/images/food_cupcake.jpg",
    },
    {
      "name": "Homes",
      "imgurl": "assets/images/food_cupcake.jpg",
    },
    {
      "name": "Electronics",
      "imgurl": "assets/images/food_cupcake.jpg",
    },
    {
      "name": "Beauty",
      "imgurl": "assets/images/food_cupcake.jpg",
    },
    {
      "name": "Food",
      "imgurl": "assets/images/food_cupcake.jpg",
    }
  ];

  Future<List> getCartegory() async {
    return cartegory;
  }

  final productgroup = [
    {
      "title": "Trending sales",
      "product": [
        {
          "id": 0,
          "name": "Minimal chair",
          "price": 2200,
          "productImage": "assets/images/food_cupcake.jpg",
          "rating": 4.5,
          "sold": false,
        },
        {
          "id": 2,
          "name": "Minimal chair",
          "price": 2200,
          "productImage": "assets/images/food_cupcake.jpg",
          "rating": 4.5,
          "sold": false,
        }
      ]
    },
    {
      "title": "Best selling",
      "product": [
        {
          "id": 0,
          "name": "Minimal chair",
          "price": 2200,
          "productImage": "assets/images/food_cupcake.jpg",
          "rating": 4.5,
          "sold": false,
        },
        {
          "id": 2,
          "name": "Minimal chair",
          "price": 2200,
          "productImage": "assets/images/food_cupcake.jpg",
          "rating": 4.5,
          "sold": false,
        }
      ]
    },
    {
      "title": "Top rated",
      "product": [
        {
          "id": 0,
          "name": "Minimal chair",
          "price": 2200,
          "productImage": "assets/images/food_cupcake.jpg",
          "rating": 4.5,
          "sold": false,
        },
        {
          "id": 2,
          "name": "Minimal chair",
          "price": 2200,
          "productImage": "assets/images/food_cupcake.jpg",
          "rating": 4.5,
          "sold": false,
        }
      ]
    }
  ];
  Future<List> getproductgroup() async {
    return productgroup;
  }
}
