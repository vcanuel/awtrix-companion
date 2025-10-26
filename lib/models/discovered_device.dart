class DiscoveredDevice {
  final String ip;
  final String? hostname;
  final bool isAwtrix;
  final DateTime discoveredAt;

  DiscoveredDevice({
    required this.ip,
    this.hostname,
    required this.isAwtrix,
    DateTime? discoveredAt,
  }) : discoveredAt = discoveredAt ?? DateTime.now();

  String get displayName {
    if (hostname != null && hostname!.isNotEmpty) {
      return hostname!;
    }
    return ip;
  }

  String get displayNameWithIp {
    if (hostname != null && hostname!.isNotEmpty) {
      return '$hostname ($ip)';
    }
    return ip;
  }

  bool get isConfirmedAwtrix {
    return isAwtrix &&
        hostname != null &&
        hostname!.toLowerCase().startsWith('awtrix');
  }

  DiscoveredDevice copyWith({
    String? ip,
    String? hostname,
    bool? isAwtrix,
    DateTime? discoveredAt,
  }) {
    return DiscoveredDevice(
      ip: ip ?? this.ip,
      hostname: hostname ?? this.hostname,
      isAwtrix: isAwtrix ?? this.isAwtrix,
      discoveredAt: discoveredAt ?? this.discoveredAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DiscoveredDevice && other.ip == ip;
  }

  @override
  int get hashCode => ip.hashCode;
}
