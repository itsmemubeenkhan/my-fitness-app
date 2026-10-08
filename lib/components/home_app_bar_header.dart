import '../utils/shared_import.dart';

class HomeAppBarHeader extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onPersonTap;

  const HomeAppBarHeader({
    super.key,
    required this.onProfileTap,
    required this.onNotificationTap,
    required this.onPersonTap,
  });

  @override
  Widget build(BuildContext context) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Observer(
              builder: (context) => Container(
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
              ).onTap(onProfileTap),
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
        _buildIconButton(
          context,
          child: Image.asset(
            ic_notification,
            width: 24,
            height: 24,
            color: appStore.isDarkMode ? Colors.white : Colors.grey,
          ),
          onTap: onNotificationTap,
        ),
        10.width,
        _buildIconButton(
          context,
          child: Icon(
            Icons.person_outline,
            size: 24,
            color: appStore.isDarkMode ? Colors.white : Colors.grey,
          ),
          onTap: onPersonTap,
        ),
      ],
    ).paddingOnly(
      top: context.statusBarHeight + 16,
      left: 16,
      right: 16,
      bottom: 6,
    );

  Widget _buildIconButton(
    BuildContext context, {
    required Widget child,
    required VoidCallback onTap,
  }) => Container(
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
      child: child,
    ).onTap(onTap);
}
