import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'orders_database.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE orders(id TEXT PRIMARY KEY, status TEXT, datetime TEXT, image TEXT, name TEXT, price TEXT)');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE orders ADD COLUMN name TEXT');
        }
      },
    );
  }

  Future<void> saveOrder(Order order) async {
    final db = await database;
    await db.insert(
      'orders',
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Order>> getOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('orders');
    return maps.map((map) => Order.fromMap(map)).toList();
  }

  Future<void> deleteOrder(String id) async {
    final db = await database;
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateOrderStatus(String id, String status) async {
    final db = await database;
    await db.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Order {
  final String id;
  final String status;
  final DateTime datetime;
  final String image;
  final String name;
  final double price;

  Order({
    required this.id,
    required this.status,
    required this.datetime,
    required this.image,
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'datetime': datetime.toIso8601String(),
      'image': image,
      'name': name,
      'price': price.toString(),
    };
  }

  static Order fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      status: map['status'],
      datetime: DateTime.parse(map['datetime']),
      image: map['image'],
      name: map['name'],
      price: double.parse(map['price']),
    );
  }

  Order copyWith({
    String? id,
    String? status,
    DateTime? datetime,
    String? image,
    String? name,
    double? price,
  }) {
    return Order(
      id: id ?? this.id,
      status: status ?? this.status,
      datetime: datetime ?? this.datetime,
      image: image ?? this.image,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }
}
