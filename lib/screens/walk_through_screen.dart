import '../utils/shared_import.dart';

class WalkThroughScreen extends StatefulWidget {
  const WalkThroughScreen({super.key});

  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController mPageController = PageController();

  List<WalkThroughModel> mWalkList = [];
  int mCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
    mWalkList.add(WalkThroughModel(image: ic_walk1, title: walk1Title));
    mWalkList.add(WalkThroughModel(image: ic_walk2, title: walk2Title));
    mWalkList.add(WalkThroughModel(image: ic_walk3, title: walk3Title));
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    mPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion(
    value: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: appStore.isDarkMode
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarIconBrightness: appStore.isDarkMode
          ? Brightness.light
          : Brightness.dark,
    ),
    child: Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: context.statusBarHeight + 30,
            left: mq.width * 0.055,
            right: mq.width * 0.055,
            child: Image.asset(
              ic_walk_shape,
              height: context.height() * 0.43,
              width: context.width(),
              fit: BoxFit.fill,
            ),
          ),
          PageView(
            controller: mPageController,
            children: mWalkList
                .map(
                  (e) => Column(
                    children: [
                      Image.asset(
                        mWalkList[mCurrentIndex].image!,
                        height: context.height() * 0.55,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ).paddingTop(context.statusBarHeight + 30),
                )
                .toList(),
            onPageChanged: (i) {
              mCurrentIndex = i;
              setState(() {});
            },
          ),
          Positioned(
            top: context.statusBarHeight,
            right: mq.width * 0.010,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                setValue(IS_FIRST_TIME, true);
                if (userStore.loginRequired) {
                  const SignInScreen(showBack: false,).launch<void>(context);
                } else {
                  const DashboardScreen().launch<void>(context);
                }
              },
              child: Text(
                languages.lblSkip,
                style: boldTextStyle(color: primaryColor),
              ),
            ),
          ).visible(mCurrentIndex != 2),
          Positioned(
            right: 24,
            left: 24,
            bottom: 50,
            child: Column(
              children: [
                Text(
                  mWalkList[mCurrentIndex].title.toString(),
                  style: boldTextStyle(size: 22),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: mq.height * 0.020),
                // 16.height,
                dotIndicator(mWalkList, mCurrentIndex),
                //30.height,
                SizedBox(height: mq.height * 0.038),

                AppButton(
                  text: mCurrentIndex == 2
                      ? languages.lblGetStarted
                      : languages.lblNext,
                  width: context.width(),
                  color: primaryColor,
                  onTap: () {
                    if (mCurrentIndex.toInt() >= 2) {
                      setValue(IS_FIRST_TIME, true);
                      if (userStore.loginRequired) {
                        const SignInScreen(showBack: false,).launch<void>(context);
                      } else {
                        const DashboardScreen().launch<void>(context);
                      }
                    } else {
                      mPageController.nextPage(
                        duration: const Duration(seconds: 1),
                        curve: Curves.linearToEaseOut,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
