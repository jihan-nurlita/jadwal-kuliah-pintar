class NotificationService {
  static Future<void> init() async {
    // Dipanggil di main.dart, melakukan inisialisasi system alarm/notifikasi lokal
    print("Notification Service Initialized Successfully.");
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // Simulator trigger logger
    print("Showing Local Notification [$id]: $title - $body");
  }
}
