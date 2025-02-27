
import 'dart:io';

import 'package:jni/jni.dart';
import 'package:jni_leveldb/leveldb/org/iq80/leveldb/_package.dart';
import 'package:jni_leveldb/leveldb/org/iq80/leveldb/impl/_package.dart';

import 'dart:convert';

void db() {
  var options = Options();
  options.createIfMissing$1(true);
  String file = 'example.db';
  final fileClass = JClass.forName("java/io/File");
  final inputFile = fileClass.constructorId("(Ljava/lang/String;)V").call(fileClass, JObject.type, [file.toJString()]);

  DB db = Iq80DBFactory.factory!.open(file.toJavaFile(), options)!;
  //DB db = Iq80DBFactory.factory!.open(inputFile, options)!;
  try {
    db.put(Iq80DBFactory.bytes('Akron'.toJString()), Iq80DBFactory.bytes('Ohio'.toJString()));
    db.put(JByteArray.from(utf8.encode('Tampa')), JByteArray.from(utf8.encode('Florida')));

    SeekingIteratorAdapter? iterator = db.iterator()?.as(SeekingIteratorAdapter.type);
    iterator?.seekToFirst();
    
    while(iterator?.hasNext() != false) {
      var entry = iterator?.next();
      print(formatEntry(entry!));
    }

  } finally {
    //db.close();
  }
}

extension JFile on String{
  JObject? toJavaFile() {
    final fileClass = JClass.forName("java/io/File");
    final inputFile = fileClass.constructorId("(Ljava/lang/String;)V").call(fileClass, JObject.type, [this.toJString()]);
    return inputFile;
  }
}

String formatEntry(SeekingIteratorAdapter$DbEntry entry) {
  var city = utf8.decoder.convert( entry!.getKey()!.toList() );
  var state = utf8.decoder.convert( entry.getValue()!.toList() );
  return "$city, $state";
}
