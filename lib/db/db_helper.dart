import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart';

class DbHelper {
  //1-single instance
  DbHelper._();

  static final DbHelper helper = DbHelper._();

  //2- path of database
  Future<String> getDbPath() async {
    String dbPath = await getDatabasesPath();
    String myDbPath = join(dbPath, dbName);
    return myDbPath;
  }

  //3-create or open
  Future<Database> openOrCreateDb() async {
    String path = await getDbPath();
    return openDatabase(path,
        version: dbVersion,
        onCreate: (db, version) => _createTable(db),
        onUpgrade: (db, oldVersion, newVersion) => _upgradeTable(db),
        onDowngrade: (db, oldVersion, newVersion) => _downgradeTable(),
        singleInstance: true);
  }

  _createTable(Database db) {
    try {
      String sql =
          'create table $tableName($colId integer primary key autoincrement, $colTitle text, $colText text, $colDate text)';
      print(sql);
      db.execute(sql);
    } catch (e) {
      print(e.toString());
    }
  }

  _upgradeTable(Database db) {
    try {
      String sql = 'alter table $tableName add column $colColor text';
      print(sql);
      db.execute(sql);
    } catch (e) {
      print(e.toString());
    }

  }

  _downgradeTable() {
    print('downgrade Table');
  }
}
