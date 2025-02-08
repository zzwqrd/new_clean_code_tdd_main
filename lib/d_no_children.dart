import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

class DropdownItem {
  final String title;
  final int id;
  bool isSelected;

  DropdownItem({
    required this.title,
    required this.id,
    this.isSelected = false,
  });
}

enum ChipDisplayMode { wrap, scrollableRow }

class CustomDropdown extends StatefulWidget {
  final List<DropdownItem> items;
  final bool isMultiSelect;
  final ChipDisplayMode chipDisplayMode;
  final ValueChanged<dynamic> onChanged;
  final String hintText;
  final bool isLoading;
  final dynamic value;

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

    return selectedValues.isEmpty ? 60.0 : (numRows * 40.0) + 20;
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

  Widget _buildDropdownItem(DropdownItem item) {
    return ListTile(
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
          color: selectedValues.contains(item) ? Colors.green : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: widget.isLoading
          ? null
          : () {
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
            },
    );
  }

  void _clearSelections() {
    for (var item in widget.items) {
      item.isSelected = false;
    }
  }
}

abstract class DropdownState {}

class DropdownLoading extends DropdownState {}

class DropdownLoaded extends DropdownState {
  final List<DropdownItem> items;
  final DropdownItem? selectedItem; // عنصر مفرد مختار

  DropdownLoaded(this.items, {this.selectedItem});
}

class DropdownLoadedMulti extends DropdownState {
  final List<DropdownItem> items;
  final List<DropdownItem> selectedItems; // قائمة العناصر المختارة

  DropdownLoadedMulti(this.items, {this.selectedItems = const []});
}

// class DropdownCubit extends Cubit<DropdownState> {
//   DropdownCubit() : super(DropdownLoading());
//
//   final List<DropdownItem> dataSelected = [
//     DropdownItem(id: 9, title: "زين"),
//     DropdownItem(id: 3, title: "كوبا"),
//     DropdownItem(id: 5, title: "ججج"),
//     DropdownItem(id: 6, title: "ررر"),
//     DropdownItem(id: 12, title: "٣٣٣"),
//     DropdownItem(id: 13, title: "٤٤٤٤"),
//     DropdownItem(id: 14, title: "أمريكا الجنوبية"),
//   ];
//
//   Future<void> fetchData() async {
//     emit(DropdownLoading());
//     await Future.delayed(Duration(seconds: 2));
//
//     final fetchedItems = [
//       DropdownItem(id: 1, title: "أمريكا الشمالية"),
//       DropdownItem(id: 2, title: "الولايات المتحدة الأمريكية"),
//       DropdownItem(id: 3, title: "كوبا"),
//       DropdownItem(id: 4, title: "المكسيك"),
//       DropdownItem(id: 5, title: "ججج"),
//       DropdownItem(id: 6, title: "ررر"),
//       DropdownItem(id: 7, title: "آسيا"),
//       DropdownItem(id: 8, title: "أوروبا"),
//       DropdownItem(id: 9, title: "زين"),
//       DropdownItem(id: 10, title: "١١"),
//       DropdownItem(id: 11, title: "٢٢٢"),
//       DropdownItem(id: 12, title: "٣٣٣"),
//       DropdownItem(id: 13, title: "٤٤٤٤"),
//       DropdownItem(id: 14, title: "أمريكا الجنوبية"),
//     ];
//
//     List<DropdownItem> selectedItems = [];
//     for (var item in fetchedItems) {
//       for (var selectedItem in dataSelected) {
//         if (item.id == selectedItem.id) {
//           item.isSelected = true;
//           selectedItems.add(item);
//         }
//       }
//     }
//
//     emit(DropdownLoaded(fetchedItems, selectedItems: selectedItems));
//   }
// }

class DropdownCubit extends Cubit<DropdownState> {
  DropdownCubit() : super(DropdownLoading());

  final DropdownItem dataSelectedSingle = DropdownItem(id: 9, title: "زين");
  final List<DropdownItem> dataSelectedMulti = [
    DropdownItem(id: 9, title: "زين"),
    DropdownItem(id: 3, title: "كوبا"),
    DropdownItem(id: 5, title: "ججج"),
    DropdownItem(id: 6, title: "ررر"),
    DropdownItem(id: 12, title: "٣٣٣"),
    DropdownItem(id: 13, title: "٤٤٤٤"),
    DropdownItem(id: 14, title: "أمريكا الجنوبية"),
  ];

