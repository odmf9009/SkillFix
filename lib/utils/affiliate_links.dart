class AffiliateLinks {
  // Reemplaza con tu Amazon Associates tag real
  static const String _amazonTag = 'korovi-20';

  static String amazon(String itemName) {
    final q = Uri.encodeComponent(itemName);
    return 'https://www.amazon.com/s?k=$q&tag=$_amazonTag';
  }

  static String homedepot(String itemName) {
    final q = Uri.encodeComponent(itemName);
    return 'https://www.homedepot.com/s/$q';
  }
}
