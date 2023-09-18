import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/theme.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:accordion/accordion.dart';

class V2HelpView extends StatefulWidget {
  const V2HelpView({Key? key}) : super(key: key);

  @override
  _V2HelpViewState createState() => _V2HelpViewState();
}

class _V2HelpViewState extends State<V2HelpView> {
  bool _isLoading = false;
  int _selectedIndex = 2;
  MyThemeColors get _myThemeColors =>
      Theme.of(context).extension<MyThemeColors>()!;
  final CarouselController _carouselController = CarouselController();
  int _carouselCurrent = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    abV2GotoBottomNavigationForHomePage(index, -1);
  }

  Widget getContent() {
    final List<String> videoList = [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    ];
    final List<List<String>> faqList = [
      [
        "Lorem Ipsum Sit Dolor?",
        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum"
      ],
      [
        "Lorem Ipsum Sit Dolor?",
        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum"
      ],
      [
        "Lorem Ipsum Sit Dolor?",
        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum"
      ],
      [
        "Lorem Ipsum Sit Dolor?",
        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum"
      ],
    ];
    List<Widget> carouselItems = videoList
        .map((item) => FlickVideoPlayer(
                flickManager: FlickManager(
              autoPlay: false,
              videoPlayerController: VideoPlayerController.network(item),
            )))
        .toList();

    Widget videoTutorials = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Video Tutorials',
          style: MyFonts.regular(20, color: _myThemeColors.primary),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 18),
        CarouselSlider(
          items: carouselItems,
          carouselController: _carouselController,
          options: CarouselOptions(
              // autoPlay: true,
              // enlargeCenterPage: true,
              aspectRatio: 2.0,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _carouselCurrent = index;
                });
              }),
        ),
        SizedBox(height: 8),
        AnimatedSmoothIndicator(
          activeIndex: _carouselCurrent,
          count: videoList.length,
          onDotClicked: (int index) => _carouselController.animateToPage(index),
          effect: CustomizableEffect(
            activeDotDecoration: DotDecoration(
              width: 6,
              height: 6,
              color: _myThemeColors.primary!,
              borderRadius: BorderRadius.circular(24),
              dotBorder: DotBorder(
                padding: 3,
                width: 1,
                color: _myThemeColors.primary!,
              ),
            ),
            dotDecoration: DotDecoration(
              width: 6,
              height: 6,
              color: _myThemeColors.primary!,
              borderRadius: BorderRadius.circular(16),
              verticalOffset: 0,
            ),
            spacing: 6.0,
          ),
        ),
      ],
    );

    final _headerStyle = TextStyle(
        color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
    final _headerStyleSmall = TextStyle(
        color: Color(0xffffffff), fontSize: 12, fontWeight: FontWeight.bold);
    final _contentStyleHeader = TextStyle(
        color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
    final _contentStyle = TextStyle(
        color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
    final _loremIpsum =
        '''In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available. It is also used to temporarily replace text in a process called greeking, which allows designers to consider the form of a webpage or publication, without the meaning of the text influencing the design.''';
    final _loremIpsum2 =
        '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';

    List<AccordionSection> accordionItems = faqList
        .map((item) => AccordionSection(
              isOpen: true,
              header: Text(item[0], style: MyFonts.medium(14)),
              content: Text(item[1],
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      height: 2)),
              contentBorderColor: MyColors.lightGrey,
            ))
        .toList();

    Widget faq = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'FAQ',
          style: MyFonts.regular(20, color: _myThemeColors.primary),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 18),
        Accordion(
          maxOpenSections: 1,
          rightIcon: Icon(Icons.expand_more, color: Color(0xFF002F60)),
          headerBorderRadius: 6,
          headerBackgroundColor: MyColors.v2AccordionHeader,
          headerPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          children: accordionItems,
        ),
      ],
    );
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 24),
            abV2PrimaryButton('Live Chat', onTap: () => {}, fullWidth: true),
            SizedBox(height: 42),
            videoTutorials,
            SizedBox(height: 36),
            faq
          ],
        ));
  }

  PreferredSizeWidget getAppBar() {
    return abV2AppBar(context, 'v2_help_view_appbar_title'.tr);
  }

  @override
  Widget build(BuildContext context) {
    return abV2MainWidgetWithLoadingOverlayScaffoldScrollView(
        context, _isLoading,
        appBar: getAppBar(),
        content: getContent(),
        bottomNavigationBar:
            abV2BottomNavigationBarB(_selectedIndex, _onItemTapped));
  }
}
