import '../components/health_permission_dialog.dart';
import '../service/health_service.dart';
import '../utils/shared_import.dart';

bool? isFirstTimeGraph = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController mScrollController = ScrollController();
  TextEditingController mSearchCont = TextEditingController();
  String? mSearchValue = "";
  final bool _showClearButton = false;
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool shouldShowAds = false;
  StepController stepController = StepController();
  WaterController waterController = WaterController();
  late Future<DashboardResponse?> dashboardFuture;

  @override
  void initState() {
    shouldShowAds =
        userStore.showAdsOnBanner == 1 &&
        userStore.isSubscribe == 0 &&
        !getNativeAdUnitId().isEmptyOrNull;
    Future<void>.delayed(Duration.zero).then((val) {
      log("------------75>>>>${getBoolAsync(CRISP_CHAT_ENABLED)}");
      getUserDetailsApiCall();
      // if (isFirstTimeGraph == false) {
      //   graphGet();
      // }
    });
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: appStore.isDarkMode ? Colors.black : Colors.white,
        statusBarIconBrightness: appStore.isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
    );
    super.initState();
    if (userStore.isLoggedIn) {
      stepController.init();
      waterController.init();
      stepController.start();
    }
    dashboardFuture = getDashboardApi();
    if (Platform.isIOS) {
      Future.delayed(const Duration(seconds: 1), () {
        checkHealthPermission();
      });
    }
  }

  void checkHealthPermission() async {
    bool isAuthorized = await HealthService().hasStepPermission();
    if (!isAuthorized) {
      showHealthPermissionDialog();
    }
  }

  void showHealthPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => HealthPermissionDialog(
        onConnect: () async {
          bool granted = await HealthService().requestHealthPermission();
          if (granted) {
            stepController.syncHealthSteps();
            setState(() {});
          }
        },
      ),
    );
  }
  Future<void> getUserDetailsApiCall() async {
    await getUSerDetail(context, userStore.userId).whenComplete(() {});
  }

  @override
  void dispose() {
    for (final ad in ads.values) {
      ad.dispose();
    }
    ads.clear();
    adLoaded.clear();
    adLoading.clear();
    super.dispose();
  }

  Future<void> init() async {
    final double weightInPounds = userStore.weight.toDouble();
    final double weightInKilograms = poundsToKilograms(weightInPounds);
    final saveWeightGraph = userStore.weightStoreGraph
        .replaceAll('user', '')
        .trim();

    log("------------175>>>>${weightInKilograms.toStringAsFixed(2)}");
    log("------------176>>>>$saveWeightGraph");
    log("------------177>>>>${userStore.weight}");

    //visible(getStringAsync(TERMS_SERVICE).isNotEmpty)
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget mHeading(String? title, {bool? isSeeAll = false, Function? onCall}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? '',
            style: boldTextStyle(size: 18),
          ).paddingSymmetric(horizontal: 16),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(Feather.chevron_right, color: primaryColor),
            onPressed: () {
              onCall!.call();
            },
          ).paddingRight(2),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(
        appStore.selectedLanguageCode == 'ar' ? 100 : 84,
      ),
      child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Observer(
                    builder: (context) =>
                        Container(
                          decoration: boxDecorationWithRoundedCorners(
                            boxShape: BoxShape.circle,
                            border: Border.all(color: primaryColor),
                          ),
                          child: cachedImage(
                            userStore.profileImage.validate(),
                            width: 42,
                            height: 42,
                            fit: BoxFit.cover,
                          ).cornerRadiusWithClipRRect(100).paddingAll(1),
                        ).onTap(() {
                          const EditProfileScreen().launch<void>(context);
                        }),
                  ).visible(userStore.isLoggedIn),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Observer(
                        builder: (context) => Text(
                          "${languages.lblHey}${userStore.fName.validate().capitalizeFirstLetter()} ${userStore.lName.capitalizeFirstLetter()}👋",
                          style: boldTextStyle(size: 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      appStore.selectedLanguageCode == 'ar '
                          ? 0.height
                          : 2.height,
                      Text(
                        languages.lblHomeWelMsg,
                        style: secondaryTextStyle(),
                      ),
                    ],
                  ).expand(),
                ],
              ).expand(),
              Container(
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(16),
                  border: Border.all(
                    color: appStore.isDarkMode
                        ? Colors.white
                        : context.dividerColor.withValues(alpha: 0.9),
                    width: 0.6,
                  ),
                  backgroundColor: appStore.isDarkMode
                      ? context.scaffoldBackgroundColor
                      : Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Image.asset(
                  ic_notification,
                  width: 24,
                  height: 24,
                  color: appStore.isDarkMode ? Colors.white : Colors.grey,
                ),
              ).onTap(() {
                if (userStore.isLoggedIn) {
                  const NotificationScreen().launch<void>(context);
                } else {
                  const SignInScreen().launch<void>(context);
                }
              }),
              10.width,
              Container(
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(16),
                  border: Border.all(
                    color: appStore.isDarkMode
                        ? Colors.white
                        : context.dividerColor.withValues(alpha: 0.9),
                    width: 0.6,
                  ),
                  backgroundColor: appStore.isDarkMode
                      ? context.scaffoldBackgroundColor
                      : Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Icon(
                  Icons.person_outline,
                  size: 24,
                  color: appStore.isDarkMode ? Colors.white : Colors.grey,
                ),
              ).onTap(() {
                const ProfileScreen().launch<void>(context);
              }),
            ],
          ).paddingOnly(
            top: context.statusBarHeight + 16,
            left: 16,
            right: 16,
            bottom: 6,
          ),
    ),
    body: RefreshIndicator(
      backgroundColor: context.scaffoldBackgroundColor,
      onRefresh: () async {
        setState(() {
          dashboardFuture = getDashboardApi();
        });
      },
      child: FutureBuilder<DashboardResponse?>(
        future: dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final DashboardResponse? mDashboardResponse = snapshot.data;
            userStore.setSubscription(mDashboardResponse?.subscription ?? '');

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeightReminder(),
                  16.height.visible(!userStore.weight.isEmptyOrNull),
                  _buildSearchBar(),
                  16.height,
                  HomeBannerSlider(
                    bannerSlider: mDashboardResponse!.bannerSlider,
                    pageController: _pageController,
                    currentIndex: _currentIndex,
                    onPageChanged: (index) => setState(() => _currentIndex = index),
                    shouldShowAds: shouldShowAds,
                    ads: ads,
                    adLoaded: adLoaded,
                    adLoading: adLoading,
                    loadAd: loadAd,
                    buildAdPlaceholder: buildAdPlaceholder,
                  ),
                  16.height,
                  HomeDailyTracking(stepController: stepController, waterController: waterController),
                  FutureBuilder<bool>(
                      future: HealthService().hasStepPermission(),
                      builder: (context, snapshot) {
                        bool isAuthorized = snapshot.data ?? false;
                        if (!Platform.isIOS || !isAuthorized) return const SizedBox.shrink();

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(12),
                            backgroundColor: appStore.isDarkMode ? context.cardColor : const Color(0xFFF2F7F4),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: radius(12),
                                  backgroundColor: appStore.isDarkMode ? Colors.black26 : Colors.white,
                                ),
                                child: const Icon(Icons.favorite, color: Color(0xFFE8504B), size: 24),
                              ),
                              12.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Health Integration",
                                    style: boldTextStyle(size: 16),
                                  ),
                                  2.height,
                                  Text(
                                    "Apple Health Connected",
                                    style: primaryTextStyle(size: 14),
                                  ),
                                  4.height,
                                  Text(
                                    "Step data is securely read from Apple Health using HealthKit.",
                                    style: secondaryTextStyle(size: 12),
                                  ),
                                ],
                              ).expand(),
                            ],
                          ),
                        );
                      }
                  ),
                  if (userStore.isLoggedIn &&
                      mDashboardResponse.assignedWorkout!.isNotEmpty)
                    _buildAssignedWorkouts(mDashboardResponse),
                  16.height,
                  if (mDashboardResponse.bodypart!.isNotEmpty)
                    _buildBodyParts(mDashboardResponse),
                  if (mDashboardResponse.equipment!.isNotEmpty)
                    _buildEquipments(mDashboardResponse),
                  if (mDashboardResponse.workout!.isNotEmpty)
                    _buildWorkouts(mDashboardResponse),
                  if (mDashboardResponse.level!.isNotEmpty)
                    _buildLevels(mDashboardResponse),
                ],
              ),
            );
          }
          return snapWidgetHelper(
            snapshot,
            loadingWidget: Container(
              height: mq.height,
              width: mq.width,
              color: Colors.transparent,
              child: const Loader(),
            ),
          );
        },
      ),
    ),
  );

  Widget _buildWeightReminder() => Column(
      children: [
        5.height,
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Marquee(
            text: languages.lblHomeScreenTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            pauseAfterRound: const Duration(seconds: 1),
          ),
        ).onTap(() {
          const EditProfileScreen().launch<void>(context);
        }),
      ],
    ).visible(userStore.weight.isEmptyOrNull && userStore.isLoggedIn);


  Widget _buildSearchBar() => GestureDetector(
      onTap: () {
        hideKeyboard(context);
        if (userStore.isLoggedIn) {
          const SearchScreen().launch<void>(context);
        } else {
          const SignInScreen().launch<void>(context);
        }
      },
      child: AbsorbPointer(
        child: AppTextField(
          controller: mSearchCont,
          textFieldType: TextFieldType.OTHER,
          isValidationRequired: false,
          autoFocus: false,
          suffix: _getClearButton(),
          decoration: defaultInputDecoration(
            context,
            label: languages.lblSearch,
            isFocusTExtField: true,
          ),
        ).paddingSymmetric(horizontal: 16),
      ),
    );





  Widget _buildAssignedWorkouts(DashboardResponse mDashboardResponse) => Column(
      children: [
        10.height,
        mHeading(
          languages.assignedWorkouts,
          onCall: () {
            const ViewWorkoutsScreen(isAssign: true).launch<void>(context);
          },
        ),
        HorizontalList(
          physics: const BouncingScrollPhysics(),
          itemCount: mDashboardResponse.assignedWorkout!.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          spacing: 16,
          itemBuilder: (context, index) => WorkoutComponent(
            mWorkoutModel: mDashboardResponse.assignedWorkout![index],
            onCall: () {
              appStore.setLoading(true);
              setState(() {});
              appStore.setLoading(false);
            },
          ),
        ),
      ],
    );


  Widget _buildBodyParts(DashboardResponse mDashboardResponse) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        mHeading(
          languages.lblBodyPartExercise,
          onCall: () {
            if (userStore.isLoggedIn) {
              const ViewBodyPartScreen().launch<void>(context);
            } else {
              const SignInScreen().launch<void>(context);
            }
          },
        ),
        HorizontalList(
          physics: const BouncingScrollPhysics(),
          controller: mScrollController,
          itemCount: mDashboardResponse.bodypart!.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          spacing: 16,
          itemBuilder: (context, index) => BodyPartComponent(
            bodyPartModel: mDashboardResponse.bodypart![index],
          ),
        ),
      ],
    );


  Widget _buildEquipments(DashboardResponse mDashboardResponse) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.height,
        mHeading(
          languages.lblEquipmentsExercise,
          onCall: () {
            if (userStore.isLoggedIn) {
              const ViewEquipmentScreen().launch<void>(context);
            } else {
              const SignInScreen().launch<void>(context);
            }
          },
        ),
        HorizontalList(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: mDashboardResponse.equipment?.length ?? 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          spacing: 16,
          itemBuilder: (context, index) => EquipmentComponent(
            mEquipmentModel: mDashboardResponse.equipment![index],
          ),
        ),
      ],
    );


  Widget _buildWorkouts(DashboardResponse mDashboardResponse) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.height,
        mHeading(
          languages.lblWorkouts,
          onCall: () {
            if (userStore.isLoggedIn) {
              const FilterWorkoutScreen().launch<void>(context).then((value) {
                setState(() {});
              });
            } else {
              const SignInScreen().launch<void>(context);
            }
          },
        ),
        HorizontalList(
          physics: const BouncingScrollPhysics(),
          itemCount: mDashboardResponse.workout!.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          spacing: 16,
          itemBuilder: (context, index) => WorkoutComponent(
            mWorkoutModel: mDashboardResponse.workout![index],
            onCall: () {
              appStore.setLoading(true);
              setState(() {});
              appStore.setLoading(false);
            },
          ),
        ),
      ],
    );


  Widget _buildLevels(DashboardResponse mDashboardResponse) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.height,
        mHeading(
          languages.lblLevels,
          onCall: () {
            if (userStore.isLoggedIn) {
              const ViewLevelScreen().launch<void>(context);
            } else {
              const SignInScreen().launch<void>(context);
            }
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: mDashboardResponse.level!.length,
          itemBuilder: (context, index) => LevelComponent(
            mLevelModel: mDashboardResponse.level![index],
          ),
        ),
        16.height,
      ],
    );

  Widget _getClearButton() {
    if (!_showClearButton) {
      return mSuffixTextFieldIconWidget(ic_search);
    }

    return IconButton(
      onPressed: () => mSearchCont.clear(),
      icon: const Icon(Icons.clear),
    );
  }
}

