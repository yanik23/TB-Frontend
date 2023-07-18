import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;
  static const String databaseName = 'TB.db';

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initializeDatabase();
    return _database!;
  }

  static Future<Database> initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = '$databasesPath/$databaseName';
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      // Create the tables
      await db.execute('''
        CREATE TABLE IF NOT EXISTS Client (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          status TEXT NOT NULL,
          remoteId INTEGER,
          name TEXT NOT NULL UNIQUE,
          addressName TEXT NOT NULL,
          addressNumber INTEGER NOT NULL,
          zipCode INTEGER NOT NULL,
          city TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS "user" (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          status TEXT NOT NULL,
          remoteId INTEGER,
          email TEXT NOT NULL,
          password TEXT NOT NULL,
          name TEXT NOT NULL,
          currentRole TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS Delivery (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          status TEXT NOT NULL,
          remoteId INTEGER,
          idClient INTEGER,
          idUser INTEGER,
          deliveryDate TEXT NOT NULL,
          details TEXT,
          FOREIGN KEY (idClient) REFERENCES Client (id) ON DELETE CASCADE ON UPDATE CASCADE,
          FOREIGN KEY (idUser) REFERENCES "user" (id) ON DELETE CASCADE ON UPDATE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS Dish (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          status TEXT NOT NULL,
          remoteId INTEGER,
          name TEXT NOT NULL,
          description TEXT,
          currentType TEXT NOT NULL,
          currentSize TEXT NOT NULL,
          price REAL NOT NULL,
          isAvailable INTEGER NOT NULL,
          calories INTEGER NOT NULL,
          fats REAL,
          saturatedFats REAL,
          sodium REAL,
          carbohydrates REAL,
          fibers REAL,
          sugars REAL,
          proteins REAL,
          calcium REAL,
          iron REAL,
          potassium REAL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS Delivery_Dish (
          idDelivery INTEGER,
          idDish INTEGER,
          status TEXT NOT NULL,
          remoteId INTEGER,
          quantityRemained INTEGER NOT NULL,
          quantityDelivered INTEGER NOT NULL,
          FOREIGN KEY (idDelivery) REFERENCES Delivery (id) ON DELETE CASCADE ON UPDATE CASCADE,
          FOREIGN KEY (idDish) REFERENCES Dish (id) ON DELETE CASCADE ON UPDATE CASCADE,
          PRIMARY KEY (idDelivery, idDish)
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS Ingredient (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          status TEXT NOT NULL,
          remoteId INTEGER,
          name TEXT NOT NULL UNIQUE,
          currentType TEXT NOT NULL,
          description TEXT,
          supplier TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS Dish_Ingredient (
          idDish INTEGER,
          idIngredient INTEGER,
          status TEXT NOT NULL,
          remoteId INTEGER,
          weight REAL,
          FOREIGN KEY (idDish) REFERENCES Dish (id) ON DELETE CASCADE ON UPDATE CASCADE,
          FOREIGN KEY (idIngredient) REFERENCES Ingredient (id) ON DELETE CASCADE ON UPDATE CASCADE,
          PRIMARY KEY (idDish, idIngredient)
        )
      ''');
    });

    return _database!;
  }
}