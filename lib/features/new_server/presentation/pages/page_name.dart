import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../viewModel/controller.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: BlocProvider(
        create: (context) => ProductCubit()..getProducts(),
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              return ListView.builder(
                itemCount: state.products.data!.section.length,
                itemBuilder: (context, index) {
                  final product = state.products.data!.section[index];
                  return ListTile(
                    title: Text(product.titleAr),
                    subtitle: Text('\$${product.titleAr}'),
                  );
                },
              );
            } else if (state is ProductError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return Center(child: Text('No products found'));
            }
          },
        ),
      ),
    );
  }
}
