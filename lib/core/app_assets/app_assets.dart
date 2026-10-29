/// A utility class that provides paths to various assets used in the application.
///
/// This class includes constants for icons, images, and SVGs, organized by their usage.
/// It helps maintain a centralized location for asset paths, making it easier to manage and update them.

class AppAssets {
  static const _baseIconPath = 'assets/icons';
  static const _baseImagePath = 'assets/images';

  /// Icons
  static const appIcon = '$_baseIconPath/logo.png';

  /// Images
  static const welcomeImage = '$_baseImagePath/ic_welcome.png';

  /// Image Base URL.
  static String svgPath = "assets/svgs/";
  static String iconPath = "assets/icons/";
  static String imagesBase = "assets/images/";

  /// Splash
  static String splashBgImagePath = "${svgPath}new-splash-bg.svg";
  static String splashLogoImagePath = "${svgPath}logo.svg";

  /// Login
  static String loginTopImagePath = "${svgPath}login-top.svg";

  /// Profile Placeholder Image used in dashboard
  static String profileImage = '$imagesBase/profileimage.png';
  static String fileImage = "${svgPath}file.svg";
  static String profileUserImage = "${svgPath}user.svg";
  static String profileBgImage = "${svgPath}profile-bg.svg";
  static String workArrowImage = "${svgPath}profilearrow.svg";
  static String notificationImage = "${svgPath}bell-white.svg";

  /// Work dairy icons
  static String bellIcon = "${svgPath}bell.svg";
  static String infoIcon = "${svgPath}info.svg";
  static String sendIcon = "${iconPath}send.svg";
  static String userIcon = "${iconPath}user-tabel.svg";
  static String arrowRightIcon = "${iconPath}arrow-right-bold.svg";

  ///  Routing Detail Icons
  static String VinIcon = "${svgPath}VIN.svg";
  static String timeIcon = "${svgPath}time.svg";
  static String callIcon = "${svgPath}call.svg";
  static String noteIcon = "${iconPath}note.svg";
  static String userIcon1 = "${svgPath}user.svg";
  static String desSort = "${imagesBase}up1.png";
  static String ascSort = "${imagesBase}down.png";
  static String scaleIcon = "${svgPath}scale.svg";
  static String forkliftIcon = "${svgPath}forklift.svg";
  static String stopwatchIcon = "${svgPath}stopwatch.svg";
  static String locationIcon = "${svgPath}location-3.svg";
  static String arrowDownIcon = "${svgPath}arrow-down.svg";
  static String roundSpeedIcon = "${svgPath}round-speed.svg";
  static String viewDetailIcon = "${svgPath}view-detail.svg";
  static String circleTickCheckMark = "${iconPath}check.png";
  static String documentIcon = "${iconPath}document-bold.svg";
  static String phoneFilledIcon = "${svgPath}phone-filled.svg";
  static String assignDriverIcon = "${svgPath}assign-driver.svg";
  static String calendarIcon = "${iconPath}sharp-calendar-month.svg";
}
