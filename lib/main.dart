import 'package:budget_app/classes.dart';
import 'package:budget_app/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3A3C5E)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Monthly cash flow: +=\$\$\$'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Entry testIncomeEntry;
  late Entry testIncomeEntry2;
  late Entry testExpenseEntry;
  late Entry testExpenseEntry2;
  late Category testIncomeCategory;
  late Category testExpenseCategory;
  List<Category> categoriesList = [];

  @override
  void initState() {
    super.initState();
    testIncomeEntry = Entry(name: "Drug dealing", value: 20);
    testExpenseEntry = Entry(name: "Rent", value: -100);
    testIncomeCategory = Category(name: "test income", firstEntry: testIncomeEntry);
    testExpenseCategory = Category(name: "test expenses", firstEntry: testExpenseEntry);
    testIncomeEntry2 = Entry(name: "Armed Robbery", value: 120);
    testExpenseEntry2 = Entry(name: "OnlyFans", value: -75);

    categoriesList.add(testIncomeCategory);
    categoriesList.add(testExpenseCategory);
  }

  @override
  Widget build(BuildContext context) {
    int monthlyChange = categoriesList.fold(0, (sum, entry) => sum + entry.value);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Monthly cash flow: \$ ${testIncomeCategory.value + testExpenseCategory.value}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => addCategory(context),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categoriesList.length, //todo - categories and labels + sorting categories(first by +/-, then alphabetically)
                itemBuilder: (context, index) => categoryWidget(
                  context: context,
                  category: categoriesList[index],
                  onCategoryTap: () => expandCategory(categoriesList[index]),
                  onAddButtonTap: () => addEntryToCategory(context, categoriesList[index]),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    "Monthly change:",
                    style: GoogleFonts.nunito(
                      fontSize: 45,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  Text(
                    "${monthlyChange > 0 ? '+' : '-'} \$$monthlyChange",
                    style: GoogleFonts.nunito(
                      fontSize: 40,
                      color: monthlyChange > 0 ? Colors.green : Colors.red,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void expandCategory(Category category) {
    setState(() {
      category.isExpanded = !category.isExpanded;
    });
  }

  Future<void> addEntryToCategory(BuildContext context, Category category) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController costController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();

    // Show the alert dialog
    return showDialog<void>( //todo - create a customAlertDialog
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New ${category.name} Entry'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: 'Enter name'),
                ),
                TextField(
                  controller: costController,
                  decoration: InputDecoration(hintText: 'Enter cost (integer)'),
                  keyboardType: TextInputType.number, // Make the keyboard numeric
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(hintText: 'Enter optional category'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // Get values from the controllers
                String name = nameController.text;
                int? cost = int.tryParse(costController.text); // Convert cost to int
                String? subCategory = categoryController.text.isNotEmpty ? categoryController.text : null; // Optional category

                // Check if name and cost are provided
                if (name.isNotEmpty && cost != null) {
                  Entry newEntry = Entry(name: name, value: cost, subCategory: subCategory);
                  // Process the input (e.g., add it to your list)
                  setState(() {
                    category!.entries.add(newEntry);
                  });
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // Show an error if validation fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid name and cost.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addCategory(BuildContext context) async {
    final TextEditingController categoryNameController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController costController = TextEditingController();
    final TextEditingController subCategoryController = TextEditingController();

    // Show the alert dialog
    return showDialog<void>( //todo - create a customAlertDialog
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: categoryNameController,
                  decoration: const InputDecoration(hintText: 'category name'),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'entry name'),
                ),
                TextField(
                  controller: costController,
                  decoration: const InputDecoration(hintText: 'Enter cost (integer)'),
                  keyboardType: TextInputType.number, // Make the keyboard numeric
                ),
                TextField(
                  controller: subCategoryController,
                  decoration: const InputDecoration(hintText: 'Enter optional category'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // Get values from the controllers
                String name = nameController.text;
                int? cost = int.tryParse(costController.text); // Convert cost to int
                String? subCategory = subCategoryController.text.isNotEmpty ? subCategoryController.text : null; // Optional category

                // Check if name and cost are provided
                if (name.isNotEmpty && cost != null) {
                  Entry newEntry = Entry(name: name, value: cost, subCategory: subCategory);
                  Category newCategory = Category(name: categoryNameController.text, firstEntry: newEntry);
                  // Process the input (e.g., add it to your list)
                  setState(() {
                    categoriesList.add(newCategory);
                  });
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // Show an error if validation fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid name and cost.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

}
