enum SwapStatus {
  myProducts,

  /// my product [المنتجات الي انا منزله الي هيشوفها كل المستخدمين ]
  accepted,

  /// accept swap broduct [هنا هيرمي  سوال هل انت موافق علي التبعديل ولا الا]
  pending,

  /// wait accept product swap [هنا المنتج هيروح لي صفحة الانتظار الي يشوفها المشتري ]
  request,

  /// accept and reject swap [هنا هيكون فيها امرين ي يببل المقيضه علشان ادخل علي صفحةالتفواض او المقابله في  صفحة التفواض ]
  completed,

  /// compelete process [هنا هيكون صفحة السجل العمليات ]
  approved,

  /// accept seles product swap [هنا المستخدم المنتج كد اتوافق عليها  هيرعض يدخل الصفحه ]
  other, // حالة افتراضية/أخرى
}
