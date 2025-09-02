import 'package:flutter/material.dart';

class SwapFlowDetailPage extends StatefulWidget {
  final Map<String, dynamic> product; // بيانات المنتج المختار

  const SwapFlowDetailPage({super.key, required this.product});

  @override
  State<SwapFlowDetailPage> createState() => _SwapFlowDetailPageState();
}

class _SwapFlowDetailPageState extends State<SwapFlowDetailPage> {
  int currentStep = 0;

  String? senderProductImage;
  double priceDifference = 0.0;
  bool isApproved = false;
  bool isSwapCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text("تبادل: ${widget.product['name']}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildStepContent(),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildWaitingApproval();
      case 1:
        return _buildUploadSenderProduct();
      case 2:
        return _buildPriceDifferenceStep();
      case 3:
        return _buildSwapCompleteStep();
      default:
        return const Center(child: Text("خطأ في النظام"));
    }
  }

  // المرحلة 1: انتظار موافقة الطرف الآخر
  Widget _buildWaitingApproval() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "في انتظار موافقة الطرف الآخر...",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isApproved = true;
              currentStep = 1;
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
          child: const Text(
            "تمت الموافقة (تجريبي)",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  // المرحلة 2: رفع صورة المنتج الخاص بك
  Widget _buildUploadSenderProduct() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "ارفع صورة منتجك الذي تريد تبديله:",
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              senderProductImage = "https://via.placeholder.com/100";
            });
          },
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(12),
            ),
            child: senderProductImage != null
                ? Image.network(senderProductImage!)
                : const Icon(Icons.add_a_photo, color: Colors.white, size: 40),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: senderProductImage == null
              ? null
              : () {
                  setState(() {
                    currentStep = 2;
                  });
                },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
          child: const Text("التالي", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  // المرحلة 3: إدخال فرق السعر
  Widget _buildPriceDifferenceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "أدخل فرق السعر إذا وجد:",
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: "0.0",
            filled: true,
            fillColor: Colors.grey.shade800,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              priceDifference = double.tryParse(value) ?? 0.0;
            });
          },
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isSwapCompleted = true;
                currentStep = 3;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
            ),
            child: const Text(
              "تأكيد الطلب",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  // المرحلة 4: اكتمال التبادل وأزرار التواصل
  Widget _buildSwapCompleteStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "تم اكتمال عملية التبادل!",
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            // فتح WhatsApp
            print("فتح WhatsApp العميل");
          },
          icon: const Icon(Icons.chat, color: Colors.white),
          label: const Text("WhatsApp", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            // فتح Telegram
            print("فتح Telegram العميل");
          },
          icon: const Icon(Icons.send, color: Colors.white),
          label: const Text("Telegram", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
        ),
      ],
    );
  }
}

// --- الصفحة الرئيسية لعرض المنتجات ---
class SwapProductListPage extends StatelessWidget {
  SwapProductListPage({super.key});

  final List<Map<String, dynamic>> products = [
    {
      "id": "prod1",
      "name": "منتج A",
      "image": "https://via.placeholder.com/100",
    },
    {
      "id": "prod2",
      "name": "منتج B",
      "image": "https://via.placeholder.com/100",
    },
    {
      "id": "prod3",
      "name": "منتج C",
      "image": "https://via.placeholder.com/100",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text("منتجات للتبادل"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade900.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade700, width: 1),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Image.network(product['image'], width: 70, height: 70),
              title: Text(
                product['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SwapFlowDetailPage(product: product),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                ),
                child: const Text("طلب التبادل"),
              ),
            ),
          );
        },
      ),
    );
  }
}
