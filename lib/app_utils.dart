import 'package:geocoder/geocoder.dart';

class CommonUtils {
  static getAddress(Coordinates coordinates) async {
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    if (addresses.length > 0) {
      return addresses.first.addressLine;
    }
    return "Not finding";
  }
}
