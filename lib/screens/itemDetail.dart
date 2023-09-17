import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanvi/datamodel/ProductM.dart';
import 'package:tanvi/extention/StringExtention.dart';
import 'package:tanvi/util/app_const.dart';
import 'package:tanvi/widgets/cart/CartM.dart';
import 'package:tanvi/widgets/cart/cart_add_button_widget.dart';
import 'package:tanvi/widgets/cart/cart_widget.dart';
import 'package:tanvi/widgets/variant_widget.dart';
import '../util/curvedAppBar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../model/addToCart/addToCart.dart';
import 'dart:convert';
import '../model/wishList/wishList.dart';
import '../model/addToCart/addToCart.dart';
import '../model/products/productsProvider.dart';
import '../model/rating/ratingProvider.dart';

class ItemDetails extends StatefulWidget {
  ItemDetailsState createState() => ItemDetailsState();
}

class ItemDetailsState extends State<ItemDetails> {
  double rating = 0;
  int counter = 0;
  double itemPrice = 0.0;
  bool isClicked = false;
  bool isLoading = true;

  ProductM? productM;

  AddToCartProvider? cartProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    Provider.of<AddToCartProvider>(context, listen: false)
        .getCartProducts()
        .then((_) {
      Provider.of<ProductsProvider>(context, listen: false)
          .getProducts()
          .then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
    super.didChangeDependencies();
  }
  CartM? cartM;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final route = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      productM = route['itemModel'] as ProductM;
    });
    cartProvider = Provider.of<AddToCartProvider>(context, listen: false);

  }

  @override
  Widget build(BuildContext context) {
    if(productM!=null){
      cartM  = cartProvider!.isCartHasThisProduct(
          productM!.getSelectedQuantity);
    }

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final tabLayout = width > 600;
    final largeLayout = width > 350 && width < 600;
    // final textScaleFactor = MediaQuery.of(context).textScaleFactor * 1.2;
    final route =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final id = route['id'];
    final wishListId = route['wishListId'];
    final image = route['image'];
    final name = route['name'];
    // var quantity = route['quantity'];
    final description = route['description'];
    final price = route['price'];
    int quantity = route['quantity']??0;

    final provider = Provider.of<AddToCartProvider>(context).cartData;
    final productsProvider = Provider.of<ProductsProvider>(context).products;
    int length = 0;

    setState(() {
      counter = quantity;
      length = Provider.of<AddToCartProvider>(context)
          .cartData['data']['cartItem']
          .length;
      itemPrice = price??0 * counter.toDouble();
      print('Item Price: $itemPrice');
      print('Counter $counter');
      print('Length $length');
    });

    // counter = quantity;

    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: CartWidget(
                index: 1,
                ontap: (){},
              ),
            ),
            IconButton(onPressed: (){
              if(GetStorage().read(AppConst.keyIsSkippedLogin)==true){
                Navigator.of(context).pushNamed('/sign-in');
                return;
              }
              setState(() {
                isClicked = !isClicked;
              });
              Provider.of<WishListProvider>(context,
                  listen: false)
                  .wishListAdd(id);
            }, icon: !isClicked
                ? Icon(Icons.favorite_outline,
                size: tabLayout ? 40 : 20)
                : Icon(Icons.favorite,
                color: Colors.pink,
                size: tabLayout ? 40 : 20))
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              )
            : Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Rectangle 392.png'),
                        fit: BoxFit.cover)),
                child: Column(
                  children: [
                    SizedBox(height: 12,),
                    CircleAvatar(
                      radius: 100.0,
                      backgroundImage:
                      NetworkImage('${AppConst.baseUrl}$image'),
                      backgroundColor: Colors.transparent,
                      ),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: Text(name,
                                // textScaleFactor: textScaleFactor,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: tabLayout
                                        ? 40
                                        : largeLayout
                                            ? 25
                                            : 20)),
                          ),
                          SizedBox(height: 8,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width * 0.4,
                                // color: Colors.green,
                                child: Row(
                                  children: [
                                    RatingBar.builder(
                                      allowHalfRating: true,
                                      minRating: 1,
                                      itemSize: tabLayout
                                          ? 35
                                          : largeLayout
                                              ? 24
                                              : 18,
                                      // itemPadding: EdgeInsets.symmetric(
                                      //     horizontal: 0.05, vertical: 0.05),
                                      itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.yellow),
                                      onRatingUpdate: (double value) async {
                                        setState(() {
                                          rating = value;
                                        });
                                        var res =
                                            await Provider.of<RatingProvider>(
                                                    context,
                                                    listen: false)
                                                .postRating(id.toString(),
                                                    value.toString());
                                        if (res['error'] == false) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content: Text(
                                                    res['message'],
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  action: SnackBarAction(
                                                      label: 'OK',
                                                      textColor: Colors.white,
                                                      onPressed: () =>
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .hideCurrentSnackBar())));
                                        }
                                      },
                                    ),
                                    Text('($rating)',
                                        // textScaleFactor: textScaleFactor,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: tabLayout ? 25 : 14)),
                                    // Container(
                                    //     width: width * 0.4,
                                    //     height: height * 0.1,
                                    //     color: Colors.amber)
                                  ],
                                ),
                              ),
                              VariantWidget(item: productM!,onTap: (){
                                setState(() {

                                });
                              },),
                             /* Container(
                                width: width * 0.45,
                                height: !tabLayout && !largeLayout
                                    ? height * 0.05
                                    : height * 0.06,
                                // color: Colors.amber,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if(GetStorage().read(AppConst.keyIsSkippedLogin)==true){
                                          Navigator.of(context).pushNamed('/sign-in');
                                          return;
                                        }
                                        setState(() {
                                          if (route['quantity'] != 0) {
                                            // route['quantity']--;
                                            itemPrice =
                                                price * --route['quantity'];
                                          } else {
                                            route['quantity'] = 0;
                                          }
                                          print(route['quantity']);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 10,
                                                  offset: Offset(0, 1))
                                            ]),
                                        child: CircleAvatar(
                                          radius: tabLayout
                                              ? 28
                                              : largeLayout
                                                  ? 18
                                                  : 16,
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.remove_sharp,
                                              color: Colors.black,
                                              size: tabLayout
                                                  ? 40
                                                  : largeLayout
                                                      ? 30
                                                      : 25),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width * 0.04),
                                    Text(counter.toString(),
                                        // textScaleFactor: textScaleFactor,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: tabLayout
                                                ? 40
                                                : largeLayout
                                                    ? 22
                                                    : 18)),
                                    SizedBox(width: width * 0.04),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if(GetStorage().read(AppConst.keyIsSkippedLogin)==true){
                                            Navigator.of(context).pushNamed('/sign-in');
                                            return;
                                          }
                                          itemPrice = price * ++route['quantity'];
                                          print(route['quantity']);
                                        });
                                      },
                                      child: Container(

                                        decoration: BoxDecoration(

                                            borderRadius:
                                                BorderRadius.circular(18),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 10,
                                                  offset: Offset(0, 1))
                                            ]),
                                        child: CircleAvatar(
                                          radius: tabLayout
                                              ? 28
                                              : largeLayout
                                                  ? 18
                                                  : 16,
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.add,
                                              color: Colors.black,
                                              size: tabLayout
                                                  ? 40
                                                  : largeLayout
                                                      ? 30
                                                      : 18),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )*/
                            ],
                          ),
                          SizedBox(height: 8,),

                          Container(
                            width: double.infinity,
                            height: height * 0.178,
                            // color: Colors.blue,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Description',
                                    // textScaleFactor: textScaleFactor,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: tabLayout
                                            ? 30
                                            : largeLayout
                                                ? 18
                                                : 16)),
                                SizedBox(height: height * 0.005),
                                Expanded(
                                  child: Text(description.toString().removeTags,
                                      // textScaleFactor: textScaleFactor,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: tabLayout
                                              ? 25
                                              : largeLayout
                                                  ? 13
                                                  : 11)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Offers On',
                              // textScaleFactor: textScaleFactor,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: tabLayout
                                      ? 30
                                      : largeLayout
                                          ? 18
                                          : 14)),
                          SizedBox(height: height * 0.02),
                          Container(
                            width: double.infinity,
                            height: tabLayout ? height * 0.15 : height * 0.14,
                            // color: Colors.amber,
                            padding: EdgeInsets.only(left: width * 0.02),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/item-details', arguments: {
                                    'id': productsProvider['data'][index]['id'],
                                    'image': productsProvider['data'][index]
                                        ['main_image'],
                                    'name': productsProvider['data'][index]
                                        ['name'],
                                    'quantity': 0,
                                    'description': productsProvider['data'][index]
                                        ['description'],
                                    'price': productsProvider['data'][index]
                                        ['price']
                                  });
                                  // print(
                                  //     'Quantity Print ${_categoryItems[index]['quantity']}');
                                },
                                child: Container(
                                  width: width * 0.25,
                                  height: height * 0.1,
                                  // color: Colors.white,
                                  margin: EdgeInsets.only(right: width * 0.01),
                                  child: Column(
                                    children: [
                                      Container(
                                        // padding: EdgeInsets.symmetric(
                                        //     vertical: height * 0.02,
                                        //     horizontal: width * 0.04),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                !tabLayout && !largeLayout
                                                    ? 10
                                                    : 20),
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 2))
                                            ]),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              !tabLayout && !largeLayout
                                                  ? 10
                                                  : 20),
                                          child: Image.network(
                                              '${AppConst.baseUrl}${productsProvider['data'][index]['main_image']}',
                                              height: tabLayout
                                                  ? height * 0.12
                                                  : height * 0.1,
                                              width: tabLayout
                                                  ? width * 0.18
                                                  : largeLayout
                                                      ? height * 0.1
                                                      : height * 0.13),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.01),
                                      FittedBox(
                                        fit: BoxFit.fill,
                                        child: Text(
                                            productsProvider['data'][index]
                                                ['name'],
                                            // textScaleFactor: textScaleFactor,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: tabLayout
                                                    ? 20
                                                    : largeLayout
                                                        ? 14
                                                        : 12)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              itemCount: productsProvider['data']?.length??0,
                              // itemCount: productsProvider['count'],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.027),
                    Container(
                      width: double.infinity,
                      height: height * 0.1,
                      color: Colors.white,
                      padding: EdgeInsets.only(
                          left: width * 0.02, right: width * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price',
                              // textScaleFactor: textScaleFactor,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: tabLayout
                                      ? 45
                                      : largeLayout
                                          ? 20
                                          : 12)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text(
                              //   '₹',
                              //   // textScaleFactor: textScaleFactor,
                              //   style: TextStyle(
                              //       color: Colors.black,
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: 40),
                              // ),
                              Text(
                                // '₹${price.toString()}',
                                '₹${productM?.getSelectedQuantity.price}',
                                // textScaleFactor: textScaleFactor,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: tabLayout
                                        ? 45
                                        : largeLayout
                                            ? 40
                                            : 32),
                              ),
                              CartAddButtonWidget(
                                cartM: cartM,
                                productM: productM!,
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  void cartAdd(int productId, int quantity, BuildContext context,
      Map<String, dynamic> provider) async {
    final response =
        await Provider.of<AddToCartProvider>(context, listen: false)
            .postToCart(productId: productId, quantity: quantity);
    final res = json.decode(response.body);

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setInt('cartLength', provider['data']['cartItem'].length);

    print(res);
    if (res['data']['message'] == 'Product added to cart.') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Product Added To Cart',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        action: SnackBarAction(
            textColor: Colors.white,
            label: 'OK',
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar()),
      ));
    }
    if (res['data']['message'] == 'Product available in cart.') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Product Already Available In Cart',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            textColor: Colors.white,
            label: 'OK',
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          )));
    }
  }
}
