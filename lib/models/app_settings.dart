class AppSettings {
  final String awtrixIp;
  final bool demoMode;

  AppSettings({
    required this.awtrixIp,
    required this.demoMode,
  });

  factory AppSettings.defaultSettings() {
    return AppSettings(
      awtrixIp: 'http://awtrix.local',
      demoMode: true,
    );
  }

  AppSettings copyWith({
    String? awtrixIp,
    bool? demoMode,
  }) {
    return AppSettings(
      awtrixIp: awtrixIp ?? this.awtrixIp,
      demoMode: demoMode ?? this.demoMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'awtrixIp': awtrixIp,
      'demoMode': demoMode,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      awtrixIp: json['awtrixIp'] ?? 'http://awtrix.local',
      demoMode: json['demoMode'] ?? true,
    );
  }
}
