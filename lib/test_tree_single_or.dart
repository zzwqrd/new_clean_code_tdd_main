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
  final ValueChanged<List<DropdownItem>> onChanged;
  final String hintText;
  final bool isLoading;

  const CustomDropdown({
    Key? key,
    required this.items,
    this.isMultiSelect = true,
    this.chipDisplayMode = ChipDisplayMode.wrap,
    required this.onChanged,
    this.hintText = "اختر عنصر",
    this.isLoading = false,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  List<DropdownItem> selectedValues = [];
  bool isDropdownOpen = false;

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
        : (numRows * 40.0) + 20; // حساب الارتفاع بناءً على عدد الصفوف
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
                      widget.onChanged(selectedValues);
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
                  widget.onChanged(selectedValues);
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
                          item.isSelected = true;
                        }
                      }
                      widget.onChanged(selectedValues);
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
                        item.isSelected = true;
                      }
                      widget.onChanged(selectedValues);
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

class DropdownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider(
          create: (context) => DropdownCubit()..fetchData(),
          child: BlocBuilder<DropdownCubit, DropdownState>(
            builder: (context, state) {
              bool isLoading = state is DropdownLoading;
              List<DropdownItem> items =
                  state is DropdownLoaded ? state.items : [];

              return CustomDropdown(
                items: items,
                isMultiSelect: false,
                chipDisplayMode: ChipDisplayMode.scrollableRow,
                hintText: "اختر منتجًا",
                isLoading: isLoading,
                onChanged: (selectedItems) {
                  print(
                      "Selected items: ${selectedItems.map((e) => e.id).join(", ")}");
                },
              );
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

  DropdownLoaded(this.items);
}

// الكيوبت لإدارة حالة جلب البيانات
class DropdownCubit extends Cubit<DropdownState> {
  DropdownCubit() : super(DropdownLoading());

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

    emit(DropdownLoaded(fetchedItems)); // إصدار حالة البيانات التي تم جلبها
  }
}

// import 'package:flutter/material.dart';
//
// class DropdownItem {
//   final String title;
//   final int id;
//   final List<DropdownItem>? children;
//   bool isExpanded;
//   bool isSelected;
//
//   DropdownItem({
//     required this.title,
//     required this.id,
//     this.children,
//     this.isExpanded = false,
//     this.isSelected = false,
//   });
// }
//
// enum ChipDisplayMode { wrap, scrollableRow }
//
// class CustomDropdown extends StatefulWidget {
//   final List<DropdownItem> items;
//   final bool isMultiSelect;
//   final ChipDisplayMode chipDisplayMode;
//   final ValueChanged<List<DropdownItem>> onChanged;
//   final String hintText;
//
//   const CustomDropdown({
//     Key? key,
//     required this.items,
//     this.isMultiSelect = true,
//     this.chipDisplayMode = ChipDisplayMode.wrap,
//     required this.onChanged,
//     this.hintText = "اختر عنصر",
//   }) : super(key: key);
//
//   @override
//   _CustomDropdownState createState() => _CustomDropdownState();
// }
//
// class _CustomDropdownState extends State<CustomDropdown> {
//   List<DropdownItem> selectedValues = [];
//   bool isDropdownOpen = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               isDropdownOpen = !isDropdownOpen;
//             });
//           },
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             padding: EdgeInsets.symmetric(horizontal: 12),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.green, width: 2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             constraints: BoxConstraints(
//               maxHeight: widget.chipDisplayMode == ChipDisplayMode.wrap
//                   ? _calculateWrapHeight()
//                   : 60, // تعيين الارتفاع الافتراضي للتمرير الجانبي
//             ),
//             child: _buildChipDisplay(),
//           ),
//         ),
//         if (isDropdownOpen)
//           Flexible(
//             child: Container(
//               margin: EdgeInsets.only(top: 8),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey, width: 2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: widget.items
//                     .map((item) => _buildDropdownItem(item))
//                     .toList(),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   double _calculateWrapHeight() {
//     int maxItemsInRow = (MediaQuery.of(context).size.width / 120).floor();
//     int numRows = (selectedValues.length / maxItemsInRow).ceil();
//
//     return selectedValues.isEmpty
//         ? 60.0
//         : (numRows * 40.0) + 20; // حساب الارتفاع بناءً على عدد الصفوف
//   }
//
//   Widget _buildChipDisplay() {
//     if (selectedValues.isEmpty) {
//       return Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           widget.hintText,
//           style: TextStyle(color: Colors.grey),
//         ),
//       );
//     }
//
//     switch (widget.chipDisplayMode) {
//       case ChipDisplayMode.scrollableRow:
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: selectedValues.map((item) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: Chip(
//                   label: Text(item.title),
//                   deleteIcon: Icon(Icons.clear),
//                   onDeleted: () {
//                     setState(() {
//                       item.isSelected = false;
//                       selectedValues.remove(item);
//                       widget.onChanged(selectedValues);
//                     });
//                   },
//                   backgroundColor: Colors.orangeAccent,
//                   labelStyle: TextStyle(color: Colors.white),
//                 ),
//               );
//             }).toList(),
//           ),
//         );
//       case ChipDisplayMode.wrap:
//       default:
//         return Wrap(
//           spacing: 8.0,
//           runSpacing: 4.0,
//           children: selectedValues.map((item) {
//             return Chip(
//               label: Text(item.title),
//               deleteIcon: Icon(Icons.clear),
//               onDeleted: () {
//                 setState(() {
//                   item.isSelected = false;
//                   selectedValues.remove(item);
//                   widget.onChanged(selectedValues);
//                 });
//               },
//               backgroundColor: Colors.orangeAccent,
//               labelStyle: TextStyle(color: Colors.white),
//             );
//           }).toList(),
//         );
//     }
//   }
//
//   Widget _buildDropdownItem(DropdownItem item, {int level = 0}) {
//     return Column(
//       children: [
//         ListTile(
//           leading: Checkbox(
//             value: selectedValues.contains(item),
//             onChanged: (selected) {
//               setState(() {
//                 if (widget.isMultiSelect) {
//                   if (selected == true) {
//                     selectedValues.add(item);
//                     item.isSelected = true;
//                   } else {
//                     selectedValues.remove(item);
//                     item.isSelected = false;
//                   }
//                 } else {
//                   selectedValues.clear();
//                   _clearSelections();
//                   if (selected == true) {
//                     selectedValues.add(item);
//                     item.isSelected = true;
//                   }
//                 }
//                 widget.onChanged(selectedValues);
//               });
//             },
//             activeColor: Colors.green,
//           ),
//           title: Text(
//             item.title,
//             style: TextStyle(
//               color:
//                   selectedValues.contains(item) ? Colors.green : Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           contentPadding: EdgeInsets.only(left: level * 20.0, right: 16.0),
//           onTap: () {
//             if (item.children != null) {
//               setState(() {
//                 _collapseAllExcept(item);
//                 item.isExpanded = !item.isExpanded;
//               });
//             } else {
//               setState(() {
//                 if (widget.isMultiSelect) {
//                   if (selectedValues.contains(item)) {
//                     selectedValues.remove(item);
//                     item.isSelected = false;
//                   } else {
//                     selectedValues.add(item);
//                     item.isSelected = true;
//                   }
//                 } else {
//                   selectedValues.clear();
//                   _clearSelections();
//                   selectedValues.add(item);
//                   item.isSelected = true;
//                 }
//                 widget.onChanged(selectedValues);
//               });
//             }
//           },
//           trailing: item.children != null
//               ? Icon(
//                   item.isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
//                   size: 20,
//                 )
//               : null,
//         ),
//         if (item.children != null && item.isExpanded)
//           Padding(
//             padding: const EdgeInsets.only(left: 16.0),
//             child: Column(
//               children: item.children!
//                   .map((child) => _buildDropdownItem(child, level: level + 1))
//                   .toList(),
//             ),
//           ),
//       ],
//     );
//   }
//
//   void _collapseAllExcept(DropdownItem selectedItem) {
//     for (var item in widget.items) {
//       if (item != selectedItem && item.isExpanded) {
//         item.isExpanded = false;
//       }
//       if (item.children != null) {
//         for (var child in item.children!) {
//           if (child != selectedItem && child.isExpanded) {
//             child.isExpanded = false;
//           }
//         }
//       }
//     }
//   }
//
//   void _clearSelections() {
//     for (var item in widget.items) {
//       item.isSelected = false;
//       if (item.children != null) {
//         for (var child in item.children!) {
//           child.isSelected = false;
//         }
//       }
//     }
//   }
// }
//
// class DropdownScreen extends StatelessWidget {
//   final List<DropdownItem> items = [
//     DropdownItem(
//       id: 1,
//       title: "أمريكا الشمالية",
//       children: [
//         DropdownItem(id: 2, title: "الولايات المتحدة الأمريكية"),
//         DropdownItem(id: 3, title: "كوبا"),
//       ],
//     ),
//     DropdownItem(
//       id: 4,
//       title: "المكسيك",
//       children: [
//         DropdownItem(id: 5, title: "ججج"),
//         DropdownItem(id: 6, title: "ررر"),
//       ],
//     ),
//     DropdownItem(id: 7, title: "آسيا"),
//     DropdownItem(id: 8, title: "أوروبا"),
//     DropdownItem(
//       id: 9,
//       title: "زين",
//       children: [
//         DropdownItem(id: 10, title: "١١"),
//         DropdownItem(id: 11, title: "٢٢٢"),
//         DropdownItem(id: 12, title: "٣٣٣"),
//         DropdownItem(id: 13, title: "٤٤٤٤"),
//       ],
//     ),
//     DropdownItem(id: 14, title: "أمريكا الجنوبية"),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: CustomDropdown(
//           items: items,
//           isMultiSelect: false,
//           chipDisplayMode: ChipDisplayMode.wrap,
//           hintText: "اختر منتجًا",
//           onChanged: (selectedItems) {
//             print(
//                 "Selected items: ${selectedItems.map((e) => e.id).join(", ")}");
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
//
// class DropdownItem {
//   final String title;
//   final int id;
//   final List<DropdownItem>? children;
//   bool isExpanded;
//   bool isSelected;
//
//   DropdownItem({
//     required this.title,
//     required this.id,
//     this.children,
//     this.isExpanded = false,
//     this.isSelected = false,
//   });
// }
//
// enum ChipDisplayMode { wrap, scrollableRow }
//
// class CustomDropdown extends StatefulWidget {
//   final List<DropdownItem> items;
//   final bool isMultiSelect;
//   final ChipDisplayMode chipDisplayMode;
//   final ValueChanged<List<DropdownItem>> onChanged;
//   final String hintText;
//
//   const CustomDropdown({
//     Key? key,
//     required this.items,
//     this.isMultiSelect = true,
//     this.chipDisplayMode = ChipDisplayMode.wrap,
//     required this.onChanged,
//     this.hintText = "اختر عنصر",
//   }) : super(key: key);
//
//   @override
//   _CustomDropdownState createState() => _CustomDropdownState();
// }
//
// class _CustomDropdownState extends State<CustomDropdown> {
//   List<DropdownItem> selectedValues = [];
//   bool isDropdownOpen = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               isDropdownOpen = !isDropdownOpen;
//             });
//           },
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             padding: EdgeInsets.symmetric(horizontal: 12),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.green, width: 2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             constraints: BoxConstraints(
//               maxHeight: widget.chipDisplayMode == ChipDisplayMode.wrap
//                   ? _calculateWrapHeight()
//                   : 60,
//             ),
//             child: _buildChipDisplay(),
//           ),
//         ),
//         if (isDropdownOpen)
//           Flexible(
//             child: Container(
//               margin: EdgeInsets.only(top: 8),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey, width: 2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: widget.items
//                     .map((item) => _buildDropdownItem(item))
//                     .toList(),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   double _calculateWrapHeight() {
//     int maxItemsInRow = (MediaQuery.of(context).size.width / 120).floor();
//     int numRows = (selectedValues.length / maxItemsInRow).ceil();
//
//     return selectedValues.isEmpty ? 60.0 : (numRows * 40.0) + 20;
//   }
//
//   Widget _buildChipDisplay() {
//     if (selectedValues.isEmpty) {
//       return Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           widget.hintText,
//           style: TextStyle(color: Colors.grey),
//         ),
//       );
//     }
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: Wrap(
//         spacing: 8.0,
//         runSpacing: 4.0,
//         children: selectedValues.map((item) {
//           return Chip(
//             label: Text(item.title),
//             deleteIcon: Icon(Icons.clear),
//             onDeleted: () {
//               setState(() {
//                 item.isSelected = false;
//                 selectedValues.remove(item);
//                 widget.onChanged(selectedValues);
//               });
//             },
//             backgroundColor: Colors.orangeAccent,
//             labelStyle: TextStyle(color: Colors.white),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   Widget _buildDropdownItem(DropdownItem item, {int level = 0}) {
//     return Column(
//       children: [
//         ListTile(
//           leading: Checkbox(
//             value: selectedValues.contains(item),
//             onChanged: (selected) {
//               setState(() {
//                 if (widget.isMultiSelect) {
//                   if (selected == true) {
//                     selectedValues.add(item);
//                     item.isSelected = true;
//                   } else {
//                     selectedValues.remove(item);
//                     item.isSelected = false;
//                   }
//                 } else {
//                   selectedValues.clear();
//                   _clearSelections();
//                   if (selected == true) {
//                     selectedValues.add(item);
//                     item.isSelected = true;
//                   }
//                 }
//                 widget.onChanged(selectedValues);
//               });
//             },
//             activeColor: Colors.green,
//           ),
//           title: Text(
//             item.title,
//             style: TextStyle(
//               color:
//                   selectedValues.contains(item) ? Colors.green : Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           contentPadding: EdgeInsets.only(left: level * 20.0, right: 16.0),
//           onTap: () {
//             if (item.children != null) {
//               setState(() {
//                 _collapseAllExcept(item);
//                 item.isExpanded = !item.isExpanded;
//               });
//             } else {
//               setState(() {
//                 if (widget.isMultiSelect) {
//                   if (selectedValues.contains(item)) {
//                     selectedValues.remove(item);
//                     item.isSelected = false;
//                   } else {
//                     selectedValues.add(item);
//                     item.isSelected = true;
//                   }
//                 } else {
//                   selectedValues.clear();
//                   _clearSelections();
//                   selectedValues.add(item);
//                   item.isSelected = true;
//                 }
//                 widget.onChanged(selectedValues);
//               });
//             }
//           },
//           trailing: item.children != null
//               ? Icon(
//                   item.isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
//                   size: 20,
//                 )
//               : null,
//         ),
//         if (item.children != null && item.isExpanded)
//           Padding(
//             padding: const EdgeInsets.only(left: 16.0),
//             child: Column(
//               children: item.children!
//                   .map((child) => _buildDropdownItem(child, level: level + 1))
//                   .toList(),
//             ),
//           ),
//       ],
//     );
//   }
//
//   void _collapseAllExcept(DropdownItem selectedItem) {
//     for (var item in widget.items) {
//       if (item != selectedItem && item.isExpanded) {
//         item.isExpanded = false;
//       }
//       if (item.children != null) {
//         for (var child in item.children!) {
//           if (child != selectedItem && child.isExpanded) {
//             child.isExpanded = false;
//           }
//         }
//       }
//     }
//   }
//
//   void _clearSelections() {
//     for (var item in widget.items) {
//       item.isSelected = false;
//       if (item.children != null) {
//         for (var child in item.children!) {
//           child.isSelected = false;
//         }
//       }
//     }
//   }
// }
//
// class DropdownScreen extends StatelessWidget {
//   final List<DropdownItem> items = [
//     DropdownItem(
//       id: 1,
//       title: "أمريكا الشمالية",
//       children: [
//         DropdownItem(id: 2, title: "الولايات المتحدة الأمريكية"),
//         DropdownItem(id: 3, title: "كوبا"),
//       ],
//     ),
//     DropdownItem(
//       id: 4,
//       title: "المكسيك",
//       children: [
//         DropdownItem(id: 5, title: "ججج"),
//         DropdownItem(id: 6, title: "ررر"),
//       ],
//     ),
//     DropdownItem(id: 7, title: "آسيا"),
//     DropdownItem(id: 8, title: "أوروبا"),
//     DropdownItem(
//       id: 9,
//       title: "زين",
//       children: [
//         DropdownItem(id: 10, title: "١١"),
//         DropdownItem(id: 11, title: "٢٢٢"),
//         DropdownItem(id: 12, title: "٣٣٣"),
//         DropdownItem(id: 13, title: "٤٤٤٤"),
//       ],
//     ),
//     DropdownItem(id: 14, title: "أمريكا الجنوبية"),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: CustomDropdown(
//           items: items,
//           isMultiSelect: true,
//           chipDisplayMode: ChipDisplayMode.scrollableRow,
//           hintText: "اختر منتجًا",
//           onChanged: (selectedItems) {
//             print(
//                 "Selected items: ${selectedItems.map((e) => e.title).join(", ")}");
//           },
//         ),
//       ),
//     );
//   }
// }
//
// // import 'package:flutter/material.dart';
// //
// // class DropdownItem {
// //   final String title;
// //   final int id;
// //   final List<DropdownItem>? children;
// //   bool isExpanded;
// //   bool isSelected;
// //
// //   DropdownItem({
// //     required this.title,
// //     required this.id,
// //     this.children,
// //     this.isExpanded = false,
// //     this.isSelected = false,
// //   });
// // }
// //
// // enum ChipDisplayMode { wrap, scrollableRow }
// //
// // class CustomDropdown extends StatefulWidget {
// //   final List<DropdownItem> items;
// //   final bool isMultiSelect;
// //   final ChipDisplayMode chipDisplayMode;
// //   final ValueChanged<List<DropdownItem>> onChanged;
// //   final String hintText;
// //
// //   const CustomDropdown({
// //     Key? key,
// //     required this.items,
// //     this.isMultiSelect = true,
// //     this.chipDisplayMode = ChipDisplayMode.wrap,
// //     required this.onChanged,
// //     this.hintText = "اختر عنصر",
// //   }) : super(key: key);
// //
// //   @override
// //   _CustomDropdownState createState() => _CustomDropdownState();
// // }
// //
// // class _CustomDropdownState extends State<CustomDropdown> {
// //   List<DropdownItem> selectedValues = [];
// //   bool isDropdownOpen = false;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         GestureDetector(
// //           onTap: () {
// //             setState(() {
// //               isDropdownOpen = !isDropdownOpen;
// //             });
// //           },
// //           child: Container(
// //             width: MediaQuery.of(context).size.width,
// //             padding: EdgeInsets.symmetric(horizontal: 12),
// //             decoration: BoxDecoration(
// //               border: Border.all(color: Colors.green, width: 2),
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             constraints: BoxConstraints(
// //               maxHeight: widget.chipDisplayMode == ChipDisplayMode.wrap
// //                   ? _calculateWrapHeight()
// //                   : 60, // ارتفاع ديناميكي إذا كان wrap
// //             ),
// //             child: _buildChipDisplay(),
// //           ),
// //         ),
// //         if (isDropdownOpen)
// //           Flexible(
// //             child: Container(
// //               margin: EdgeInsets.only(top: 8),
// //               width: MediaQuery.of(context).size.width,
// //               decoration: BoxDecoration(
// //                 border: Border.all(color: Colors.grey, width: 2),
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: ListView(
// //                 padding: EdgeInsets.zero,
// //                 children: widget.items
// //                     .map((item) => _buildDropdownItem(item))
// //                     .toList(),
// //               ),
// //             ),
// //           ),
// //       ],
// //     );
// //   }
// //
// //   double _calculateWrapHeight() {
// //     int maxItemsInRow = (MediaQuery.of(context).size.width / 120).floor();
// //     int numRows = (selectedValues.length / maxItemsInRow).ceil();
// //
// //     return selectedValues.isEmpty
// //         ? 60.0
// //         : (numRows * 40.0) + 20; // ديناميكية بناءً على عدد الصفوف
// //   }
// //
// //   Widget _buildChipDisplay() {
// //     if (selectedValues.isEmpty) {
// //       return Align(
// //         alignment: Alignment.centerLeft,
// //         child: Text(
// //           widget.hintText,
// //           style: TextStyle(color: Colors.grey),
// //         ),
// //       );
// //     }
// //
// //     switch (widget.chipDisplayMode) {
// //       case ChipDisplayMode.scrollableRow:
// //         return SingleChildScrollView(
// //           scrollDirection: Axis.horizontal,
// //           child: Row(
// //             children: selectedValues.map((item) {
// //               return Chip(
// //                 label: Text(item.title),
// //                 deleteIcon: Icon(Icons.clear),
// //                 onDeleted: () {
// //                   setState(() {
// //                     item.isSelected = false;
// //                     selectedValues.remove(item);
// //                     widget.onChanged(selectedValues);
// //                   });
// //                 },
// //                 backgroundColor: Colors.orangeAccent,
// //                 labelStyle: TextStyle(color: Colors.white),
// //               );
// //             }).toList(),
// //           ),
// //         );
// //       case ChipDisplayMode.wrap:
// //       default:
// //         return Wrap(
// //           spacing: 8.0,
// //           runSpacing: 4.0,
// //           children: selectedValues.map((item) {
// //             return Chip(
// //               label: Text(item.title),
// //               deleteIcon: Icon(Icons.clear),
// //               onDeleted: () {
// //                 setState(() {
// //                   item.isSelected = false;
// //                   selectedValues.remove(item);
// //                   widget.onChanged(selectedValues);
// //                 });
// //               },
// //               backgroundColor: Colors.orangeAccent,
// //               labelStyle: TextStyle(color: Colors.white),
// //             );
// //           }).toList(),
// //         );
// //     }
// //   }
// //
// //   Widget _buildDropdownItem(DropdownItem item, {int level = 0}) {
// //     return Column(
// //       children: [
// //         ListTile(
// //           leading: Checkbox(
// //             value: selectedValues.contains(item),
// //             onChanged: (selected) {
// //               setState(() {
// //                 if (widget.isMultiSelect) {
// //                   if (selected == true) {
// //                     selectedValues.add(item);
// //                     item.isSelected = true;
// //                   } else {
// //                     selectedValues.remove(item);
// //                     item.isSelected = false;
// //                   }
// //                 } else {
// //                   selectedValues.clear();
// //                   _clearSelections();
// //                   if (selected == true) {
// //                     selectedValues.add(item);
// //                     item.isSelected = true;
// //                   }
// //                 }
// //                 widget.onChanged(selectedValues);
// //               });
// //             },
// //             activeColor: Colors.green,
// //           ),
// //           title: Text(
// //             item.title,
// //             style: TextStyle(
// //               color:
// //                   selectedValues.contains(item) ? Colors.green : Colors.black,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           contentPadding: EdgeInsets.only(left: level * 20.0, right: 16.0),
// //           onTap: () {
// //             if (item.children != null) {
// //               setState(() {
// //                 _collapseAllExcept(item);
// //                 item.isExpanded = !item.isExpanded;
// //               });
// //             } else {
// //               setState(() {
// //                 if (widget.isMultiSelect) {
// //                   if (selectedValues.contains(item)) {
// //                     selectedValues.remove(item);
// //                     item.isSelected = false;
// //                   } else {
// //                     selectedValues.add(item);
// //                     item.isSelected = true;
// //                   }
// //                 } else {
// //                   selectedValues.clear();
// //                   _clearSelections();
// //                   selectedValues.add(item);
// //                   item.isSelected = true;
// //                 }
// //                 widget.onChanged(selectedValues);
// //               });
// //             }
// //           },
// //           trailing: item.children != null
// //               ? Icon(
// //                   item.isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
// //                   size: 20,
// //                 )
// //               : null,
// //         ),
// //         if (item.children != null && item.isExpanded)
// //           Padding(
// //             padding: const EdgeInsets.only(left: 16.0),
// //             child: Column(
// //               children: item.children!
// //                   .map((child) => _buildDropdownItem(child, level: level + 1))
// //                   .toList(),
// //             ),
// //           ),
// //       ],
// //     );
// //   }
// //
// //   void _collapseAllExcept(DropdownItem selectedItem) {
// //     for (var item in widget.items) {
// //       if (item != selectedItem && item.isExpanded) {
// //         item.isExpanded = false;
// //       }
// //       if (item.children != null) {
// //         for (var child in item.children!) {
// //           if (child != selectedItem && child.isExpanded) {
// //             child.isExpanded = false;
// //           }
// //         }
// //       }
// //     }
// //   }
// //
// //   void _clearSelections() {
// //     for (var item in widget.items) {
// //       item.isSelected = false;
// //       if (item.children != null) {
// //         for (var child in item.children!) {
// //           child.isSelected = false;
// //         }
// //       }
// //     }
// //   }
// // }
// //
// // class DropdownScreen extends StatelessWidget {
// //   final List<DropdownItem> items = [
// //     DropdownItem(
// //       id: 1,
// //       title: "أمريكا الشمالية",
// //       children: [
// //         DropdownItem(id: 2, title: "الولايات المتحدة الأمريكية"),
// //         DropdownItem(id: 3, title: "كوبا"),
// //       ],
// //     ),
// //     DropdownItem(
// //       id: 4,
// //       title: "المكسيك",
// //       children: [
// //         DropdownItem(id: 5, title: "ججج"),
// //         DropdownItem(id: 6, title: "ررر"),
// //       ],
// //     ),
// //     DropdownItem(id: 7, title: "آسيا"),
// //     DropdownItem(id: 8, title: "أوروبا"),
// //     DropdownItem(
// //       id: 9,
// //       title: "زين",
// //       children: [
// //         DropdownItem(id: 10, title: "١١"),
// //         DropdownItem(id: 11, title: "٢٢٢"),
// //         DropdownItem(id: 12, title: "٣٣٣"),
// //         DropdownItem(id: 13, title: "٤٤٤٤"),
// //       ],
// //     ),
// //     DropdownItem(id: 14, title: "أمريكا الجنوبية"),
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: CustomDropdown(
// //           items: items,
// //           isMultiSelect: true,
// //           chipDisplayMode: ChipDisplayMode.wrap,
// //           hintText: "اختر منتجًا",
// //           onChanged: (selectedItems) {
// //             print(
// //                 "Selected items: ${selectedItems.map((e) => e.title).join(", ")}");
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // import 'package:flutter/material.dart';
// // //
// // // class DropdownItem {
// // //   final String title;
// // //   final int id;
// // //   final List<DropdownItem>? children;
// // //   bool isExpanded;
// // //   bool isSelected;
// // //
// // //   DropdownItem({
// // //     required this.title,
// // //     required this.id,
// // //     this.children,
// // //     this.isExpanded = false,
// // //     this.isSelected = false,
// // //   });
// // // }
// // //
// // // enum ChipDisplayMode { wrap, scrollableRow }
// // //
// // // class CustomDropdown extends StatefulWidget {
// // //   final List<DropdownItem> items;
// // //   final bool isMultiSelect;
// // //   final ChipDisplayMode chipDisplayMode;
// // //   final ValueChanged<List<DropdownItem>> onChanged;
// // //   final String hintText;
// // //
// // //   const CustomDropdown({
// // //     Key? key,
// // //     required this.items,
// // //     this.isMultiSelect = true,
// // //     this.chipDisplayMode = ChipDisplayMode.wrap,
// // //     required this.onChanged,
// // //     this.hintText = "اختر عنصر",
// // //   }) : super(key: key);
// // //
// // //   @override
// // //   _CustomDropdownState createState() => _CustomDropdownState();
// // // }
// // //
// // // class _CustomDropdownState extends State<CustomDropdown> {
// // //   List<DropdownItem> selectedValues = [];
// // //   bool isDropdownOpen = false;
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         GestureDetector(
// // //           onTap: () {
// // //             setState(() {
// // //               isDropdownOpen = !isDropdownOpen;
// // //             });
// // //           },
// // //           child: Container(
// // //             width: MediaQuery.of(context).size.width,
// // //             height: widget.chipDisplayMode == ChipDisplayMode.wrap
// // //                 ? _calculateWrapHeight()
// // //                 : 60,
// // //             padding: EdgeInsets.symmetric(horizontal: 12),
// // //             decoration: BoxDecoration(
// // //               border: Border.all(color: Colors.green, width: 2),
// // //               borderRadius: BorderRadius.circular(8),
// // //             ),
// // //             child: _buildChipDisplay(),
// // //           ),
// // //         ),
// // //         if (isDropdownOpen)
// // //           Container(
// // //             margin: EdgeInsets.only(top: 8),
// // //             width: MediaQuery.of(context).size.width,
// // //             decoration: BoxDecoration(
// // //               border: Border.all(color: Colors.grey, width: 2),
// // //               borderRadius: BorderRadius.circular(8),
// // //             ),
// // //             child: ListView(
// // //               shrinkWrap: true,
// // //               padding: EdgeInsets.zero,
// // //               children:
// // //                   widget.items.map((item) => _buildDropdownItem(item)).toList(),
// // //             ),
// // //           ),
// // //       ],
// // //     );
// // //   }
// // //
// // //   double _calculateWrapHeight() {
// // //     int maxItemsInRow = (MediaQuery.of(context).size.width / 120).floor();
// // //     int numRows = (selectedValues.length / maxItemsInRow).ceil();
// // //
// // //     return selectedValues.length <= 3 ? 60.0 : numRows * 40.0 + 20;
// // //   }
// // //
// // //   Widget _buildChipDisplay() {
// // //     if (selectedValues.isEmpty) {
// // //       return Align(
// // //         alignment: Alignment.centerLeft,
// // //         child: Text(
// // //           widget.hintText,
// // //           style: TextStyle(color: Colors.grey),
// // //         ),
// // //       );
// // //     }
// // //
// // //     switch (widget.chipDisplayMode) {
// // //       case ChipDisplayMode.scrollableRow:
// // //         return SingleChildScrollView(
// // //           scrollDirection: Axis.horizontal,
// // //           child: Row(
// // //             children: selectedValues.map((item) {
// // //               return Chip(
// // //                 label: Text(item.title),
// // //                 deleteIcon: Icon(Icons.clear),
// // //                 onDeleted: () {
// // //                   setState(() {
// // //                     item.isSelected = false;
// // //                     selectedValues.remove(item);
// // //                     widget.onChanged(selectedValues);
// // //                   });
// // //                 },
// // //                 backgroundColor: Colors.orangeAccent,
// // //                 labelStyle: TextStyle(color: Colors.white),
// // //               );
// // //             }).toList(),
// // //           ),
// // //         );
// // //       case ChipDisplayMode.wrap:
// // //       default:
// // //         return Wrap(
// // //           spacing: 8.0,
// // //           runSpacing: 4.0,
// // //           children: selectedValues.map((item) {
// // //             return Chip(
// // //               label: Text(item.title),
// // //               deleteIcon: Icon(Icons.clear),
// // //               onDeleted: () {
// // //                 setState(() {
// // //                   item.isSelected = false;
// // //                   selectedValues.remove(item);
// // //                   widget.onChanged(selectedValues);
// // //                 });
// // //               },
// // //               backgroundColor: Colors.orangeAccent,
// // //               labelStyle: TextStyle(color: Colors.white),
// // //             );
// // //           }).toList(),
// // //         );
// // //     }
// // //   }
// // //
// // //   Widget _buildDropdownItem(DropdownItem item, {int level = 0}) {
// // //     return Column(
// // //       children: [
// // //         ListTile(
// // //           leading: Checkbox(
// // //             value: selectedValues.contains(item),
// // //             onChanged: (selected) {
// // //               setState(() {
// // //                 if (widget.isMultiSelect) {
// // //                   if (selected == true) {
// // //                     selectedValues.add(item);
// // //                     item.isSelected = true;
// // //                   } else {
// // //                     selectedValues.remove(item);
// // //                     item.isSelected = false;
// // //                   }
// // //                 } else {
// // //                   // اختيار قيمة واحدة فقط
// // //                   selectedValues.clear();
// // //                   _clearSelections();
// // //                   if (selected == true) {
// // //                     selectedValues.add(item);
// // //                     item.isSelected = true;
// // //                   }
// // //                 }
// // //                 widget.onChanged(selectedValues);
// // //               });
// // //             },
// // //             activeColor: Colors.green,
// // //           ),
// // //           title: Text(
// // //             item.title,
// // //             style: TextStyle(
// // //               color:
// // //                   selectedValues.contains(item) ? Colors.green : Colors.black,
// // //               fontWeight: FontWeight.bold,
// // //             ),
// // //           ),
// // //           contentPadding: EdgeInsets.only(left: level * 20.0, right: 16.0),
// // //           onTap: () {
// // //             if (item.children != null) {
// // //               setState(() {
// // //                 // إغلاق جميع الفروع المفتوحة الأخرى
// // //                 _collapseAllExcept(item);
// // //                 item.isExpanded = !item.isExpanded;
// // //               });
// // //             } else {
// // //               setState(() {
// // //                 if (widget.isMultiSelect) {
// // //                   if (selectedValues.contains(item)) {
// // //                     selectedValues.remove(item);
// // //                     item.isSelected = false;
// // //                   } else {
// // //                     selectedValues.add(item);
// // //                     item.isSelected = true;
// // //                   }
// // //                 } else {
// // //                   selectedValues.clear();
// // //                   _clearSelections();
// // //                   selectedValues.add(item);
// // //                   item.isSelected = true;
// // //                 }
// // //                 widget.onChanged(selectedValues);
// // //               });
// // //             }
// // //           },
// // //           trailing: item.children != null
// // //               ? Icon(
// // //                   item.isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
// // //                   size: 20,
// // //                 )
// // //               : null,
// // //         ),
// // //         if (item.children != null && item.isExpanded)
// // //           Padding(
// // //             padding: const EdgeInsets.only(left: 16.0),
// // //             child: Column(
// // //               children: item.children!
// // //                   .map((child) => _buildDropdownItem(child, level: level + 1))
// // //                   .toList(),
// // //             ),
// // //           ),
// // //       ],
// // //     );
// // //   }
// // //
// // //   void _collapseAllExcept(DropdownItem selectedItem) {
// // //     for (var item in widget.items) {
// // //       if (item != selectedItem && item.isExpanded) {
// // //         item.isExpanded = false;
// // //       }
// // //       if (item.children != null) {
// // //         for (var child in item.children!) {
// // //           if (child != selectedItem && child.isExpanded) {
// // //             child.isExpanded = false;
// // //           }
// // //         }
// // //       }
// // //     }
// // //   }
// // //
// // //   void _clearSelections() {
// // //     for (var item in widget.items) {
// // //       item.isSelected = false;
// // //       if (item.children != null) {
// // //         for (var child in item.children!) {
// // //           child.isSelected = false;
// // //         }
// // //       }
// // //     }
// // //   }
// // // }
// // //
// // // class DropdownScreen extends StatelessWidget {
// // //   final List<DropdownItem> items = [
// // //     DropdownItem(
// // //       id: 1,
// // //       title: "أمريكا الشمالية",
// // //       children: [
// // //         DropdownItem(id: 2, title: "الولايات المتحدة الأمريكية"),
// // //         DropdownItem(id: 3, title: "كوبا"),
// // //       ],
// // //     ),
// // //     DropdownItem(
// // //       id: 4,
// // //       title: "المكسيك",
// // //       children: [
// // //         DropdownItem(id: 5, title: "ججج"),
// // //         DropdownItem(id: 6, title: "ررر"),
// // //       ],
// // //     ),
// // //     DropdownItem(id: 7, title: "آسيا"),
// // //     DropdownItem(id: 8, title: "أوروبا"),
// // //     DropdownItem(
// // //       id: 9,
// // //       title: "زين",
// // //       children: [
// // //         DropdownItem(id: 10, title: "١١"),
// // //         DropdownItem(id: 11, title: "٢٢٢"),
// // //         DropdownItem(id: 12, title: "٣٣٣"),
// // //         DropdownItem(id: 13, title: "٤٤٤٤"),
// // //       ],
// // //     ),
// // //     DropdownItem(id: 14, title: "أمريكا الجنوبية"),
// // //   ];
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(),
// // //       body: SingleChildScrollView(
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(16.0),
// // //           child: CustomDropdown(
// // //             items: items,
// // //             isMultiSelect: true, // السماح باختيار عنصر واحد فقط
// // //             chipDisplayMode: ChipDisplayMode.wrap, // التحكم في طريقة العرض
// // //             hintText: "اختر منتجًا", // النص الإرشادي المخصص
// // //             onChanged: (selectedItems) {
// // //               print(
// // //                   "Selected items: ${selectedItems.map((e) => e.title).join(", ")}");
// // //             },
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // // import 'package:flutter/material.dart';
// // // //
// // // // class DropdownItem {
// // // //   final String title;
// // // //   final int id;
// // // //   final List<DropdownItem>? children;
// // // //   bool isExpanded;
// // // //   bool isSelected;
// // // //
// // // //   DropdownItem({
// // // //     required this.title,
// // // //     required this.id,
// // // //     this.children,
// // // //     this.isExpanded = false,
// // // //     this.isSelected = false,
// // // //   });
// // // // }
// // // //
// // // // enum ChipDisplayMode { wrap, scrollableRow }
// // // //
// // // // class CustomDropdown extends StatefulWidget {
// // // //   final List<DropdownItem> items;
// // // //   final bool isMultiSelect;
// // // //   final ChipDisplayMode chipDisplayMode;
// // // //   final ValueChanged<List<DropdownItem>> onChanged;
// // // //   final String hintText; // لإضافة النص الإرشادي
// // // //
// // // //   const CustomDropdown({
// // // //     Key? key,
// // // //     required this.items,
// // // //     this.isMultiSelect = true,
// // // //     this.chipDisplayMode = ChipDisplayMode.wrap,
// // // //     required this.onChanged,
// // // //     this.hintText = "اختر عنصر", // القيمة الافتراضية للنص الإرشادي
// // // //   }) : super(key: key);
// // // //
// // // //   @override
// // // //   _CustomDropdownState createState() => _CustomDropdownState();
// // // // }
// // // //
// // // // class _CustomDropdownState extends State<CustomDropdown> {
// // // //   List<DropdownItem> selectedValues = [];
// // // //   bool isDropdownOpen = false;
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         GestureDetector(
// // // //           onTap: () {
// // // //             setState(() {
// // // //               isDropdownOpen = !isDropdownOpen;
// // // //             });
// // // //           },
// // // //           child: Container(
// // // //             width: MediaQuery.of(context).size.width, // عرض الشاشة بالكامل
// // // //             height: widget.chipDisplayMode == ChipDisplayMode.wrap
// // // //                 ? _calculateWrapHeight()
// // // //                 : 60, // ارتفاع ديناميكي أو ثابت بناءً على ChipDisplayMode
// // // //             padding: EdgeInsets.symmetric(horizontal: 12),
// // // //             decoration: BoxDecoration(
// // // //               border: Border.all(color: Colors.green, width: 2),
// // // //               borderRadius: BorderRadius.circular(8),
// // // //             ),
// // // //             child: _buildChipDisplay(),
// // // //           ),
// // // //         ),
// // // //         if (isDropdownOpen)
// // // //           Container(
// // // //             margin: EdgeInsets.only(top: 8),
// // // //             width: MediaQuery.of(context).size.width, // عرض الشاشة بالكامل
// // // //             decoration: BoxDecoration(
// // // //               border: Border.all(color: Colors.grey, width: 2),
// // // //               borderRadius: BorderRadius.circular(8),
// // // //             ),
// // // //             child: ListView(
// // // //               shrinkWrap: true,
// // // //               padding: EdgeInsets.zero,
// // // //               children:
// // // //                   widget.items.map((item) => _buildDropdownItem(item)).toList(),
// // // //             ),
// // // //           ),
// // // //       ],
// // // //     );
// // // //   }
// // // //
// // // //   double _calculateWrapHeight() {
// // // //     int maxItemsInRow = (MediaQuery.of(context).size.width / 120).floor();
// // // //     int numRows = (selectedValues.length / maxItemsInRow).ceil();
// // // //
// // // //     return selectedValues.length <= 3 ? 60.0 : numRows * 40.0 + 20;
// // // //   }
// // // //
// // // //   Widget _buildChipDisplay() {
// // // //     if (selectedValues.isEmpty) {
// // // //       return Align(
// // // //         alignment: Alignment.centerLeft,
// // // //         child: Text(
// // // //           widget.hintText, // عرض النص الإرشادي إذا لم يتم اختيار أي عنصر
// // // //           style: TextStyle(color: Colors.grey),
// // // //         ),
// // // //       );
// // // //     }
// // // //
// // // //     switch (widget.chipDisplayMode) {
// // // //       case ChipDisplayMode.scrollableRow:
// // // //         return SingleChildScrollView(
// // // //           scrollDirection: Axis.horizontal,
// // // //           child: Row(
// // // //             children: selectedValues.map((item) {
// // // //               return Chip(
// // // //                 label: Text(item.title),
// // // //                 deleteIcon: Icon(Icons.clear),
// // // //                 onDeleted: () {
// // // //                   setState(() {
// // // //                     item.isSelected = false;
// // // //                     selectedValues.remove(item);
// // // //                     widget.onChanged(selectedValues);
// // // //                   });
// // // //                 },
// // // //                 backgroundColor: Colors.orangeAccent,
// // // //                 labelStyle: TextStyle(color: Colors.white),
// // // //               );
// // // //             }).toList(),
// // // //           ),
// // // //         );
// // // //       case ChipDisplayMode.wrap:
// // // //       default:
// // // //         return Wrap(
// // // //           spacing: 8.0,
// // // //           runSpacing: 4.0,
// // // //           children: selectedValues.map((item) {
// // // //             return Chip(
// // // //               label: Text(item.title),
// // // //               deleteIcon: Icon(Icons.clear),
// // // //               onDeleted: () {
// // // //                 setState(() {
// // // //                   item.isSelected = false;
// // // //                   selectedValues.remove(item);
// // // //                   widget.onChanged(selectedValues);
// // // //                 });
// // // //               },
// // // //               backgroundColor: Colors.orangeAccent,
// // // //               labelStyle: TextStyle(color: Colors.white),
// // // //             );
// // // //           }).toList(),
// // // //         );
// // // //     }
// // // //   }
// // // //
// // // //   Widget _buildDropdownItem(DropdownItem item, {int level = 0}) {
// // // //     return Column(
// // // //       children: [
// // // //         ListTile(
// // // //           leading: Checkbox(
// // // //             value: selectedValues.contains(item),
// // // //             onChanged: (selected) {
// // // //               setState(() {
// // // //                 if (widget.isMultiSelect) {
// // // //                   if (selected == true) {
// // // //                     selectedValues.add(item);
// // // //                     item.isSelected = true;
// // // //                   } else {
// // // //                     selectedValues.remove(item);
// // // //                     item.isSelected = false;
// // // //                   }
// // // //                 } else {
// // // //                   // اختيار قيمة واحدة فقط
// // // //                   selectedValues.clear();
// // // //                   _clearSelections();
// // // //                   if (selected == true) {
// // // //                     selectedValues.add(item);
// // // //                     item.isSelected = true;
// // // //                   }
// // // //                 }
// // // //                 widget.onChanged(selectedValues);
// // // //               });
// // // //             },
// // // //             activeColor: Colors.green,
// // // //           ),
// // // //           title: Text(
// // // //             item.title,
// // // //             style: TextStyle(
// // // //               color:
// // // //                   selectedValues.contains(item) ? Colors.green : Colors.black,
// // // //               fontWeight: FontWeight.bold,
// // // //             ),
// // // //           ),
// // // //           contentPadding: EdgeInsets.only(left: level * 20.0, right: 16.0),
// // // //           onTap: () {
// // // //             if (item.children != null) {
// // // //               setState(() {
// // // //                 item.isExpanded = !item.isExpanded;
// // // //               });
// // // //             } else {
// // // //               setState(() {
// // // //                 if (widget.isMultiSelect) {
// // // //                   if (selectedValues.contains(item)) {
// // // //                     selectedValues.remove(item);
// // // //                     item.isSelected = false;
// // // //                   } else {
// // // //                     selectedValues.add(item);
// // // //                     item.isSelected = true;
// // // //                   }
// // // //                 } else {
// // // //                   selectedValues.clear();
// // // //                   _clearSelections();
// // // //                   selectedValues.add(item);
// // // //                   item.isSelected = true;
// // // //                 }
// // // //                 widget.onChanged(selectedValues);
// // // //               });
// // // //             }
// // // //           },
// // // //           trailing: item.children != null
// // // //               ? Icon(
// // // //                   item.isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
// // // //                   size: 20,
// // // //                 )
// // // //               : null,
// // // //         ),
// // // //         if (item.children != null && item.isExpanded)
// // // //           Padding(
// // // //             padding: const EdgeInsets.only(left: 16.0),
// // // //             child: Column(
// // // //               children: item.children!
// // // //                   .map((child) => _buildDropdownItem(child, level: level + 1))
// // // //                   .toList(),
// // // //             ),
// // // //           ),
// // // //       ],
// // // //     );
// // // //   }
// // // //
// // // //   void _clearSelections() {
// // // //     for (var item in widget.items) {
// // // //       item.isSelected = false;
// // // //       if (item.children != null) {
// // // //         for (var child in item.children!) {
// // // //           child.isSelected = false;
// // // //         }
// // // //       }
// // // //     }
// // // //   }
// // // // }
// // // //
// // // // class DropdownScreen extends StatelessWidget {
// // // //   final List<DropdownItem> items = [
// // // //     DropdownItem(
// // // //       id: 1,
// // // //       title: "أمريكا الشمالية",
// // // //       children: [
// // // //         DropdownItem(id: 2, title: "الولايات المتحدة الأمريكية"),
// // // //         DropdownItem(id: 3, title: "كوبا"),
// // // //       ],
// // // //     ),
// // // //     DropdownItem(
// // // //       id: 4,
// // // //       title: "المكسيك",
// // // //       children: [
// // // //         DropdownItem(id: 5, title: "ججج"),
// // // //         DropdownItem(id: 6, title: "ررر"),
// // // //       ],
// // // //     ),
// // // //     DropdownItem(id: 7, title: "آسيا"),
// // // //     DropdownItem(id: 8, title: "أوروبا"),
// // // //     DropdownItem(
// // // //       id: 9,
// // // //       title: "زين",
// // // //       children: [
// // // //         DropdownItem(id: 10, title: "١١"),
// // // //         DropdownItem(id: 11, title: "٢٢٢"),
// // // //         DropdownItem(id: 12, title: "٣٣٣"),
// // // //         DropdownItem(id: 13, title: "٤٤٤٤"),
// // // //       ],
// // // //     ),
// // // //     DropdownItem(id: 14, title: "أمريكا الجنوبية"),
// // // //   ];
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(),
// // // //       body: Padding(
// // // //         padding: const EdgeInsets.all(16.0),
// // // //         child: CustomDropdown(
// // // //           items: items,
// // // //           isMultiSelect: false, // السماح باختيار عنصر واحد فقط
// // // //           chipDisplayMode: ChipDisplayMode.wrap, // التحكم في طريقة العرض
// // // //           hintText: "اختر منتجًا", // النص الإرشادي المخصص
// // // //           onChanged: (selectedItems) {
// // // //             print(
// // // //                 "Selected items: ${selectedItems.map((e) => e.title).join(", ")}");
// // // //           },
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // //
// // // // import 'package:flutter/material.dart';
// // // //
// // // // class DropdownItem {
// // // //   final String title;
// // // //   final int id;
// // // //   final List<DropdownItem>? children;
// // // //   bool isExpanded;
// // // //   bool isSelected;
// // // //
// // // //   DropdownItem({
// // // //     required this.title,
// // // //     required this.id,
// // // //     this.children,
// // // //     this.isExpanded = false,
// // // //     this.isSelected = false,
// // // //   });
// // // // }
// // // //
// // // // enum ChipDisplayMode { wrap, scrollableRow }
// // // //
// // // // class CustomDropdown extends StatefulWidget {
// // // //   final List<DropdownItem> items;
// // // //   final bool isMultiSelect;
// // // //   final ChipDisplayMode chipDisplayMode;
// // // //   final ValueChanged<List<DropdownItem>> onChanged;
// // // //
// // // //   const CustomDropdown({
// // // //     Key? key,
// // // //     required this.items,
// // // //     this.isMultiSelect = true,
// // // //     this.chipDisplayMode = ChipDisplayMode.wrap,
// // // //     required this.onChanged,
// // // //   }) : super(key: key);
// // // //
// // // //   @override
// // // //   _CustomDropdownState createState() => _CustomDropdownState();
// // // // }
// // // //
// // // // class _CustomDropdownState extends State<CustomDropdown> {
// // // //   List<DropdownItem> selectedValues = [];
// // // //   bool isDropdownOpen = false;
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         GestureDetector(
// // // //           onTap: () {
// // // //             setState(() {
// // // //               isDropdownOpen = !isDropdownOpen;
// // // //             });
// // // //           },
// // // //           child: Container(
// // // //             width: MediaQuery.of(context).size.width, // عرض الشاشة بالكامل
// // // //             height: widget.chipDisplayMode == ChipDisplayMode.wrap
// // // //                 ? _calculateWrapHeight()
// // // //                 : 60, // ارتفاع ديناميكي أو ثابت بناءً على ChipDisplayMode
// // // //             padding: EdgeInsets.symmetric(horizontal: 12),
// // // //             decoration: BoxDecoration(
// // // //               border: Border.all(color: Colors.green, width: 2),
// // // //               borderRadius: BorderRadius.circular(8),
// // // //             ),
// // // //             child: _buildChipDisplay(),
// // // //           ),
// // // //         ),
// // // //         if (isDropdownOpen)
// // // //           Container(
// // // //             margin: EdgeInsets.only(top: 8),
// // // //             width: MediaQuery.of(context).size.width, // عرض الشاشة بالكامل
// // // //             decoration: BoxDecoration(
// // // //               border: Border.all(color: Colors.grey, width: 2),
// // // //               borderRadius: BorderRadius.circular(8),
// // // //             ),
// // // //             child: ListView(
// // // //               shrinkWrap: true,
// // // //               padding: EdgeInsets.zero,
// // // //               children:
// // // //                   widget.items.map((item) => _buildDropdownItem(item)).toList(),
// // // //             ),
// // // //           ),
// // // //       ],
// // // //     );
// // // //   }
// // // //
// // // //   double _calculateWrapHeight() {
// // // //     // إذا كان عدد العناصر المختارة أقل من 3، يكون الارتفاع ثابت 60
// // // //     // وإلا يتوسع بشكل ديناميكي حسب الحاجة
// // // //     int maxItemsInRow = (MediaQuery.of(context).size.width / 120).floor();
// // // //     int numRows = (selectedValues.length / maxItemsInRow).ceil();
// // // //
// // // //     return selectedValues.length <= 3 ? 60.0 : numRows * 40.0 + 20;
// // // //   }
// // // //
// // // //   Widget _buildChipDisplay() {
// // // //     switch (widget.chipDisplayMode) {
// // // //       case ChipDisplayMode.scrollableRow:
// // // //         return SingleChildScrollView(
// // // //           scrollDirection: Axis.horizontal,
// // // //           child: Row(
// // // //             children: selectedValues.map((item) {
// // // //               return Chip(
// // // //                 label: Text(item.title),
// // // //                 deleteIcon: Icon(Icons.clear),
// // // //                 onDeleted: () {
// // // //                   setState(() {
// // // //                     item.isSelected = false;
// // // //                     selectedValues.remove(item);
// // // //                     widget.onChanged(selectedValues);
// // // //                   });
// // // //                 },
// // // //                 backgroundColor: Colors.orangeAccent,
// // // //                 labelStyle: TextStyle(color: Colors.white),
// // // //               );
// // // //             }).toList(),
// // // //           ),
// // // //         );
// // // //       case ChipDisplayMode.wrap:
// // // //       default:
// // // //         return Wrap(
// // // //           spacing: 8.0,
// // // //           runSpacing: 4.0,
// // // //           children: selectedValues.map((item) {
// // // //             return Chip(
// // // //               label: Text(item.title),
// // // //               deleteIcon: Icon(Icons.clear),
// // // //               onDeleted: () {
// // // //                 setState(() {
// // // //                   item.isSelected = false;
// // // //                   selectedValues.remove(item);
// // // //                   widget.onChanged(selectedValues);
// // // //                 });
// // // //               },
// // // //               backgroundColor: Colors.orangeAccent,
// // // //               labelStyle: TextStyle(color: Colors.white),
// // // //             );
// // // //           }).toList(),
// // // //         );
// // // //     }
// // // //   }
// // // //
// // // //   Widget _buildDropdownItem(DropdownItem item, {int level = 0}) {
// // // //     return Column(
// // // //       children: [
// // // //         ListTile(
// // // //           leading: Checkbox(
// // // //             value: selectedValues.contains(item),
// // // //             onChanged: (selected) {
// // // //               if (selected == true) {
// // // //                 setState(() {
// // // //                   selectedValues.add(item);
// // // //                   item.isSelected = true;
// // // //                   widget.onChanged(selectedValues);
// // // //                 });
// // // //               } else {
// // // //                 setState(() {
// // // //                   selectedValues.remove(item);
// // // //                   item.isSelected = false;
// // // //                   widget.onChanged(selectedValues);
// // // //                 });
// // // //               }
// // // //             },
// // // //             activeColor: Colors.green,
// // // //           ),
// // // //           title: Text(
// // // //             item.title,
// // // //             style: TextStyle(
// // // //               color:
// // // //                   selectedValues.contains(item) ? Colors.green : Colors.black,
// // // //               fontWeight: FontWeight.bold,
// // // //             ),
// // // //           ),
// // // //           contentPadding: EdgeInsets.only(left: level * 20.0, right: 16.0),
// // // //           onTap: () {
// // // //             if (item.children != null) {
// // // //               setState(() {
// // // //                 item.isExpanded = !item.isExpanded;
// // // //               });
// // // //             } else {
// // // //               if (selectedValues.contains(item)) {
// // // //                 setState(() {
// // // //                   selectedValues.remove(item);
// // // //                   item.isSelected = false;
// // // //                   widget.onChanged(selectedValues);
// // // //                 });
// // // //               } else {
// // // //                 setState(() {
// // // //                   selectedValues.add(item);
// // // //                   item.isSelected = true;
// // // //                   widget.onChanged(selectedValues);
// // // //                 });
// // // //               }
// // // //             }
// // // //           },
// // // //           trailing: item.children != null
// // // //               ? Icon(
// // // //                   item.isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
// // // //                   size: 20,
// // // //                 )
// // // //               : null,
// // // //         ),
// // // //         if (item.children != null && item.isExpanded)
// // // //           Padding(
// // // //             padding: const EdgeInsets.only(left: 16.0),
// // // //             child: Column(
// // // //               children: item.children!
// // // //                   .map((child) => _buildDropdownItem(child, level: level + 1))
// // // //                   .toList(),
// // // //             ),
// // // //           ),
// // // //       ],
// // // //     );
// // // //   }
// // // // }
// // // //
// // // // class DropdownScreen extends StatelessWidget {
// // // //   final List<DropdownItem> items = [
// // // //     DropdownItem(
// // // //       id: 1,
// // // //       title: "أمريكا الشمالية",
// // // //       children: [
// // // //         DropdownItem(id: 2, title: "الولايات المتحدة الأمريكية"),
// // // //         DropdownItem(id: 3, title: "كوبا"),
// // // //       ],
// // // //     ),
// // // //     DropdownItem(
// // // //       id: 4,
// // // //       title: "المكسيك",
// // // //       children: [
// // // //         DropdownItem(id: 5, title: "ججج"),
// // // //         DropdownItem(id: 6, title: "ررر"),
// // // //       ],
// // // //     ),
// // // //     DropdownItem(id: 7, title: "آسيا"),
// // // //     DropdownItem(id: 8, title: "أوروبا"),
// // // //     DropdownItem(
// // // //       id: 9,
// // // //       title: "زين",
// // // //       children: [
// // // //         DropdownItem(id: 10, title: "١١"),
// // // //         DropdownItem(id: 11, title: "٢٢٢"),
// // // //         DropdownItem(id: 12, title: "٣٣٣"),
// // // //         DropdownItem(id: 13, title: "٤٤٤٤"),
// // // //       ],
// // // //     ),
// // // //     DropdownItem(id: 14, title: "أمريكا الجنوبية"),
// // // //   ];
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(),
// // // //       body: Padding(
// // // //         padding: const EdgeInsets.all(16.0),
// // // //         child: CustomDropdown(
// // // //           items: items,
// // // //           isMultiSelect: false,
// // // //           chipDisplayMode:
// // // //               ChipDisplayMode.scrollableRow, // التحكم في طريقة العرض
// // // //           onChanged: (selectedItems) {
// // // //             print(
// // // //                 "Selected items: ${selectedItems.map((e) => e.title).join(", ")}");
// // // //           },
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
