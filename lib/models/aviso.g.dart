// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aviso.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AvisoAdapter extends TypeAdapter<Aviso> {
  @override
  final int typeId = 1;

  @override
  Aviso read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Aviso(
      title: fields[0] as String,
      description: fields[1] as String,
      updateType: fields[2] as String,
      category: fields[3] as String,
      importance: fields[4] as int,
      platform: fields[5] as String,
      details: fields[6] as String,
      urlImagen: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Aviso obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.updateType)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.importance)
      ..writeByte(5)
      ..write(obj.platform)
      ..writeByte(6)
      ..write(obj.details)
      ..writeByte(7)
      ..write(obj.urlImagen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvisoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
