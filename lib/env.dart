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

  static int databaseVersion=1;

//todo:please Set API Base Route
  static String _localUrl = 'http://192.168.1.2/promosme/public/api';
  static String _productionUrl = 'http://amr.amrnrd.com/api';
  static devMode mode = devMode.development;

  static String get baseUrl {
  if (mode == devMode.development)
  return _localUrl;
  else
  return _productionUrl;
  }










}