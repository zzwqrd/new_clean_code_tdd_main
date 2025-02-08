import 'package:clean_code_tdd_main/select_constructors_multi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultiDropdownScreen extends StatefulWidget {
  @override
  _MultiDropdownScreenState createState() => _MultiDropdownScreenState();
}

class _MultiDropdownScreenState extends State<MultiDropdownScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Multi Select Dropdown"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider(
          create: (context) => DropdownCubit()..fetchMultiSelectData(),
          child: BlocBuilder<DropdownCubit, DropdownState>(
            builder: (context, state) {
              if (state is DropdownLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MultiDropdownLoaded) {
                return MultiSelectDropdown(
                  items: state.items,
                  chipDisplayMode: ChipDisplayMode.wrap,
                  hintText: "اختر عناصر",
                  isLoading: false,
                  value: state.selectedItems, // تمرير العناصر المختارة
                  onChanged: (selectedItems) {
                    context.read<DropdownCubit>().emit(MultiDropdownLoaded(
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

// class SingleDropdownScreen extends StatefulWidget {
//   @override
//   _SingleDropdownScreenState createState() => _SingleDropdownScreenState();
// }
//
// class _SingleDropdownScreenState extends State<SingleDropdownScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Single Select Dropdown"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocProvider(
//           create: (context) => DropdownCubit()..fetchSingleSelectData(),
//           child: BlocBuilder<DropdownCubit, DropdownState>(
//             builder: (context, state) {
//               if (state is DropdownLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is SingleDropdownLoaded) {
//                 return SingleSelectDropdown(
//                   items: state.items,
//                   hintText: "اختر عنصرًا",
//                   isLoading: false,
//                   value: state.selectedItem, // تمرير العنصر المختار
//                   onChanged: (selectedItem) {
//                     context.read<DropdownCubit>().emit(SingleDropdownLoaded(
//                           state.items,
//                           selectedItem: selectedItem,
//                         ));
//                   },
//                 );
//               } else {
//                 return const Center(child: Text("خطأ في تحميل البيانات"));
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// حالات الـ Cubit
abstract class DropdownState {}

class DropdownLoading extends DropdownState {}

class MultiDropdownLoaded extends DropdownState {
  final List<DropdownItem> items;
  final List<DropdownItem> selectedItems;

  MultiDropdownLoaded(this.items, {this.selectedItems = const []});
}

class SingleDropdownLoaded extends DropdownState {
  final List<DropdownItem> items;
  final DropdownItem? selectedItem;

  SingleDropdownLoaded(this.items, {this.selectedItem});
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

  // الدالة لجلب بيانات الاختيار المتعدد
  Future<void> fetchMultiSelectData() async {
    emit(DropdownLoading());

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

    emit(MultiDropdownLoaded(fetchedItems, selectedItems: selectedItems));
  }

  // الدالة لجلب بيانات الاختيار الفردي
  Future<void> fetchSingleSelectData() async {
    emit(DropdownLoading());

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

    // بما أن هذا اختيار فردي، سنختار أول عنصر فقط كعنصر افتراضي
    DropdownItem? selectedItem;
    for (var item in fetchedItems) {
      if (dataSelected.any((selected) => selected.id == item.id)) {
        selectedItem = item;
        break;
      }
    }

    emit(SingleDropdownLoaded(fetchedItems, selectedItem: selectedItem));
  }
}