  Future<void> fetchData({bool isMultiSelect = false}) async {
    emit(DropdownLoading());
    await Future.delayed(Duration(seconds: 2));

    final fetchedItems = [
      DropdownItem(id: 1, title: "أمريكا الشمالية"),
      DropdownItem(id: 2, title: "الولايات المتحدة الأمريكية"),
      DropdownItem(id: 3, title: "كوبا"),
      DropdownItem(id: 4, title: "المكسيك"),
      DropdownItem(id: 5, title: "ججج"),
      DropdownItem(id: 6, title: "ررر"),
      DropdownItem(id: 7, title: "آسيا"),
      DropdownItem(id: 8, title: "أوروبا"),
      DropdownItem(id: 9, title: "زين"),
      DropdownItem(id: 10, title: "١١"),
      DropdownItem(id: 11, title: "٢٢٢"),
      DropdownItem(id: 12, title: "٣٣٣"),
      DropdownItem(id: 13, title: "٤٤٤٤"),
      DropdownItem(id: 14, title: "أمريكا الجنوبية"),
    ];

    if (isMultiSelect) {
      List<DropdownItem> selectedItems = [];
      for (var item in fetchedItems) {
        for (var selectedItem in dataSelectedMulti) {
          if (item.id == selectedItem.id) {
            item.isSelected = true;
            selectedItems.add(item);
          }
        }
      }
      emit(DropdownLoadedMulti(fetchedItems, selectedItems: selectedItems));
    } else {
      DropdownItem? selectedItem;
      for (var item in fetchedItems) {
        if (item.id == dataSelectedSingle.id) {
          item.isSelected = true;
          selectedItem = item;
          break;
        }
      }

      emit(DropdownLoaded(fetchedItems, selectedItem: selectedItem));
    }
  }

  // دالة لتحديد عنصر مفرد
  void selectItem(DropdownItem selectedItem) {
    final currentState = state;
    if (currentState is DropdownLoaded) {
      emit(DropdownLoaded(
        currentState.items,
        selectedItem: selectedItem,
      ));
    }
  }

  // دالة لتحديد عناصر متعددة
  void selectMultipleItems(List<DropdownItem> selectedItems) {
    final currentState = state;
    if (currentState is DropdownLoadedMulti) {
      emit(DropdownLoadedMulti(
        currentState.items,
        selectedItems: selectedItems,
      ));
    }
  }
}

class DropdownScreen extends StatefulWidget {
  @override
  _DropdownScreenState createState() => _DropdownScreenState();
}

class _DropdownScreenState extends State<DropdownScreen> {
  final _formKey = GlobalKey<FormState>();
  final bloc = KiwiContainer().resolve<DropdownCubit>();

  @override
  void initState() {
    super.initState();
    bloc.fetchData(); // استدعاء جلب البيانات هنا
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Drop Multi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder(
          bloc: bloc,
          builder: (context, state) {
            if (state is DropdownLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DropdownLoaded) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomDropdownFormField(
                      items: state.items,
                      isEnabled: true,
                      isLoading: false,
                      selectedValue: state.selectedItem,
                      onChanged: (item) {
                        print("Selected: ${item?.id}");
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Field can\'t be empty';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          print('Form is valid');
                        } else {
                          print('Form is invalid');
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text("خطأ في تحميل البيانات"));
            }
          },
        ),
      ),
    );
  }
}

class CustomDropdownFormField extends FormField<DropdownItem> {
  final List<DropdownItem> items;
  final ValueChanged<DropdownItem?>? onChanged;
  final bool isEnabled;
  final bool isLoading;
  final DropdownItem? selectedValue;

  CustomDropdownFormField({
    Key? key,
    required this.items,
    this.onChanged,
    this.isEnabled = true,
    this.isLoading = false,
    this.selectedValue,
    FormFieldValidator<DropdownItem?>? validator,
  }) : super(
          key: key,
          initialValue: selectedValue,
          validator: validator,
          builder: (FormFieldState<DropdownItem?> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomDropdown(
                  items: items,
                  isLoading: isLoading,
                  isMultiSelect: false,
                  value: selectedValue,
                  onChanged: (value) {
                    state.didChange(value);
                    if (onChanged != null) {
                      onChanged!(value);
                    }
                  },
                ),
                if (state.hasError)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}
// class DropdownScreen extends StatefulWidget {
//   @override
//   _DropdownScreenState createState() => _DropdownScreenState();
// }
//
// class _DropdownScreenState extends State<DropdownScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Drop Multi"),
//       ),
//       body: BlocProvider(
//         create: (context) => DropdownCubit()..fetchData(),
//         child: BlocBuilder<DropdownCubit, DropdownState>(
//           builder: (context, state) {
//             if (state is DropdownLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is DropdownLoaded) {
//               return Form(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 200,
//                       child: CustomDropdown(
//                         items: state.items,
//                         isMultiSelect: false,
//                         chipDisplayMode: ChipDisplayMode.scrollableRow,
//                         hintText: "اختر منتجًا",
//                         isLoading: false, // state is DropdownLoading
//                         value: state.selectedItem,
//                         onChanged: (selectedItems) {
//                           context.read<DropdownCubit>().emit(DropdownLoaded(
//                                 state.items,
//                                 selectedItem: selectedItems,
//                               ));
//                           context
//                               .read<DropdownCubit>()
//                               .emit(DropdownLoadedMulti(
//                                 state.items,
//                                 selectedItems: selectedItems,
//                               ));
//
//                           setState(() {});
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             } else {
//               return const Center(child: Text("خطأ في تحميل البيانات"));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
