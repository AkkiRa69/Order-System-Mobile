class OrderModel {
  DateTime date;
  int orderNo, itemCount;
  double itemPrice;

  OrderModel(
      {required this.date,
      required this.orderNo,
      required this.itemCount,
      required this.itemPrice});
}
