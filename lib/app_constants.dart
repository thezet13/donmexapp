import 'models/language_model.dart';

class AppConstants {
  static const String APP_NAME = "Donmex App";
  static const int APP_VERSION = 1;

  static const String POSTER_BASE_URL = "https://donmex.joinposter.com";
  static const String GOOGLE_BASE_URL = "https://maps.googleapis.com";
  static const String PRODUCTS_LIST_URI =
      "/api/menu.getProducts?token=219854:311572788feec064b9960635fffa2fd6&category_id=4";
  static const String GOOGLE_MAP_API =
      "https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyCaOgQ61F98HEbHbKpMZKEXwoYWs5AUmAo";
  static const String PRODUCTS_MENU_URI =
      "/api/menu.getProducts?token=219854:311572788feec064b9960635fffa2fd6";

  static const String REGISTRATION_URI =
      "/api/clients.createClient?token=219854:311572788feec064b9960635fffa2fd6";
  static const String LOGIN_URI =
      "/api/clients.getClients?token=219854:311572788feec064b9960635fffa2fd6";
  static const String USER_INFO_URI =
      "/api/clients.getClient?token=219854:311572788feec064b9960635fffa2fd6";
  static const String ADD_USER_ADDRESS =
      "/api/clients.updateClient?token=219854:311572788feec064b9960635fffa2fd6";
  //static const String UPDATE_USER = "/api/clients.updateClient?token=219854:311572788feec064b9960635fffa2fd6";
  static const String ADDRESS_LIST_URI =
      "/api/clients.getClient?token=219854:311572788feec064b9960635fffa2fd6";
  static const String GEOCODE_URI =
      "/maps/api/geocode/json?key=AIzaSyCaOgQ61F98HEbHbKpMZKEXwoYWs5AUmAo";
  static const String ZONE_URI = "/data/delivery_zone.json";
  static const String ADD_ORDER_URI =
      "/api/incomingOrders.createIncomingOrder?token=219854:311572788feec064b9960635fffa2fd6";
  static const String GET_ORDER_URI =
      "/api/incomingOrders.getIncomingOrder?token=219854:311572788feec064b9960635fffa2fd6";
  static const String GET_PROCESS_URI =
      "/api/dash.getTransaction?token=219854:311572788feec064b9960635fffa2fd6";
  static const String SPOTS_URI =
      "/api/spots.getSpots?token=219854:311572788feec064b9960635fffa2fd6";

  static const String ZONES = "http://donmex.az/data/zones.json";
  static const String SEARCH_LOCATION_URI =
      "/maps/api/place/autocomplete/json?key=AIzaSyCaOgQ61F98HEbHbKpMZKEXwoYWs5AUmAo";
  static const String PLACE_DETAILS_URI =
      "/maps/api/place/details/json?key=AIzaSyCaOgQ61F98HEbHbKpMZKEXwoYWs5AUmAo";

  static const String TOKEN = "";

  static const String CLIENTID = "";
  static const String LASTNAME = "";
  static const String PHONE = "";
  static const String PASSWORD = "";
  static const String LANGUAGE = "";
  static const String USER_ADDRESS = "user_address";
  static const String USER_LATITUDE = "";
  static const String USER_LONGITUDE = "";

  static const String CART_LIST = "cart-list";
  static const String CART_HISTORY_LIST = "cart-history-list";

  /*
  Localization data
   */
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: "xx", languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: "xx", languageName: 'Azəri', countryCode: 'AZ', languageCode: 'az'),
    LanguageModel(imageUrl: "xx", languageName: 'Русский', countryCode: 'RU', languageCode: 'ru'),
  ];
}
