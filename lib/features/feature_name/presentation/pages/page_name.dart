import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

import '../../data/models/model_name.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../cubit/cubit.dart';
import '../cubit/state.dart';

class FilterForm extends StatefulWidget {
  @override
  _FilterFormState createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController categoryIdController = TextEditingController();
  final TextEditingController targetIdController = TextEditingController();
  AdvancedFilterManager filterManager = AdvancedFilterManager();
  // ProductController? bloc;

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  void sendRequest() async {
    String jsonData = filterManager.toJson();
    print('Sending data: $jsonData');
  }

  void handleSubmit() {
    filterManager.clearFilters();
    if (fromDateController.text.isNotEmpty) {
      filterManager.addFilter("fromDateTimeString", fromDateController.text);
    }
    if (toDateController.text.isNotEmpty) {
      filterManager.addFilter("toDateTimeString", toDateController.text);
    }
    if (categoryIdController.text.isNotEmpty) {
      filterManager.addFilter("categoryId", categoryIdController.text);
    }
    if (targetIdController.text.isNotEmpty) {
      filterManager.addFilter("targetId", targetIdController.text);
    }
    sendRequest();
  }

  void handleRefresh() async {
    filterManager.clearFilters();
    String jsonData = filterManager.toJson();
    print('Sending data: $jsonData');
  }

  Set<ProductModel> selectedProductsTow = {};
  RegisterBloc registerBloc = KiwiContainer().resolve<RegisterBloc>();
  ProductController bloc = KiwiContainer().resolve<ProductController>();

  @override
  void initState() {
    bloc.getData();

    super.initState();
  }

