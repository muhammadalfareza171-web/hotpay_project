import 'menu_item.dart';

enum OrderStatus {
  pendingPayment,
  cooking,
  ready,
  completed,
  cancelled,
}

class OrderItem {
  final MenuItem item;
  final int quantity;
  final String notes;

  const OrderItem({
    required this.item,
    this.quantity = 1,
    this.notes = 'Pedas Sedang • Telur',
  });

  int get totalPrice => item.price * quantity;
}

class OrderModel {
  final String orderId;
  final List<OrderItem> items;
  final int totalAmount;
  final String orderTime;
  final String kioskName;
  final String kioskLocation;
  final String dispenserSlot;
  final String paymentMethod;
  final String rrnTid;
  final OrderStatus status;

  const OrderModel({
    required this.orderId,
    required this.items,
    required this.totalAmount,
    required this.orderTime,
    this.kioskName = 'Kios VM-01',
    this.kioskLocation = 'PT Jaya Abadi Mukakuning',
    this.dispenserSlot = 'Bay A-02',
    this.paymentMethod = 'QRIS Dinamis',
    this.rrnTid = '000182746194 / SB-NT-01',
    this.status = OrderStatus.completed,
  });

  static OrderModel get sampleOrder => OrderModel(
    orderId: '#SB-98284',
    items: [
      OrderItem(
        item: MenuItem.sampleMenuItems[2], // Mie Sagu
        quantity: 1,
        notes: 'Pedas Sedang • Telur',
      ),
    ],
    totalAmount: 18000,
    orderTime: '24 Okt 2024, 12:30:15 WIB',
    kioskName: 'Kios VM-01 (Bay A-02)',
    kioskLocation: 'PT Jaya Abadi Mukakuning',
    dispenserSlot: 'Bay A-02',
    paymentMethod: 'QRIS Dinamis',
    rrnTid: '000182746194 / SB-NT-01',
    status: OrderStatus.completed,
  );

  static List<OrderModel> get sampleHistory => [
    OrderModel(
      orderId: '#SB-98284',
      items: [
        OrderItem(
          item: MenuItem.sampleMenuItems[2], // Mie Sagu
          quantity: 1,
        ),
      ],
      totalAmount: 18000,
      orderTime: 'Hari ini, 12:30 WIB',
      kioskName: 'Kios VM-01',
      kioskLocation: 'PT Jaya Abadi Mukakuning',
      dispenserSlot: 'Bay A-02',
      status: OrderStatus.completed,
    ),
    OrderModel(
      orderId: '#SB-98120',
      items: [
        OrderItem(
          item: MenuItem.sampleMenuItems[0], // Mie Tarempa Seafood
          quantity: 1,
        ),
      ],
      totalAmount: 28000,
      orderTime: 'Kemarin, 19:15 WIB',
      kioskName: 'Kios VM-01',
      kioskLocation: 'PT Jaya Abadi Mukakuning',
      dispenserSlot: 'Bay A-01',
      status: OrderStatus.completed,
    ),
    OrderModel(
      orderId: '#SB-97992',
      items: [
        OrderItem(
          item: MenuItem.sampleMenuItems[4], // Luti Gendang Ayam
          quantity: 1,
        ),
      ],
      totalAmount: 10000,
      orderTime: '22 Okt 2024, 14:02 WIB',
      kioskName: 'Kios VM-01',
      kioskLocation: 'PT Jaya Abadi Mukakuning',
      dispenserSlot: 'Bay B-01',
      status: OrderStatus.completed,
    ),
  ];
}
