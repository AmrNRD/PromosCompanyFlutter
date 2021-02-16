enum devMode { development, production }

class Env{
  static bool isRTL = false;

  static String appName="Promos me";

  static const dummyProfilePic = "";

  //Route names
  static const mainPage = "/";
  static const authPage = "/authPage";
  static const homePage = "/homePage";
  static const saleItemPage = "/saleItemPage";
  static const profilePage = "/profilePage";
  static const addVideoPage = "/addVideoPage";
  static const addSaleItemPage = "/addSaleItemPage";
  static const editPage = "/editPage";
  static const videoPage = "/videoPage";
  static const sideMenuPage = "/sideMenuPage";

  static int databaseVersion=1;

//todo:please Set API Base Route
  static String _localUrl = 'http://192.168.1.3/promosme/public/api';
  static String _productionUrl = 'http://promos.website/api';
  static devMode mode = devMode.production;

  static String get baseUrl {
  if (mode == devMode.development)
  return _localUrl;
  else
  return _productionUrl;
  }










}