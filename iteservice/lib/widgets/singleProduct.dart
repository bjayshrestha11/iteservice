import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iteservice/config/pallete.dart';
import 'package:iteservice/controllers/controllers.dart';
import 'package:iteservice/models/models.dart';

class SingleProductController extends GetxController {
  var plan = "Basic".obs;

  Rx<List<String>> items = Rx<List<String>>(["Basic", "Standard", "Premium"]);

  void setPlan(String val) {
    plan.value = val;
    update();
  }
}

class SingleProduct extends StatelessWidget {
  final Product product;

  SingleProduct({Key? key, required this.product}) : super(key: key);

  final SingleProductController controller = Get.put(SingleProductController());
  final CurrencyController currController = Get.find<CurrencyController>();

  double getPrice(String plan) {
    switch (plan) {
      case "Basic":
        return product.price.basic;
      case "Standard":
        return product.price.standard;
      case "Premium":
        return product.price.premium;
      default:
        return product.price.basic;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.cyan100,
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          GetX<CartController>(builder: (controller) {
            return IconButton(
              onPressed: () {
                Get.find<NavController>().onPageChange(1);
                Get.back();
              },
              icon: Badge(
                child: Icon(Icons.shopping_cart),
                badgeContent: Text("${controller.cartItemList.length}"),
                badgeColor: Pallete.cyan100,
              ),
            );
          }),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            width: Get.width,
            height: Get.height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(product.imageUrl),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fill),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: Text("${product.title}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: Obx(
                  () {
                    var symbol = currController.currSymbol.value;
                    var price = currController.rate.value * getPrice(controller.plan.value);
                    return Text(
                      "$symbol${price.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30.0,
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text(
                  "Description",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                child: Text(
                  "${product.description}",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Package:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GetX<SingleProductController>(
                        builder: (controller) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Pallete.primaryCol, width: 1),
                                borderRadius: BorderRadius.circular(15)),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: controller.plan.value,
                              underline: SizedBox(),
                              onChanged: (val) {
                                controller.setPlan(val!);
                              },
                              items: controller.items.value
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 15.0, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Pallete.primaryCol,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              bottomLeft: Radius.circular(40)),
                        ),
                      ),
                      onPressed: () async {
                        await Get.find<CartController>().addToCart(
                            product,
                            getPrice(controller.plan.value),
                            1,
                            controller.plan.value);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 32.0),
                        child: Text("Add to cart"),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
