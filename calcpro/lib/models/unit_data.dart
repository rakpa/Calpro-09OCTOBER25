class UnitDef {
  final String name;
  final double factor; // how many of this unit equal 1 base unit

  const UnitDef(this.name, this.factor);
}

const lengthUnits = <UnitDef>[
  UnitDef('Kilometers', 0.001),
  UnitDef('Meters', 1),
  UnitDef('Centimeters', 100),
  UnitDef('Millimeters', 1000),
  UnitDef('Micrometers', 1000000),
  UnitDef('Nanometers', 1000000000),
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
  UnitDef('Square Millimeters', 1000000),
  UnitDef('Square Centimeters', 10000),
  UnitDef('Square Meters', 1),
  UnitDef('Square Kilometers', 0.000001),
  UnitDef('Are', 0.01),
  UnitDef('Hectares', 0.0001),
  UnitDef('Acres', 0.000247105),
  UnitDef('Square Feet', 10.7639),
];

enum UnitCategory { length, weight, area }

List<UnitDef> unitsFor(UnitCategory category) {
  switch (category) {
    case UnitCategory.length:
      return lengthUnits;
    case UnitCategory.weight:
      return weightUnits;
    case UnitCategory.area:
      return areaUnits;
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
  }
}

double convertUnits({
  required double value,
  required UnitDef from,
  required UnitDef to,
}) {
  final base = value / from.factor;
  return base * to.factor;
}
