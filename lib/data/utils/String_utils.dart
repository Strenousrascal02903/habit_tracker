// lib/utils/string_utils.dart

/// Mengkapitalisasi huruf pertama dari sebuah string.
/// Jika ingin sisanya diubah ke huruf kecil, gunakan [toLowerCase()] pada substring.
String capitalize(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

/// Versi di mana sisanya diubah ke huruf kecil:
String capitalizeSentence(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}
