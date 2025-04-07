import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final double margin;
  final String label;
  final String value;
  final double size;
  final IconData? icon; // opsional, jika kamu ingin menambahkan icon

  const DetailRow({
    Key? key,
    required this.margin,
    required this.label,
    required this.value,
    required this.size,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 18),
            SizedBox(width: 8),
          ],

          /// HAPUS `Container(width: double.infinity)`, GUNAKAN `Expanded` UNTUK FLEXIBLE WIDTH
          Expanded(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: margin),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: size,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 4), // Spasi kecil antara label dan ":"
                Text(
                  ":",
                  style: TextStyle(
                    fontSize: size,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10), // Spasi kecil antara ":" dan value
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: size,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                    overflow:
                        TextOverflow.ellipsis, // Jika value terlalu panjang
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
