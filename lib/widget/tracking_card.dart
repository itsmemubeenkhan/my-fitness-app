import '../utils/shared_import.dart';

Widget trackingCard({
  required Color background,
  required Color progressColor,
  required String subtitle,
  required String value,
  required String label,
  required double progress, // 0.0 - 1.0
  required IconData icon,
}) => Container(
  height: 90, // card height tuned to image
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  decoration: BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Circular ring with white center and icon
      SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // outer circular progress indicator
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 4.0,
                valueColor: AlwaysStoppedAnimation(progressColor),
                backgroundColor: Colors.white.withValues(alpha: 0.9),
              ),
            ),

            // inner white circle
            Icon(icon, size: 30, color: progressColor),
          ],
        ),
      ),

      const SizedBox(width: 12),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            5.height,
            RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: value == "Connect Apple Health" ? 2 : 1,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: value == "Connect Apple Health" ? 12 : 16,
                      fontWeight: FontWeight.w500,
                      color: progressColor,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 3)),
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // keep remaining space empty so layout matches image alignment
    ],
  ),
);
