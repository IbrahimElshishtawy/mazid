import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazid/pages/home/controller/home_controller.dart';

class HomeUI extends StatelessWidget {
  const HomeUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        if (controller.isLoading || controller.isUserLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return _buildHomePage(controller);
      },
    );
  }

  Widget _buildHomePage(HomeController controller) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Column(
        children: [
          /// ✅ عرض رسالة الخطأ فقط لو موجودة
          if (controller.errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                controller.errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),

          /// بقية محتوى الصفحة
          Expanded(
            child: ListView.builder(
              itemCount: controller.filteredProducts.length,
              itemBuilder: (context, index) {
                final product = controller.filteredProducts[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.description),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
