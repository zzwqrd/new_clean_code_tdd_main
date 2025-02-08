import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DropdownItem {
  final String title;
  final int id;
  final List<DropdownItem>? children;
  bool isExpanded;
  bool isSelected;

  DropdownItem({
    required this.title,
    required this.id,
    this.children,
    this.isExpanded = false,
    this.isSelected = false,
  });
}

enum ChipDisplayMode { wrap, scrollableRow }

class CustomDropdown extends StatefulWidget {
  final List<DropdownItem> items;
  final bool isMultiSelect;
  final ChipDisplayMode chipDisplayMode;
  final ValueChanged<dynamic>
      onChanged; // Use dynamic to accept both single and list of items
  final String hintText;
  final bool isLoading;
  final dynamic value; // Accept either DropdownItem or List<DropdownItem>

  const CustomDropdown({
    Key? key,
    required this.items,
    this.isMultiSelect = true,
    this.chipDisplayMode = ChipDisplayMode.wrap,
    required this.onChanged,
    this.hintText = "اختر عنصر",
    this.isLoading = false,
    this.value,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  List<DropdownItem> selectedValues = [];
  DropdownItem? selectedItem;
  bool isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    if (widget.isMultiSelect) {
      selectedValues = widget.value ?? [];
    } else {
      selectedItem = widget.value;
      if (selectedItem != null) {
        selectedValues = [selectedItem!];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.isLoading
              ? null
              : () {
                  setState(() {
                    isDropdownOpen = !isDropdownOpen;
                  });
                },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: BoxConstraints(
              maxHeight: widget.chipDisplayMode == ChipDisplayMode.wrap
                  ? _calculateWrapHeight()
                  : 60,
            ),
            child: widget.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _buildChipDisplay(),
          ),
        ),
        if (isDropdownOpen && !widget.isLoading)
          Flexible(
            child: Container(
              margin: EdgeInsets.only(top: 8),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: widget.items
                    .map((item) => _buildDropdownItem(item))
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }

  double _calculateWrapHeight() {
    int maxItemsInRow = (MediaQuery.of(context).size.width / 120).floor();
    int numRows = (selectedValues.length / maxItemsInRow).ceil();

    return selectedValues.isEmpty
        ? 60.0
        : (numRows * 40.0) + 20; // Calculate height based on rows
  }

  Widget _buildChipDisplay() {
    if (selectedValues.isEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.hintText,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    switch (widget.chipDisplayMode) {
      case ChipDisplayMode.scrollableRow:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: selectedValues.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Chip(
                  label: Text(item.title),
                  deleteIcon: Icon(Icons.clear),
                  onDeleted: () {
                    setState(() {
                      item.isSelected = false;
                      selectedValues.remove(item);
                      widget.onChanged(widget.isMultiSelect
                          ? selectedValues
                          : selectedValues.isEmpty
                              ? null
                              : selectedValues.first);
                    });
                  },
                  backgroundColor: Colors.orangeAccent,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        );
      case ChipDisplayMode.wrap:
      default:
        return Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: selectedValues.map((item) {
            return Chip(
              label: Text(item.title),
              deleteIcon: Icon(Icons.clear),
              onDeleted: () {
                setState(() {
                  item.isSelected = false;
                  selectedValues.remove(item);
                  widget.onChanged(widget.isMultiSelect
                      ? selectedValues
                      : selectedValues.isEmpty
                          ? null
                          : selectedValues.first);
                });
              },
              backgroundColor: Colors.orangeAccent,
              labelStyle: TextStyle(color: Colors.white),
            );
          }).toList(),
        );
    }
  }

  Widget _buildDropdownItem(DropdownItem item, {int level = 0}) {
    return Column(
      children: [
        ListTile(
          leading: Checkbox(
            value: selectedValues.contains(item),
            onChanged: widget.isLoading
                ? null
                : (selected) {
                    setState(() {
                      if (widget.isMultiSelect) {
                        if (selected == true) {
                          selectedValues.add(item);
                          item.isSelected = true;
                        } else {
                          selectedValues.remove(item);
                          item.isSelected = false;
                        }
                      } else {
                        selectedValues.clear();
                        _clearSelections();
                        if (selected == true) {
                          selectedValues.add(item);
                          selectedItem = item;
                          item.isSelected = true;
                        } else {
                          selectedItem = null;
                        }
                      }
                      widget.onChanged(
                          widget.isMultiSelect ? selectedValues : selectedItem);
                    });
                  },
            activeColor: Colors.green,
          ),
          title: Text(
            item.title,
            style: TextStyle(
              color:
                  selectedValues.contains(item) ? Colors.green : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          contentPadding: EdgeInsets.only(left: level * 20.0, right: 16.0),
          onTap: widget.isLoading
              ? null
              : () {
                  if (item.children != null) {
                    setState(() {
                      _collapseAllExcept(item);
                      item.isExpanded = !item.isExpanded;
                    });
                  } else {
                    setState(() {
                      if (widget.isMultiSelect) {
                        if (selectedValues.contains(item)) {
                          selectedValues.remove(item);
                          item.isSelected = false;
                        } else {
                          selectedValues.add(item);
                          item.isSelected = true;
                        }
                      } else {
                        selectedValues.clear();
                        _clearSelections();
                        selectedValues.add(item);
                        selectedItem = item;
                        item.isSelected = true;
                      }
                      widget.onChanged(
                          widget.isMultiSelect ? selectedValues : selectedItem);
                    });
                  }
                },
          trailing: item.children != null
              ? Icon(
                  item.isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 20,
                )
              : null,
        ),
        if (item.children != null && item.isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: item.children!
                  .map((child) => _buildDropdownItem(child, level: level + 1))
                  .toList(),
            ),
          ),
      ],
    );
  }

  void _collapseAllExcept(DropdownItem selectedItem) {
    for (var item in widget.items) {
      if (item != selectedItem && item.isExpanded) {
        item.isExpanded = false;
      }
      if (item.children != null) {
        for (var child in item.children!) {
          if (child != selectedItem && child.isExpanded) {
            child.isExpanded = false;
          }
        }
      }
    }
  }

  void _clearSelections() {
    for (var item in widget.items) {
      item.isSelected = false;
      if (item.children != null) {
        for (var child in item.children!) {
          child.isSelected = false;
        }
      }
    }
  }
}

// تعديل الـ DropdownScreen لتدعم isMultiSelect
class DropdownScreen extends StatefulWidget {
  @override
  _DropdownScreenState createState() => _DropdownScreenState();
}

class _DropdownScreenState extends State<DropdownScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Drop Multi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider(
          create: (context) => DropdownCubit()..fetchData(),
          child: BlocBuilder<DropdownCubit, DropdownState>(
            builder: (context, state) {
              if (state is DropdownLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DropdownLoaded) {
                return CustomDropdown(
                  items: state.items,
                  isMultiSelect: true, // دعم الاختيار المتعدد
                  chipDisplayMode: ChipDisplayMode.scrollableRow,
                  hintText: "اختر منتجًا",
                  isLoading: false,
                  value: state.selectedItems, // تمرير قائمة العناصر المحددة
                  onChanged: (selectedItems) {
                    context.read<DropdownCubit>().emit(DropdownLoaded(
                          state.items,
                          selectedItems: selectedItems,
                        ));
                  },
                );
              } else {
                return const Center(child: Text("خطأ في تحميل البيانات"));
              }
            },
          ),
        ),
      ),
    );
  }
}

