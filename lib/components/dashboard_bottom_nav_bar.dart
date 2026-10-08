import '../utils/shared_import.dart';

class DashboardBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const DashboardBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => SafeArea(
      bottom: Platform.isAndroid ? true : false,
      left: false,
      right: false,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        enableFeedback: false,
        selectedLabelStyle: secondaryTextStyle(size: 12),
        unselectedLabelStyle: secondaryTextStyle(size: 11),
        backgroundColor: context.cardColor,
        currentIndex: currentIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: primaryColor,
        onTap: (index) {
          // Auth checks for Community (3), Schedule (4), Plan (5)
          if ((index == 3 || index == 4 || index == 5) && !userStore.isLoggedIn) {
            const SignInScreen().launch<void>(context);
            return;
          }
          if (index == 5 && userStore.isLoggedIn && userStore.weight.isEmptyOrNull) {
            toast(languages.lblPleaseenteryourageweightandhei);
            return;
          }
          onTap(index);
        },
        items: [
          _buildNavItem(ic_home_outline, ic_home_fill, languages.lblHome),
          _buildNavItem(ic_diet_outline, ic_diet_fill, languages.lblDiet),
          _buildNavItem(ic_store_outline, ic_store_fill, languages.lblShop),
          _buildNavItem(ic_community2, ic_community_filled, languages.lblCommunity, height: 22),
          _buildNavItem(ic_schedule, ic_fill_schedule, languages.lblSchedule, height: 22),
          BottomNavigationBarItem(
            tooltip: "Plan",
            icon: const Icon(Icons.assignment_outlined, color: Colors.grey, size: 24),
            activeIcon: const Icon(Icons.assignment, color: primaryColor, size: 24),
            label: languages.plan,
          ),
        ],
      ),
    );

  BottomNavigationBarItem _buildNavItem(String icon, String activeIcon, String label, {double height = 24}) => BottomNavigationBarItem(
      tooltip: label,
      icon: Image.asset(icon, color: Colors.grey, height: height),
      activeIcon: Image.asset(activeIcon, color: primaryColor, height: 24),
      label: label,
    );
}
