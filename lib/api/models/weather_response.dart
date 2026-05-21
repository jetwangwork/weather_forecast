class WeatherResponse {
  final String? success;
  final WeatherRecords? records;

  WeatherResponse({this.success, this.records});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    // Requirements: Handling potential formatting issues
    if (!json.containsKey('records') || json['records'] == null) {
      throw const FormatException('API 格式錯誤：找不到 records 欄位');
    }
    return WeatherResponse(
      success: json['success']?.toString(),
      records: WeatherRecords.fromJson(json['records']),
    );
  }
}

class WeatherRecords {
  final String? datasetDescription;
  final List<WeatherLocation> locationList;

  WeatherRecords({this.datasetDescription, required this.locationList});

  factory WeatherRecords.fromJson(Map<String, dynamic> json) {
    final rawLocations = json['location'];
    if (rawLocations == null || rawLocations is! List) {
      throw const FormatException('API 格式錯誤：location 欄位無效或缺失');
    }
    return WeatherRecords(
      datasetDescription: json['datasetDescription']?.toString(),
      locationList: rawLocations
          .map((loc) => WeatherLocation.fromJson(loc as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WeatherLocation {
  final String locationName;
  final List<WeatherElement> weatherElementList;

  WeatherLocation({required this.locationName, required this.weatherElementList});

  factory WeatherLocation.fromJson(Map<String, dynamic> json) {
    final name = json['locationName']?.toString();
    if (name == null || name.isEmpty) {
      throw const FormatException('API 格式錯誤：找不到地區名稱 locationName');
    }
    final rawElements = json['weatherElement'];
    if (rawElements == null || rawElements is! List) {
      throw const FormatException('API 格式錯誤：weatherElement 欄位無效或缺失');
    }
    return WeatherLocation(
      locationName: name,
      weatherElementList: rawElements
          .map((el) => WeatherElement.fromJson(el as Map<String, dynamic>))
          .toList(),
    );
  }

  // Helper getters to easily retrieve Wx, PoP, MinT, MaxT, CI
  WeatherElement? getWx() => _getElementByName('Wx');
  WeatherElement? getPoP() => _getElementByName('PoP');
  WeatherElement? getMinT() => _getElementByName('MinT');
  WeatherElement? getMaxT() => _getElementByName('MaxT');
  WeatherElement? getCI() => _getElementByName('CI');

  WeatherElement? _getElementByName(String name) {
    try {
      return weatherElementList.firstWhere((el) => el.elementName == name);
    } catch (_) {
      return null;
    }
  }
}

class WeatherElement {
  final String elementName;
  final List<WeatherTime> timeList;

  WeatherElement({required this.elementName, required this.timeList});

  factory WeatherElement.fromJson(Map<String, dynamic> json) {
    final name = json['elementName']?.toString();
    if (name == null || name.isEmpty) {
      throw const FormatException('API 格式錯誤：找不到 elementName');
    }
    final rawTimes = json['time'];
    if (rawTimes == null || rawTimes is! List) {
      throw const FormatException('API 格式錯誤：time 欄位無效或缺失');
    }
    return WeatherElement(
      elementName: name,
      timeList: rawTimes
          .map((t) => WeatherTime.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WeatherTime {
  final String startTime;
  final String endTime;
  final WeatherParameter parameter;

  WeatherTime({
    required this.startTime,
    required this.endTime,
    required this.parameter,
  });

  factory WeatherTime.fromJson(Map<String, dynamic> json) {
    final start = json['startTime']?.toString();
    final end = json['endTime']?.toString();
    if (start == null || start.isEmpty || end == null || end.isEmpty) {
      throw const FormatException('API 格式錯誤：startTime 或 endTime 缺失');
    }
    final rawParam = json['parameter'];
    if (rawParam == null || rawParam is! Map<String, dynamic>) {
      throw const FormatException('API 格式錯誤：parameter 欄位無效或缺失');
    }
    return WeatherTime(
      startTime: start,
      endTime: end,
      parameter: WeatherParameter.fromJson(rawParam),
    );
  }
}

class WeatherParameter {
  final String parameterName;
  final String? parameterValue;
  final String? parameterUnit;

  WeatherParameter({
    required this.parameterName,
    this.parameterValue,
    this.parameterUnit,
  });

  factory WeatherParameter.fromJson(Map<String, dynamic> json) {
    final name = json['parameterName']?.toString();
    if (name == null || name.isEmpty) {
      throw const FormatException('API 格式錯誤：parameterName 缺失');
    }
    return WeatherParameter(
      parameterName: name,
      parameterValue: json['parameterValue']?.toString(),
      parameterUnit: json['parameterUnit']?.toString(),
    );
  }
}
