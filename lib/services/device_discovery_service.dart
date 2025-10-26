import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import '../models/discovered_device.dart';

class DeviceDiscoveryService {
  final _networkInfo = NetworkInfo();
  final List<DiscoveredDevice> _discoveredDevices = [];
  final _deviceController =
      StreamController<List<DiscoveredDevice>>.broadcast();
  bool _isScanning = false;

  Stream<List<DiscoveredDevice>> get devicesStream => _deviceController.stream;
  List<DiscoveredDevice> get discoveredDevices =>
      List.unmodifiable(_discoveredDevices);
  bool get isScanning => _isScanning;

  /// Starts scanning the local network for AWTRIX devices
  Future<void> startDiscovery() async {
    if (_isScanning) return;

    _isScanning = true;
    _discoveredDevices.clear();
    _deviceController.add([]);

    try {
      // Get the local IP address
      final wifiIP = await _networkInfo.getWifiIP();
      if (wifiIP == null) {
        _isScanning = false;
        return;
      }

      // Extract subnet from IP (e.g., "192.168.1.100" -> "192.168.1")
      final subnet = wifiIP.substring(0, wifiIP.lastIndexOf('.'));

      // Scan common IP range (1-254)
      final futures = <Future>[];
      for (int i = 1; i <= 254; i++) {
        final ip = '$subnet.$i';
        futures.add(_checkDevice(ip));
      }

      // Wait for all checks to complete
      await Future.wait(futures);
    } catch (e) {
      // Error getting network info or during scan
    } finally {
      _isScanning = false;
      _deviceController.add(List.from(_discoveredDevices));
    }
  }

  /// Checks if a device at the given IP is an AWTRIX device
  Future<void> _checkDevice(String ip) async {
    try {
      final uri = Uri.parse('http://$ip/api/stats');

      // Try to connect with a short timeout
      final response = await http
          .get(uri)
          .timeout(
            const Duration(seconds: 2),
            onTimeout: () => http.Response('', 408),
          );

      if (response.statusCode == 200) {
        // Try to get hostname from the stats API response
        String? hostname;
        bool isAwtrix = false;

        try {
          // Parse the JSON response to get uid (which contains the hostname)
          final data = json.decode(response.body) as Map<String, dynamic>;
          hostname = data['uid'] as String?;

          // Check if it's an AWTRIX device by uid pattern
          if (hostname != null && hostname.toLowerCase().contains('awtrix')) {
            isAwtrix = true;
          }
        } catch (e) {
          // JSON parsing failed or uid not found
        }

        // Only add confirmed AWTRIX devices
        if (isAwtrix) {
          final device = DiscoveredDevice(
            ip: ip,
            hostname: hostname,
            isAwtrix: isAwtrix,
          );

          _discoveredDevices.add(device);
          _deviceController.add(List.from(_discoveredDevices));
        }
      }
    } catch (e) {
      // Device not reachable or not an AWTRIX device
      // Silent error, don't spam logs for every non-responsive IP
    }
  }

  /// Validates if a manually entered IP is an AWTRIX device
  Future<DiscoveredDevice?> validateDevice(String ipOrHostname) async {
    try {
      // Remove http:// or https:// if present
      String cleanAddress = ipOrHostname
          .replaceFirst('http://', '')
          .replaceFirst('https://', '');

      // Remove trailing path if present
      if (cleanAddress.contains('/')) {
        cleanAddress = cleanAddress.substring(0, cleanAddress.indexOf('/'));
      }

      final uri = Uri.parse('http://$cleanAddress/api/stats');

      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // Try to get hostname from the stats API response
        String? hostname;
        bool isAwtrix = false;

        try {
          // Parse the JSON response to get uid (which contains the hostname)
          final data = json.decode(response.body) as Map<String, dynamic>;
          hostname = data['uid'] as String?;

          // Check if it's an AWTRIX device by uid pattern
          if (hostname != null && hostname.toLowerCase().contains('awtrix')) {
            isAwtrix = true;
          }
        } catch (e) {
          // JSON parsing failed or uid not found
        }

        return DiscoveredDevice(
          ip: cleanAddress,
          hostname: hostname,
          isAwtrix: isAwtrix,
        );
      }
    } catch (e) {
      // Device not reachable
    }
    return null;
  }

  void dispose() {
    _deviceController.close();
  }
}
