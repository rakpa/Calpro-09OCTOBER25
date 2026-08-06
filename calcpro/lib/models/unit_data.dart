class UnitDef {
  final String name;
  final double factor; // how many of this unit equal 1 base unit
  final bool isTemperature;

  const UnitDef(this.name, this.factor, {this.isTemperature = false});
}

const lengthUnits = <UnitDef>[
  UnitDef('Kilometers', 0.001),
  UnitDef('Meters', 1),
  UnitDef('Centimeters', 100),
  UnitDef('Millimeters', 1000),
  UnitDef('Miles', 0.000621371),
  UnitDef('Yards', 1.09361),
  UnitDef('Feet', 3.28084),
  UnitDef('Inches', 39.3701),
  UnitDef('Nautical Miles', 0.000539957),
];

const weightUnits = <UnitDef>[
  UnitDef('Kilograms', 1),
  UnitDef('Grams', 1000),
  UnitDef('Milligrams', 1000000),
  UnitDef('Metric Tons', 0.001),
  UnitDef('Pounds', 2.20462),
  UnitDef('Ounces', 35.274),
  UnitDef('Stone', 0.157473),
];

const areaUnits = <UnitDef>[
  UnitDef('Square Centimeters', 10000),
  UnitDef('Square Meters', 1),
  UnitDef('Square Kilometers', 0.000001),
  UnitDef('Hectares', 0.0001),
  UnitDef('Acres', 0.000247105),
  UnitDef('Square Feet', 10.7639),
  UnitDef('Square Inches', 1550.0),
];

const volumeUnits = <UnitDef>[
  UnitDef('Milliliters', 1000),
  UnitDef('Liters', 1),
  UnitDef('Cubic Meters', 0.001),
  UnitDef('Cups (US)', 4.22675),
  UnitDef('Pints (US)', 2.11338),
  UnitDef('Quarts (US)', 1.05669),
  UnitDef('Gallons (US)', 0.264172),
  UnitDef('Fluid Ounces (US)', 33.814),
];

const speedUnits = <UnitDef>[
  UnitDef('Meters/sec', 1),
  UnitDef('Kilometers/hour', 3.6),
  UnitDef('Miles/hour', 2.23694),
  UnitDef('Feet/sec', 3.28084),
  UnitDef('Knots', 1.94384),
];

/// Temperature uses special conversion — factor unused.
const temperatureUnits = <UnitDef>[
  UnitDef('Celsius', 1, isTemperature: true),
  UnitDef('Fahrenheit', 1, isTemperature: true),
  UnitDef('Kelvin', 1, isTemperature: true),
];

enum UnitCategory { length, weight, area, volume, speed, temperature }

List<UnitDef> unitsFor(UnitCategory category) {
  switch (category) {
    case UnitCategory.length:
      return lengthUnits;
    case UnitCategory.weight:
      return weightUnits;
    case UnitCategory.area:
      return areaUnits;
    case UnitCategory.volume:
      return volumeUnits;
    case UnitCategory.speed:
      return speedUnits;
    case UnitCategory.temperature:
      return temperatureUnits;
  }
}

String categoryLabel(UnitCategory category) {
  switch (category) {
    case UnitCategory.length:
      return 'Length';
    case UnitCategory.weight:
      return 'Weight';
    case UnitCategory.area:
      return 'Area';
    case UnitCategory.volume:
      return 'Volume';
    case UnitCategory.speed:
      return 'Speed';
    case UnitCategory.temperature:
      return 'Temp';
  }
}

double _toCelsius(double value, String from) {
  switch (from) {
    case 'Fahrenheit':
      return (value - 32) * 5 / 9;
    case 'Kelvin':
      return value - 273.15;
    default:
      return value;
  }
}

double _fromCelsius(double celsius, String to) {
  switch (to) {
    case 'Fahrenheit':
      return celsius * 9 / 5 + 32;
    case 'Kelvin':
      return celsius + 273.15;
    default:
      return celsius;
  }
}

double convertUnits({
  required double value,
  required UnitDef from,
  required UnitDef to,
}) {
  if (from.isTemperature || to.isTemperature) {
    final c = _toCelsius(value, from.name);
    return _fromCelsius(c, to.name);
  }
  final base = value / from.factor;
  return base * to.factor;
}
