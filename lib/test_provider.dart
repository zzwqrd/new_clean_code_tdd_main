import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';

import 'core/GenericProviderBuilderNew/GenericProviderBuilderNew.dart';
import 'core/showErrorDialogue/showErrorDialogue.dart';
import 'features/feature_name/data/models/model_name.dart';
import 'features/feature_name/presentation/provider_controller/controller.dart';

class TestProvider extends StatefulWidget {
  const TestProvider({super.key});

  @override
  State<TestProvider> createState() => _TestProviderState();
}

class _TestProviderState extends State<TestProvider> {
  @override
  Widget build(BuildContext context) {
    // الحصول على `DataNotifier` من KiwiContainer
    final provider = KiwiContainer().resolve<DataNotifier>();

    return ChangeNotifierProvider<DataNotifier>(
      create: (context) => provider..getData(), // استدعاء `getData` عند الإنشاء
      child: Scaffold(
        appBar: AppBar(title: Text('Test Provider')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              showErrorDialogue("state.errorMessage");
            });
          },
        ),
        body: Consumer<DataNotifier>(
          builder: (context, notifier, child) {
            return GenericProviderBuilder<DataNotifier, ProductModel>(
              status: notifier.state.status, // تمرير حالة التطبيق
              state: notifier
                  .state.data!, // تمرير البيانات إلى `GenericProviderBuilder`
              context: context,
              progressStatusTitle: "Loading Products...",
              onRetryPressed: () {
                context
                    .read<DataNotifier>()
                    .getData(); // إعادة محاولة جلب البيانات
              },
              successWidget: (context, data) {
                return ListView.builder(
                  itemCount:
                      data.data!.section.length, // عدد العناصر في القائمة
                  itemBuilder: (context, i) {
                    return Center(
                      child: Column(
                        children: [
                          Image.network(
                              data.data!.section[i].image), // عرض الصورة
                          Text(data.data!.section[i].titleAr), // عرض العنوان
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