// حالات الـ Cubit
abstract class DropdownState {}

class DropdownLoading extends DropdownState {}

class DropdownLoaded extends DropdownState {
  final List<DropdownItem> items;
  final List<DropdownItem> selectedItems; // قائمة العناصر المختارة

  DropdownLoaded(this.items, {this.selectedItems = const []});
}

// الكيوبت لإدارة حالة جلب البيانات
class DropdownCubit extends Cubit<DropdownState> {
  DropdownCubit() : super(DropdownLoading());

  final List<DropdownItem> dataSelected = [
    DropdownItem(id: 9, title: "زين"),
    DropdownItem(id: 3, title: "كوبا"),
    DropdownItem(id: 5, title: "ججج"),
    DropdownItem(id: 6, title: "ررر"),
    DropdownItem(id: 12, title: "٣٣٣"),
    DropdownItem(id: 13, title: "٤٤٤٤"),
    DropdownItem(id: 14, title: "أمريكا الجنوبية"),
  ];

  // الدالة لجلب البيانات
  Future<void> fetchData() async {
    emit(DropdownLoading()); // إصدار حالة التحميل
    await Future.delayed(Duration(seconds: 2)); // محاكاة وقت التحميل

    final fetchedItems = [
      DropdownItem(
        id: 1,
        title: "أمريكا الشمالية",
        children: [
          DropdownItem(id: 2, title: "الولايات المتحدة الأمريكية"),
          DropdownItem(id: 3, title: "كوبا"),
        ],
      ),
      DropdownItem(
        id: 4,
        title: "المكسيك",
        children: [
          DropdownItem(id: 5, title: "ججج"),
          DropdownItem(id: 6, title: "ررر"),
        ],
      ),
      DropdownItem(id: 7, title: "آسيا"),
      DropdownItem(id: 8, title: "أوروبا"),
      DropdownItem(
        id: 9,
        title: "زين",
        children: [
          DropdownItem(id: 10, title: "١١"),
          DropdownItem(id: 11, title: "٢٢٢"),
          DropdownItem(id: 12, title: "٣٣٣"),
          DropdownItem(id: 13, title: "٤٤٤٤"),
        ],
      ),
      DropdownItem(id: 14, title: "أمريكا الجنوبية"),
    ];

    // البحث عن العناصر المحددة في القائمة وتعيينها كعناصر مختارة
    List<DropdownItem> selectedItems = [];
    for (var item in fetchedItems) {
      for (var selectedItem in dataSelected) {
        if (item.id == selectedItem.id) {
          item.isSelected = true;
          selectedItems.add(item);
        } else if (item.children != null) {
          final foundChild = item.children!.firstWhere(
            (child) => child.id == selectedItem.id,
            orElse: () => item,
          );
          if (foundChild.id == selectedItem.id) {
            foundChild.isSelected = true;
            selectedItems.add(foundChild);
          }
        }
      }
    }

    emit(DropdownLoaded(fetchedItems, selectedItems: selectedItems));
  }
}
