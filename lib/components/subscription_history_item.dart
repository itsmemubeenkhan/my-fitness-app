import '../utils/shared_import.dart';

class SubscriptionHistoryItem extends StatelessWidget {
  final SubscriptionPlan plan;
  final Color Function(String?) getTextColor;
  final Color Function(String?) getBgColor;

  const SubscriptionHistoryItem({
    super.key,
    required this.plan,
    required this.getTextColor,
    required this.getBgColor,
  });

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: appStore.isDarkMode ? cardDarkColor : getBgColor(plan.status.validate()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(plan.packageName.validate(), style: boldTextStyle()).expand(),
              PriceWidget(
                price: plan.totalAmount.validate().toStringAsFixed(2),
                color: primaryColor,
                textStyle: boldTextStyle(),
              ),
            ],
          ),
          8.height,
          Text(
            "${parseDocumentDate(DateTime.parse(plan.subscriptionStartDate.validate()))} ${languages.lblTo} ${parseDocumentDate(DateTime.parse(plan.subscriptionEndDate.validate()))}",
            style: secondaryTextStyle(),
          ),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 6,
                    width: 6,
                    decoration: boxDecorationWithRoundedCorners(
                      boxShape: BoxShape.circle,
                      backgroundColor: textSecondaryColorGlobal,
                    ),
                  ),
                  6.width,
                  Text(
                    plan.paymentType.validate().capitalizeFirstLetter(),
                    style: primaryTextStyle(),
                  ),
                ],
              ).expand(),
              Text(
                plan.status.validate().capitalizeFirstLetter(),
                style: boldTextStyle(
                  color: getTextColor(plan.status.validate()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
}
