class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://192.168.1.9:3000/api/";
  // For iPhone
  // static const String baseUrl = "http://localhost:3000/api/v1/";

  // ====================== Auth Routes ======================
  static const String login = "v1/login"; // Already aligned with backend
  static const String signup =
      "v1/register"; // Note: Adjust if needed (see below)
  static const String imageUrl = "http://192.168.1.9:3000/uploads/";
  static const String uploadImage =
      "v1/uploadImage"; // Note: Adjust if needed (see below)

  // ====================== Room Routes ======================
  static const String getAllRooms = "rooms"; // Maps to GET /api/rooms
}
