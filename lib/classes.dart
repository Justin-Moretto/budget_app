
class Category {
  Category({required this.name, required this.firstEntry, this.isExpanded = false}) {
    entries.add(firstEntry); // Ensure the first entry is always included
  }
  bool isExpanded;
  String name;
  Entry firstEntry; //Categories can't exist without at least one entry
  List<Entry> entries = [];
  //List<String> subCategories;

  int get value { //the total income or expense from a category
    return entries.fold(0, (sum, entry) => sum + entry.value);
  }
}

class Entry {
  Entry({required this.name, required this.value, this.subCategory});
  String name;
  int value = 0; //the cost or revenue from an Entry
  String? subCategory;
}