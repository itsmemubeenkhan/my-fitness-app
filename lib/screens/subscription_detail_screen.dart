import '../utils/shared_import.dart';

class SubscriptionDetailScreen extends StatefulWidget {
  final SubscriptionPlan? mList;

  const SubscriptionDetailScreen({super.key, this.mList});

  @override
  State<SubscriptionDetailScreen> createState() =>
      _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  List<SubscriptionPlan> mSubscriptionPlanList = [];
  String? activePlanData;
  bool select = true;

  ScrollController scrollController = ScrollController();

  int page = 1;
  int? numPage;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    LiveStream().on(PAYMENT, (p0) {
      init();
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          init();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> init() async {
    getSubscriptionList();
  }

  Future<void> getSubscriptionList() async {
    appStore.setLoading(true);
    getSubScriptionPlanList(page: page)
        .then((value) {
          numPage = value.pagination!.totalPages;
          isLastPage = false;
          if (page == 1) {
            mSubscriptionPlanList.clear();
          }
          final Iterable<SubscriptionPlan> it = value.data!;
          it.map((e) => mSubscriptionPlanList.add(e)).toList();

          setState(() {});
          appStore.setLoading(false);
        })
        .catchError((e) {
          isLastPage = true;
          appStore.setLoading(false);
          setState(() {});
        });
  }

  Future<void> cancelPackage({int? id}) async {
    appStore.setLoading(true);
    final Map<String, dynamic> req = {
      "id": id ?? userStore.subscriptionDetail?.subscriptionPlan?.id,
    };
    await cancelPlanApi(req)
        .then((value) async {
          if (!mounted) return;
          await getUSerDetail(context, userStore.userId).whenComplete(() {
            if (!mounted) return;
            userStore.isSubscribe = 0;
            setState(() {});
            toast(value.message);
            appStore.setLoading(false);
            finish(context);
          });
        })
        .catchError((Object e) {
          appStore.setLoading(false);
          log(e.toString());
        });
  }

  Color getTextColor(String? state) {
    switch (state) {
      case ACTIVE:
        return GreenColor;
      case INACTIVE:
        return Colors.grey;
      case CANCELLED:
        return RedColor;
      case EXPIRED:
        return YellowColor;
      default:
        return Colors.black;
    }
  }

  Color getBgColor(String? state) {
    switch (state) {
      case ACTIVE:
        return GreenColor.withValues(alpha: 0.15);
      case INACTIVE:
        return Colors.grey.withValues(alpha: 0.10);
      case CANCELLED:
        return RedColor.withValues(alpha: 0.10);
      case EXPIRED:
        return YellowColor.withValues(alpha: 0.5);
      default:
        return Colors.black;
    }
  }

  Widget buildSubscriptionWidget() {
    if (userStore.subscriptionDetail == null || userStore.subscriptionDetail!.subscriptionPlan == null || userStore.subscriptionDetail!.subscriptionPlan!.status == "inactive") {
      for (var status in mSubscriptionPlanList) {
        if (status.status == 'active') {
          return ActiveSubscriptionComponent(
            plan: status,
            onCancel: () => cancelPackage(id: status.id),
          );
        }
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(no_data_found, height: context.height() * 0.2, width: context.width() * 0.4),
          20.height,
          Text(languages.lblSubscriptionMsg, style: boldTextStyle(size: 16, color: textSecondaryColorGlobal)),
          50.height,
          AppButton(
            text: languages.lblViewPlans,
            width: context.width(),
            color: primaryColor,
            onTap: () {
              const SubscribeScreen().launch<void>(context, pageRouteAnimation: PageRouteAnimation.Fade);
            },
          ).paddingAll(16),
        ],
      );
    } else {
      return ActiveSubscriptionComponent(
        plan: userStore.subscriptionDetail!.subscriptionPlan!,
        onCancel: cancelPackage,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBarWidget(
          languages.lblSubscriptionPlans,
          context: context,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(45),
            child: SubscriptionTabHeader(
              select: select,
              onTap: () {
                setState(() {
                  select = !select;
                });
              },
            ),
          ),
        ),
        body: Stack(
          children: [
            select
                ? buildSubscriptionWidget()
                : mSubscriptionPlanList.isNotEmpty
                    ? AnimatedListView(
                        itemCount: mSubscriptionPlanList.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        shrinkWrap: true,
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (mSubscriptionPlanList[index].status != 'inactive') return const SizedBox.shrink();
                          return SubscriptionHistoryItem(
                            plan: mSubscriptionPlanList[index],
                            getTextColor: getTextColor,
                            getBgColor: getBgColor,
                          );
                        },
                      )
                    : SizedBox(
                        height: context.height() * 0.65,
                        child: const NoDataScreen().center(),
                      ).visible(!appStore.isLoading),
            Observer(
              builder: (context) => Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
                child: const Loader().center(),
              ).visible(appStore.isLoading),
            ),
          ],
        ),
      );
}
