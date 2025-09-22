// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mazid/pages/Auction/home/auction_home_page.dart';

class AuctionTermsPage extends StatefulWidget {
  const AuctionTermsPage({super.key}); // صفحة مستقلة عادية

  @override
  _AuctionTermsPageState createState() => _AuctionTermsPageState();
}

class _AuctionTermsPageState extends State<AuctionTermsPage> {
  bool accepted = false;
  bool _checking = true; // لتحضير فحص أول مرة

  String _prefsKeyForUser() {
    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      return 'auction_terms_accepted_${uid ?? 'global'}';
    } catch (_) {
      // في حال Supabase لسه مش متهيّأ
      return 'auction_terms_accepted_global';
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyAccepted();
  }

  Future<void> _checkIfAlreadyAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _prefsKeyForUser();
    final hasAccepted = prefs.getBool(key) ?? false;

    if (!mounted) return;
    if (hasAccepted) {
      // المستخدم وافق قبل كده → نروح مباشرة للهوم
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuctionHomePage()),
        );
      });
    } else {
      setState(() => _checking = false);
    }
  }

  Future<void> _acceptTerms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      _prefsKeyForUser(),
      true,
    ); // حفظ الموافقة للمستخدم الحالي

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuctionHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: const Text('''
شروط وأحكام المزايدة:

1. التسجيل والمشاركة: للمشاركة في أي مزاد داخل هذا التطبيق، يجب على المستخدم أن يكون مسجلاً ومصدقًا على حسابه بشكل كامل. عملية التسجيل تهدف إلى ضمان نزاهة المزادات ومنع أي استخدام احتيالي للحسابات الوهمية، كما تساعد في متابعة الفائزين بالمزايدات ومحاسبتهم عند الحاجة.

2. الالتزام بالمزايدة: جميع المزايدات المقدمة من قبل المستخدمين تُعد ملزمة بشكل كامل بعد إرسالها. لا يمكن التراجع عن أي مزايدة بمجرد تقديمها، وذلك لضمان العدالة لجميع المشاركين والحفاظ على نزاهة المزاد. الالتزام بالمزايدة يعكس احترام المستخدم للقوانين والشروط المتفق عليها.

3. الحد الأدنى للمزايدة: يجب على كل مستخدم الالتزام بالحد الأدنى المحدد للمزايدة كما هو معلن في صفحة المزاد. أي مزايدة دون هذا الحد لن يتم قبولها ولن تؤثر على سير المزاد، وذلك لضمان الشفافية والجدية في جميع العمليات.

4. انتهاء المزاد: يتم إغلاق المزاد تلقائيًا عند انتهاء الوقت المحدد له. لا يتم قبول أي مزايدة بعد هذا الوقت، ويجب على جميع المستخدمين متابعة الوقت والتأكد من تقديم مزايدتهم في الوقت المناسب لضمان المشاركة الفعلية.

5. المسؤولية عن النتائج: استخدام التطبيق يتم على مسؤولية المستخدم الخاصة. التطبيق غير مسؤول عن أي خسائر مالية قد تحدث نتيجة سوء فهم أو أي معاملات خارج نطاق استخدامه المباشر. يجب على المستخدمين أخذ الحيطة والحذر في كل عملية مزايدة يشاركون بها.

6. الالتزام بالدفع: عند الفوز بأي مزاد، يلتزم الفائز بدفع قيمة المزاد كاملة خلال 24 ساعة من انتهاء المزاد. عدم الالتزام بالدفع قد يؤدي إلى منع المستخدم من المشاركة في مزادات مستقبلية، بالإضافة إلى اتخاذ الإجراءات القانونية المناسبة لضمان الحقوق.

7. الاستخدام المشروع: يحظر تمامًا استخدام التطبيق لأي غرض غير قانوني أو مخالف للشروط والأحكام. أي محاولة للتلاعب بالنظام، أو استخدام برامج خارجية للتأثير على المزاد، تُعد مخالفة جسيمة ويمكن أن تؤدي إلى حظر الحساب واتخاذ الإجراءات القانونية.

8. سلوك المستخدم: على جميع المشاركين الحفاظ على سلوك مهني وأخلاقي أثناء استخدام التطبيق والمشاركة في المزادات. أي إساءة لفظية أو سلوك احتيالي تجاه المشاركين الآخرين أو المنظمين قد يؤدي إلى إيقاف الحساب بشكل دائم.

9. الدقة في البيانات: يجب على المستخدم تقديم معلومات دقيقة وصحيحة عند التسجيل واستخدام التطبيق. أي معلومات خاطئة أو مضللة يمكن أن تؤدي إلى إلغاء حساب المستخدم أو أي مزاد شارك فيه، وذلك حفاظًا على نزاهة النظام.

10. حقوق الملكية: جميع العناصر والمنتجات المعروضة في المزادات هي ملك للبائعين، ويجب على التطبيق التحقق من صحة ملكية كل عنصر قبل قبول مزايداته. التلاعب أو تقديم عناصر غير قانونية يعرض المستخدم للمساءلة القانونية.

11. التعديلات على المزاد: يجوز للتطبيق تعديل أي مزاد أو إيقافه مؤقتًا لأسباب فنية أو تنظيمية، دون الحاجة لإشعار مسبق للمستخدمين. يتم ذلك لضمان استمرارية عمل التطبيق وكفاءة المزادات.

12. التزامات البائع: البائع مسؤول عن تقديم معلومات دقيقة وشاملة حول المنتجات المعروضة في المزاد، بما في ذلك الصور والوصف والمواصفات، كما يجب عليه تسليم المنتجات للفائز وفق الشروط المتفق عليها.

13. التزامات التطبيق: يهدف التطبيق لتوفير بيئة آمنة وموثوقة للمزايدات، لكنه غير مسؤول عن أي نزاعات تحدث بين المستخدمين خارج نطاق التطبيق. المستخدمون مسؤولون عن التحقق من المعلومات واتخاذ قراراتهم بشكل مستقل.

14. السرية وحماية البيانات: يلتزم التطبيق بحماية بيانات المستخدمين وعدم مشاركتها مع أي جهة خارجية بدون موافقة صريحة. كما يجب على المستخدمين احترام سرية المعلومات وعدم استخدامها لأي أغراض غير قانونية أو مخالفة للشروط.

15. الموافقة: باستخدامك لهذا التطبيق والمشاركة في المزاد، فإنك توافق بشكل كامل على الالتزام بكل ما سبق من شروط وأحكام، وتقر بأنك قرأت وفهمت جميع الفقرات أعلاه وأنك موافق على جميع الالتزامات القانونية والمالية المذكورة.
''', style: TextStyle(color: Colors.white, fontSize: 16, height: 1.8)),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: accepted,
                    onChanged: (value) =>
                        setState(() => accepted = value ?? false),
                    side: const BorderSide(color: Colors.white54),
                    checkColor: Colors.black,
                    activeColor: Colors.white,
                  ),
                  const Expanded(
                    child: Text(
                      "أنا أوافق على الشروط والأحكام",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: accepted ? _acceptTerms : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700),
                  disabledBackgroundColor: Colors.white24,
                  disabledForegroundColor: Colors.black54,
                ),
                child: const Text("ابدأ المزايدة"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
