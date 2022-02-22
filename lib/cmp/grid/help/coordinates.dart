import 'dart:math';

///Unified representation of cube and axial coordinates systems.
///
class Coordinates {
  ///Cube constructor
  const Coordinates.cube(this.x, this.y, this.z);

  ///Axial constructor
  Coordinates.axial(int q, int r)
      : x = q,
        y = -q - r,
        z = r;

  ///value of coordinates
  final int x, y, z;

  ///getter q of x coord
  int get q => x;

  ///getter r of z coord
  int get r => z;

  ///Distance measured in steps between tiles. A single step is only going over
  ///edge of neighbouring tiles.
  int distance(Coordinates other) {
    return max(
      (x - other.x).abs(),
      max((y - other.y).abs(), (z - other.z).abs()),
    );
  }

  ///Operator + for Coordinates.cube
  Coordinates operator +(Coordinates other) {
    return Coordinates.cube(x + other.x, y + other.y, z + other.z);
  }

  ///Operator - for Coordinates.cube
  Coordinates operator -(Coordinates other) {
    return Coordinates.cube(x - other.x, y - other.y, z - other.z);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is Coordinates && other.x == x && other.y == y && other.z == z;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => x ^ y ^ z;

  ///Constant value of space center
  static const Coordinates zero = Coordinates.cube(0, 0, 0);

  @override
  String toString() => 'Coordinates[cube: ($x, $y, $z), axial: ($q, $r)]';
}
