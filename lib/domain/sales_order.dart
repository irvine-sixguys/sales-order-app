class SalesOrderItem {
  final String itemCode;
  final String deliveryDate;
  final double qty;
  final double rate;

  SalesOrderItem({
    required this.itemCode,
    required this.deliveryDate,
    required this.qty,
    required this.rate,
  });

  Map<String, dynamic> toJson() {
    return {
      "item_code": itemCode,
      "delivery_date": deliveryDate,
      "qty": qty,
      "rate": rate,
    };
  }
}

class SalesOrder {
  final String customer;
  final String transactionDate;
  final String currency;
  final String sellingPriceList;
  final List<SalesOrderItem> items;

  SalesOrder({
    required this.customer,
    required this.transactionDate,
    required this.currency,
    required this.sellingPriceList,
    required this.items,
  });

  factory SalesOrder.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    // print(data);

    return SalesOrder(
      customer: data["customer"] ?? "",
      transactionDate: data["transaction_date"] ?? "",
      currency: data["currency"] ?? "USD",
      sellingPriceList: data["selling_price_list"] ?? "Standard Selling",
      items: (data["items"] as List)
          .map((e) => SalesOrderItem(
                itemCode: e["item_code"] ?? "",
                deliveryDate: e["delivery_date"] ?? "",
                qty: double.tryParse(e["qty"].toString()) ?? 0.0,
                rate: double.tryParse(e["rate"].toString()) ?? 0.0,
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": {
        "customer": customer,
        "transaction_date": transactionDate,
        "currency": currency,
        "selling_price_list": sellingPriceList,
        "items": items.map((e) => e.toJson()).toList(),
      }
    };
  }
}
