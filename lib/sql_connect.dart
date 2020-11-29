import 'dart:async';
import 'package:mysql1/mysql1.dart';
//to test = dart [folder/filename.dart]

Future sqlConnect() async {
  // Open a connection 
  var settings = new ConnectionSettings(
  host: 'localhost', 
  port: 3306,
  user: 'taskuser', //created a new user with a standard password instead of the default root = chaching... but nada
  password: 'Alejandr@123',  
  db: 'Task',
  );

  var conn = await MySqlConnection.connect(settings);

  //figured it would at least get here so i could see if it worked but i dont think it gets there 
  if (conn == null){
    print('did not connect');
  }

  var results = await conn.query('SELECT * FROM Task.task');
  for (var row in results) {
    print('${row[0]}');
  }

  // Finally, close the connection
  await conn.close();
}
