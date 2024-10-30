import 'package:budget_app/classes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle textStyle = const TextStyle(
  fontSize: 20,
  color: Colors.white,
);

TextStyle textStyleSmall = const TextStyle(
  fontSize: 15,
  color: Colors.white,
);

Color colorCategoryAccordingToValue({required int value}) {
  if (value > 0) {
    return Colors.green;
  } else if (value == 0) {
    return const Color(0xFF8F6B4B);
  } else if (value < 0) {
    return Colors.red;
  } else {
    return const Color(0xFF8F6B4B);
  }
}

Color colorEntryAccordingToValue({required int value, int index = 0}) {
  if (value > 0) {
    return Colors.green.shade400;
  } else if (value == 0) {
    return const Color(0xFFC4A285);
  } else if (value < 0) {
    return Colors.red.shade300;
  } else {
    return const Color(0xFFC4A285);
  }
}

Widget categoryWidget(
    {required BuildContext context,
    required final Category category,
    required final VoidCallback onCategoryTap,
    required final VoidCallback onAddButtonTap}) {
  ColorScheme colorScheme = Theme.of(context).colorScheme;

  return Padding(
    padding: const EdgeInsets.only(top: 5, bottom: 5),
    child: Column(
      children: [
        GestureDetector(
          onTap: onCategoryTap,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
              color: colorCategoryAccordingToValue(value: category.value),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(category.isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(category.name, style: textStyle),
                  ],
                ),
                Row(
                  children: [
                    Text("\$${category.value}", style: textStyle),
                    const SizedBox(width: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category.isExpanded)
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: category.entries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: colorEntryAccordingToValue(value: category.entries[index].value, index: index),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(category.entries[index].name, style: textStyle),
                              Text("\$${category.entries[index].value}", style: textStyle),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            if (category.isExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                          color: colorCategoryAccordingToValue(value: category.value),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 25, top: 10, bottom: 10),
                              child: Container(child: Text("TOTAL:   \$${category.value}", style: textStyle)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 12, top: 8),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: Colors.white, width: 1.0),
                                          right: BorderSide(color: Colors.white, width: 0.5),
                                        ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.settings, color: Colors.white, size: 25),
                                        const SizedBox(width: 5),
                                        Text("Edit", style: textStyleSmall),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: onAddButtonTap,
                                    child: Container(
                                      padding: const EdgeInsets.only(bottom: 12, top: 8),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: Colors.white, width: 1.0),
                                          left: BorderSide(color: Colors.white, width: 0.5),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.add_circle_outline, color: Colors.white, size: 25),
                                          const SizedBox(width: 5),
                                          Text("New Entry", style: textStyleSmall),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
