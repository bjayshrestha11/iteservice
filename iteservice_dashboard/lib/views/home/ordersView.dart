import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iteservice_dashboard/config/pallete.dart';
import 'package:iteservice_dashboard/controllers/controllers.dart';
import 'package:iteservice_dashboard/models/models.dart';
import 'package:iteservice_dashboard/utilities/utils.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<OrderController>(
        builder: (controller) {
          if (controller.orderList.length == 0) {
            return Center(
              child: Text("No order now"),
            );
          }
          return ListView.builder(
            itemCount: controller.orderList.length,
            itemBuilder: (_, i) {
              Order order = controller.orderList[i];
              return OrderListTile(order: order);
            },
          );
        },
      ),
    );
  }
}

class OrderListTile extends StatelessWidget {
  const OrderListTile({Key? key, required this.order}) : super(key: key);
  final Order order;

  getUpdatedOrder(String status) {
    return Order(
      id: order.id,
      orderDate: order.orderDate,
      orderState: status,
      orderedItems: order.orderedItems,
      totalAmount: order.totalAmount,
      userId: order.userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetBuilder<OrderController>(
        builder: (controller) {
          return Slidable(
            key: key,
            actionPane: SlidableStrechActionPane(),
            secondaryActions: [
              IconSlideAction(
                caption: 'Processing',
                color: Pallete.getOrderColor("Processing"),
                icon: Pallete.getOrderIcon("Processing"),
                onTap: () async{
                  Order upOrder = getUpdatedOrder("Processing");
                  await Get.find<OrderController>().changeOrderStatus(upOrder);
                },
              ),
              IconSlideAction(
                caption: 'Cancel',
                color: Pallete.getOrderColor("Cancelled"),
                icon: Pallete.getOrderIcon("Cancelled"),
                onTap: () async {
                   Order upOrder = getUpdatedOrder("Cancelled");
                  await Get.find<OrderController>().changeOrderStatus(upOrder);
                },
              ),
            ],
            actions: [
              IconSlideAction(
                caption: 'Completed',
                color: Pallete.getOrderColor("Completed"),
                icon: Pallete.getOrderIcon("Completed"),
                onTap: ()  async {
                  Order upOrder = getUpdatedOrder("Completed");
                  await Get.find<OrderController>().changeOrderStatus(upOrder);
                },
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.black,
                icon: Icons.delete,
                onTap: () async {
                  if (order.orderState == "Completed" ||
                      order.orderState == "Cancelled") {
                    await Get.find<OrderController>().deleteOrder(order);
                  } else {
                    Utils.showSnackBar("Sorry",
                        "Only completed or cancelled order can be deleted");
                  }
                },
              ),
            ],
            child: ListTile(
              onTap: () {
                Get.defaultDialog(
                  title: "#${order.id!}",
                  backgroundColor: Pallete.getOrderColor(order.orderState),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),
                        child: Text(
                          "Order By - ${order.userId}",
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),
                        child: Text(
                          "Total Amount - \$${order.totalAmount.toStringAsFixed(2)}",
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),
                        child: Text(
                          "Status - ${order.orderState}",
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),
                        child: Text(
                          "Order Items",
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),
                        child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: order.orderedItems.map(
                            (orderItem) {
                              return Container(
                                width: 100,
                                height: 100,
                                padding:
                                    EdgeInsets.only(left: 5, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    orderItem.imageUrl,
                                  ),
                                )),
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    "${orderItem.name}",
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),
                        child: Text(
                          "Order Date - ${Utils.getDate(order.orderDate)}",
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundColor: Pallete.getOrderColor(order.orderState),
                child: Icon(
                  Pallete.getOrderIcon(order.orderState),
                  color: Colors.white,
                ),
              ),
              title: Text("#${order.id}"),
              subtitle: Text(
                  "Order by: ${order.userId} \nTotal amount is \$${order.totalAmount.toStringAsFixed(2)}"),
            ),
          );
        },
      ),
    );
  }
}
