import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'dart:math' show asin, cos, sqrt;

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({Key? key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  VietmapController? _mapController;
  List<Marker> temp = [];
  UserLocation? userLocation;
  String styleString =
      "https://maps.vietmap.vn/api/maps/raster/styles.json?apikey=9cbf0bc15d3901b7e043d8f76be8d73f370a82fe629a2d46";

  // Khai báo biến để lưu trạng thái của việc cấp quyền truy cập vị trí
  late PermissionStatus _locationPermission;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  // Hàm này được gọi để yêu cầu quyền truy cập vị trí từ người dùng
  void _requestLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final permissionStatus = await Geolocator.requestPermission();
      setState(() {
        _locationPermission = permissionStatus as PermissionStatus;
      });
    } else {
      setState(() {
        _locationPermission = permission as PermissionStatus;
      });
    }
  }

  void _onMapCreated(VietmapController controller) async {
    setState(() {
      _mapController = controller;
    });

    // Kiểm tra quyền truy cập vị trí trước khi lấy vị trí hiện tại của thiết bị
    // ignore: unrelated_type_equality_checks
    if (_locationPermission == LocationPermission.whileInUse ||
        // ignore: unrelated_type_equality_checks
        _locationPermission == LocationPermission.always) {
      Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Tạo Marker từ vị trí hiện tại của thiết bị
      Marker currentLocationMarker = Marker(
        width: 50,
        height: 50,
        child: _markerWidget(Icons.arrow_upward_rounded),
        latLng: LatLng(position.latitude, position.longitude),
      );

      setState(() {
        temp.add(currentLocationMarker);
      });

      // Di chuyển camera đến vị trí hiện tại
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(position.longitude, position.latitude),
              zoom: 1,
              tilt: 100)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vietmap Flutter GL'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          VietmapGL(
            myLocationEnabled: true,
            myLocationTrackingMode: MyLocationTrackingMode.TrackingCompass,
            myLocationRenderMode: MyLocationRenderMode.NORMAL,
            styleString: styleString,
            trackCameraPosition: true,
            onMapCreated: _onMapCreated,
            compassEnabled: false,
            onMapRenderedCallback: () {},
            onUserLocationUpdated: (location) {
              setState(() {
                userLocation = location;
              });
            },
            initialCameraPosition: const CameraPosition(
                target: LatLng(0.0, 0.0),
                zoom: 3), // Vị trí mặc định không quan trọng
            onMapClick: (point, coordinates) async {
              _addMarkerOnMap(coordinates);
              print('clcik');
            },
          ),
          _mapController == null
              ? const SizedBox.shrink()
              : MarkerLayer(
                  ignorePointer: true,
                  mapController: _mapController!,
                  markers: temp),
        ],
      ),
    );
  }

// Tính khoảng cách giữa hai tọa độ sử dụng haversine formula
  double distanceBetweenCoordinates(
      double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void _addMarkerOnMap(LatLng coordinates) async {
    // Lấy vị trí hiện tại của bạn
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double currentLatitude = position.latitude;
    double currentLongitude = position.longitude;

    // Tính khoảng cách giữa vị trí hiện tại và vị trí được chọn
    double distance = distanceBetweenCoordinates(
      currentLatitude,
      currentLongitude,
      coordinates.latitude,
      coordinates.longitude,
    );

    print('Khoảng cách giữa vị trí của bạn và điểm được chọn: $distance km');

    // Kiểm tra nếu khoảng cách dưới 1km
    if (distance < 1.0) {
      // Hiển thị Dialog thông báo "No"
      // ignore: use_build_context_synchronously
      showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: const Text("Thông báo"),
          content: const Text("Khoảng cách nhỏ hơn 1km."),
          actions: <Widget>[
            BasicDialogAction(
              title: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else {
      // Hiển thị Dialog thông báo "Yes"
      // ignore: use_build_context_synchronously
      showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: const Text("Thông báo"),
          content: const Text("Khoảng cách lớn hơn hoặc bằng 1km."),
          actions: <Widget>[
            BasicDialogAction(
              title: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }

    // Thêm Marker vào bản đồ
    Marker newMarker = Marker(
      width: 50,
      height: 50,
      child: _markerWidget(Icons.location_pin),
      latLng: coordinates,
    );

    setState(() {
      if (temp.isNotEmpty) {
        temp.clear();
      }
      temp.add(newMarker);
    });
  }

  _markerWidget(IconData icon) {
    return Icon(icon, color: Colors.red, size: 50);
  }
}
