import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Modelos/eoq_basico_resultado.dart';
import '../Modelos/eoq_descuentos_resultado.dart';
import '../Modelos/eoq_faltantes_resultado.dart';
import '../Modelos/producto.dart';
import '../Modelos/proveedor.dart';

class DatabaseProvider {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'app_database.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Proveedor (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            celular TEXT NOT NULL,
            telefono TEXT NOT NULL,
            correo TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE Producto (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            proveedor_id INTEGER NOT NULL,
            nombre TEXT NOT NULL,
            descripcion TEXT NOT NULL,
            precio_venta REAL NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE EoqBasicos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            producto_id INTEGER NOT NULL,
            cantidad_optima REAL NOT NULL,
            tiempo_ciclo REAL NOT NULL,
            numero_ciclo REAL NOT NULL,
            costo_total REAL NOT NULL,
            FOREIGN KEY (producto_id) REFERENCES Producto (id)
          )
        ''');

        await db.execute('''
          CREATE TABLE EoqDescuentos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            producto_id INTEGER NOT NULL,
            cantidad_optima REAL NOT NULL,
            cantidad_ordenar REAL NOT NULL,
            costo_por_ordenar REAL NOT NULL,
            costo_pedido REAL NOT NULL,
            costo_mantenimiento REAL NOT NULL,
            costo_total REAL NOT NULL,
            FOREIGN KEY (producto_id) REFERENCES Producto (id)
          )
        ''');

        await db.execute('''
          CREATE TABLE EoqFaltantes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            producto_id INTEGER NOT NULL,
            cantidad_optima REAL NOT NULL,
            nivel_maximo REAL NOT NULL,
            tiempo_ciclo REAL NOT NULL,
            numero_ciclo REAL NOT NULL,
            faltante REAL NOT NULL,
            costo_total REAL NOT NULL,
            FOREIGN KEY (producto_id) REFERENCES Producto (id)
          )
        ''');
      },
    );
  }

  // Proveedor
  Future<int> insertProveedor(Proveedor proveedor) async {
    final Database db = await initializeDB();
    return db.insert('Proveedor', proveedor.toMap());
  }

  Future<List<Proveedor>> retrieveProveedores() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Proveedor');
    return queryResult.map((e) => Proveedor.fromMap(e)).toList();
  }

  Future<int> updateProveedor(Proveedor proveedor) async {
    final db = await initializeDB();
    return await db.update(
      'Proveedor',
      proveedor.toMap(),
      where: "id = ?",
      whereArgs: [proveedor.id],
    );
  }

  Future<void> deleteProveedor(int id) async {
    final db = await initializeDB();
    await db.delete(
      'Proveedor',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Producto
  Future<int> insertProducto(Producto producto) async {
    final Database db = await initializeDB();
    return db.insert('Producto', producto.toMap());
  }

  Future<List<Producto>> retrieveProductos() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Producto');
    return queryResult.map((e) => Producto.fromMap(e)).toList();
  }

  Future<int> updateProducto(Producto producto) async {
    final db = await initializeDB();
    return await db.update(
      'Producto',
      producto.toMap(),
      where: "id = ?",
      whereArgs: [producto.id],
    );
  }

  Future<void> deleteProducto(int id) async {
    final db = await initializeDB();
    await db.delete(
      'Producto',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // EoqBasicoResultado
  Future<int> insertEoqBasico(EoqBasicoResultado eoqBasico) async {
    final Database db = await initializeDB();
    return db.insert('EoqBasicos', eoqBasico.toMap());
  }

  Future<List<EoqBasicoResultado>> retrieveEoqBasicos() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('EoqBasicos');
    return queryResult.map((e) => EoqBasicoResultado.fromMap(e)).toList();
  }

  Future<int> updateEoqBasico(EoqBasicoResultado eoqBasico) async {
    final db = await initializeDB();
    return await db.update(
      'EoqBasicos',
      eoqBasico.toMap(),
      where: "id = ?",
      whereArgs: [eoqBasico.id],
    );
  }

  Future<void> deleteEoqBasico(int id) async {
    final db = await initializeDB();
    await db.delete(
      'EoqBasicos',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // EoqFaltantesResultado
  Future<int> insertEoqFaltante(EoqFaltantesResultado eoqFaltante) async {
    final Database db = await initializeDB();
    return db.insert('EoqFaltantes', eoqFaltante.toMap());
  }

  Future<List<EoqFaltantesResultado>> retrieveEoqFaltantes() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('EoqFaltantes');
    return queryResult.map((e) => EoqFaltantesResultado.fromMap(e)).toList();
  }

  Future<int> updateEoqFaltante(EoqFaltantesResultado eoqFaltante) async {
    final db = await initializeDB();
    return await db.update(
      'EoqFaltantes',
      eoqFaltante.toMap(),
      where: "id = ?",
      whereArgs: [eoqFaltante.id],
    );
  }

  Future<void> deleteEoqFaltante(int id) async {
    final db = await initializeDB();
    await db.delete(
      'EoqFaltantes',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // EoqDescuentosResultado
  Future<int> insertEoqDescuento(EoqDescuentosResultado eoqDescuento) async {
    final Database db = await initializeDB();
    return db.insert('EoqDescuentos', eoqDescuento.toMap());
  }

  Future<List<EoqDescuentosResultado>> retrieveEoqDescuentos() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('EoqDescuentos');
    return queryResult.map((e) => EoqDescuentosResultado.fromMap(e)).toList();
  }

  Future<int> updateEoqDescuento(EoqDescuentosResultado eoqDescuento) async {
    final db = await initializeDB();
    return await db.update(
      'EoqDescuentos',
      eoqDescuento.toMap(),
      where: "id = ?",
      whereArgs: [eoqDescuento.id],
    );
  }

  Future<void> deleteEoqDescuento(int id) async {
    final db = await initializeDB();
    await db.delete(
      'EoqDescuentos',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
