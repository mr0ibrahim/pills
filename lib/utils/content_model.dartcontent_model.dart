class UnbordingContent {
  String? image;
  String? title;
  String? discription;

  UnbordingContent({this.image, this.title, this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
    title: 'متابعة الأدوية',
    image: 'assets/images/pil.png',
    discription: "هذا التطبيق يساعدك على متابعة أدويتك بدقة، وتسجيل أوقات الجرعات المطلوبة لضمان صحتك وسلامتك.",
  ),
  UnbordingContent(
    title: 'تنبيهات الجرعات',
    image: 'assets/images/pil.png',
    discription: "استقبل تنبيهات عند مواعيد الجرعات لضمان عدم تفويت أي منها.",
  ),
  UnbordingContent(
    title: 'تاريخ الجرعات',
    image: 'assets/images/pil.png',
    discription: "قم بتسجيل تاريخ الجرعات لتتمكن من مراجعة الأوقات التي تناولت فيها أدويتك.",
  ),
];