  List<Place> myList = [];
  var map1 = {};
  void dataaa() {
    setState(() {
      myList.clear();
      map1 = {};
      // myList.add(Place(id: 1, title: "Paul"));
      // myList.add(Place(id: 2, title: "Paul"));
      // myList.add(Place(id: 3, title: "Paul"));
      myList.add(Place(id: 4, title: "Paul"));
    });

    // myList.forEach((Student) => map1[Student.id] = Student.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          switch (state.runtimeType) {
            case ProductStateSuccess:
              final successState = state as ProductStateSuccess;
              return Scaffold(
                appBar: AppBar(
                  title: Text('Filter Form'),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: fromDateController,
                        decoration: InputDecoration(
                          labelText: 'From Date (ISO 8601 format)',
                        ),
                      ),
                      TextField(
                        controller: toDateController,
                        decoration: InputDecoration(
                          labelText: 'To Date (ISO 8601 format)',
                        ),
                      ),
                      TextField(
                        controller: categoryIdController,
                        decoration: InputDecoration(
                          labelText: 'Category ID',
                        ),
                      ),
                      TextField(
                        controller: targetIdController,
                        decoration: InputDecoration(
                          labelText: 'Target ID',
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: successState.model != null
                      //       ? MultiSelectDropDown<int>(
                      //           onOptionSelected: (List<ValueItem<int>>
                      //               selectedOptions) async {
                      //             Set<int?> selectedIds = selectedOptions
                      //                 .map((item) => item.value)
                      //                 .toSet();
                      //             // selectedProductsTow = successState.model!.data
                      //             //     .where((product) =>
                      //             //         selectedIds.contains(product.id))
                      //             //     .cast<ProductModel>()
                      //             //     .toSet();
                      //           },
                      //           options: successState.model.data
                      //               .map((product) => ValueItem(
                      //                   label: product.name, value: product.id))
                      //               .toList(),
                      //           selectionType: SelectionType.multi,
                      //           chipConfig:
                      //               const ChipConfig(wrapType: WrapType.scroll),
                      //           dropdownHeight: 300,
                      //           optionTextStyle: const TextStyle(fontSize: 16),
                      //           selectedOptionIcon:
                      //               const Icon(Icons.check_circle),
                      //         )
                      //       : const SizedBox.shrink(),
                      // ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filterManager.filteredDataList.length,
                          itemBuilder: (context, index) {
                            final data = filterManager.filteredDataList[index];
                            return ListTile(
                              title: Text(data.name),
                              subtitle: Text(data.id),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          BlocBuilder(
                            bloc: registerBloc,
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () {
                                  registerBloc.add(RegisterStartEvents());
                                  // showMessage(context);
                                },
                                child: Text('Delete User'),
                              );
                            },
                          ),
                          // ElevatedButton(
                          //   onPressed: handleSubmit,
                          //   child: Text('Send Data'),
                          // ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                dataaa();
                                final data = myList.forEach((Student) =>
                                    map1[Student.id] = Student.title);

                                print(">>>>>>>>> $map1");

                                handleRefresh();
                              });
                            },
                            child: Text('Refresh'),
                          ),
                          BlocBuilder(
                            bloc: registerBloc,
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () {
                                  bloc.getData();
                                },
                                child: Text('Delete User'),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            case ProductStateStart:
              return Center(child: CircularProgressIndicator());
            case ProductStateFailed:
              final stateFailed = state as ProductStateFailed;
              return Center(child: Text(stateFailed.msg));
            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  ProductModel? model;
// Future<void> showMessage(BuildContext context) async {
//   bool isAccepted = await deleteDialog(context);
//   context.read<DeleteData>().deleteData();
//
//   if (isAccepted) {
//     if (!mounted) return;
//     showDialog(
//       context: navigator.currentContext!,
//       builder: (_) {
//         return BlocProvider(
//           create: (context) => DeleteData(),
//           child: BlocBuilder(
//             bloc: DeleteData(),
//             builder: (context, state) {
//               switch (state) {
//                 case DeleteDataStat:
//                   return const SizedBox.shrink();
//                 case DeleteFromCartLoadingState:
//                   return const ProgressDialog(
//                     title: "Deleting user...",
//                     isProgressed: true,
//                   );
//                 case DeleteFromCartFailedState:
//                   return RetryDialog(
//                     title: "Error",
//                     onRetryPressed: () {
//                       context.read<DeleteData>().deleteData();
//                     },
//                   );
//                 case DeleteFromCartSuccessState:
//                   return ProgressDialog(
//                     title: "Successfully deleted",
//                     onPressed: () {
//                       context.read<ProductController>().getData();
//                       Navigator.pop(context);
//                     },
//                     isProgressed: false,
//                   );
//                 default:
//                   return ProgressDialog(
//                     title: "Successfully deleted",
//                     onPressed: () {
//                       context.read<ProductController>().getData();
//                       Navigator.pop(context);
//                     },
//                     isProgressed: false,
//                   );
//               }
//             },
//           ),
//         );
//       },
//     );
//   }
// }
}

class AdvancedFilterManager {
  List<Map<String, dynamic>> advancedFilter = [];
  List<FilteredData> filteredDataList = [];

  void addFilter(String parameterName, String parameterValue) {
    advancedFilter.add({
      "parameterzName": parameterName,
      "parameterzValue": parameterValue,
      "condition": 0,
      "operation": 0,
    });
    for (int i = 0; i < advancedFilter.length; i++) {
      advancedFilter[i]["condition"] = i == 0 ? 0 : 1;
    }
  }

  dynamic toJson() {
    Map<String, dynamic> data = {
      "advancedFilter": advancedFilter,
    };
    return json.encode(data);
  }

  void clearFilters() {
    advancedFilter.clear();
  }

  void updateFilteredData(List<dynamic> data) {
    filteredDataList = data.map((item) => FilteredData.fromJson(item)).toList();
  }
}

class FilteredData {
  final String id;
  final String name;

  FilteredData({required this.id, required this.name});

  factory FilteredData.fromJson(Map<String, dynamic> json) {
    return FilteredData(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Place {
  final int id;
  final String title;

  Place({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

class Product {
  final int productId;
  final int buyQuantity;
  final int productPrice;
  final int isVoucher;

  Product({
    required this.productId,
    required this.buyQuantity,
    required this.productPrice,
    required this.isVoucher,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'buy_quantity': buyQuantity,
      'product_price': productPrice,
      'is_voucher': isVoucher,
    };
  }
}

class ApiService {
  Future<void> sendProducts(List<ProductModel> products) async {
    // final ddd = products.map((product) => product.toJson()).toList();
    // final data = jsonEncode(ddd);
    // print(">>>>>>>>>>> $data");
  }
}
