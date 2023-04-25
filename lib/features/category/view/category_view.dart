import 'package:amazon_clone/core/constant/constants.dart';
import 'package:amazon_clone/features/category/controller/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common/loader.dart';
import '../../../models/product.dart';

class CategoryDealsScreen extends ConsumerStatefulWidget {
  final String category;
  const CategoryDealsScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  ConsumerState<CategoryDealsScreen> createState() =>
      _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends ConsumerState<CategoryDealsScreen> {
  List<Product>? productList;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        fetchCategoryProducts();
      }
    });
  }

  fetchCategoryProducts() async {
    ref.read(categoryControllerProvider.notifier).fetchCategoryProducts(
          widget.category,
          context,
        );
  }

  void navigateToDetaillScreen() {
    GoRouter.of(context).push("/product-detail");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppConsts.appBarGradient,
            ),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: ref.watch(categoryControllerProvider).when(data: (productList) {
        if (productList == null) {
          return const Text("No data");
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              alignment: Alignment.topLeft,
              child: Text(
                'Keep shopping for ${widget.category}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 170,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 15),
                itemCount: productList!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.4,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final product = productList![index];
                  return GestureDetector(
                    onTap: navigateToDetaillScreen,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 130,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 0.5,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.network(
                                product.images[0],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(
                            left: 0,
                            top: 5,
                            right: 15,
                          ),
                          child: Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }, error: ((error, stackTrace) {
        return Center(
          child: Text(error.toString()),
        );
      }), loading: () {
        return const Loader();
      }),
    );
  }
}
