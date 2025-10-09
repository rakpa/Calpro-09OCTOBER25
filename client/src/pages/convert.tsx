import { useState, useEffect } from "react";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import AdBanner from "@/components/AdBanner";
import { Button } from "@/components/ui/button";
import Seo from "@/components/Seo";

const units = {
  length: [
    { name: "Kilometers", factor: 0.001 },
    { name: "Meters", factor: 1 },
    { name: "Centimeters", factor: 100 },
    { name: "Millimeters", factor: 1000 },
    { name: "Micrometers", factor: 1000000 },
    { name: "Nanometers", factor: 1000000000 },
    { name: "Miles", factor: 0.000621371 },
    { name: "Yards", factor: 1.09361 },
    { name: "Feet", factor: 3.28084 },
    { name: "Inches", factor: 39.3701 },
    { name: "Nautical Miles", factor: 0.000539957 }
  ],
  weight: [
    { name: "Kilograms", factor: 1 },
    { name: "Grams", factor: 1000 },
    { name: "Milligrams", factor: 1000000 },
    { name: "Metric Tons", factor: 0.001 },
    { name: "Pounds", factor: 2.20462 },
    { name: "Ounces", factor: 35.274 },
    { name: "Stone", factor: 0.157473 }
  ],
  area: [
    { name: "Square Millimeters", factor: 1000000 },
    { name: "Square Centimeters", factor: 10000 },
    { name: "Square Meters", factor: 1 },
    { name: "Square Kilometers", factor: 0.000001 },
    { name: "Are", factor: 0.01 },
    { name: "Hectares", factor: 0.0001 },
    { name: "Acres", factor: 0.000247105 },
    { name: "Square Feet", factor: 10.7639 }
  ]
};

export default function Convert() {
  const [value, setValue] = useState("");
  const [category, setCategory] = useState("length");
  const [fromUnit, setFromUnit] = useState("Meters");
  const [toUnit, setToUnit] = useState("Feet");

  useEffect(() => {
    const list = units[category as keyof typeof units];
    if (list && list.length > 0) {
      setFromUnit(list[0].name);
      setToUnit(list[Math.min(1, list.length - 1)].name);
    }
  }, [category]);

  const convert = () => {
    const unitsList = units[category as keyof typeof units];
    const from = unitsList.find((u) => u.name === fromUnit);
    const to = unitsList.find((u) => u.name === toUnit);

    if (!from || !to || value === "") return "";

    // Convert to base unit first (base unit depends on category)
    const baseValue = Number(value) / from.factor;
    // Then convert from base unit to target unit
    const result = baseValue * to.factor;

    return result.toLocaleString(undefined, {
      maximumFractionDigits: 8,
      minimumFractionDigits: 0
    });
  };

  // Clear just the text input (value)
  const clearAll = () => {
    setValue("");
  };

  return (
    <div className="min-h-screen bg-gray-50 p-2 sm:p-4 lg:p-6 font-inter">
      <Seo
        title="Unit Converter - Convert Length, Weight, and Area | CalcPro"
        description="Fast unit converter for length, weight, and area. Convert meters to feet, kilograms to pounds, square meters to acres and hectares, and more."
        keywords={["unit converter", "length converter", "weight converter", "area converter", "meters to feet", "kg to lbs", "square meters to acres", "hectares to square meters"]}
        canonicalPath="/convert"
      />
      
      {/* Main Container */}
      <div className="max-w-7xl mx-auto">
        <div className="bg-white rounded-2xl shadow-lg p-4 sm:p-6 lg:p-8">
          {/* Header */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-6 sm:mb-8 gap-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 sm:w-12 sm:h-12 bg-purple-600 rounded-full flex items-center justify-center">
                <span className="text-white font-bold text-lg sm:text-xl">↔</span>
              </div>
              <h1 className="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-900 font-inter">Unit Converter</h1>
            </div>
            <Button 
              variant="outline" 
              onClick={clearAll}
              className="px-3 py-2 text-sm border-gray-300 hover:bg-gray-50 w-full sm:w-auto font-inter"
            >
              Clear All
            </Button>
          </div>

          <p className="text-gray-600 mb-6 sm:mb-8 text-sm sm:text-base font-inter">
            Convert between common units of length, weight and area. This free online unit converter supports metric and imperial units including meters (m), feet (ft), kilograms (kg), pounds (lb), square meters (m²), acres, and hectares.
          </p>

          {/* Calculator Section */}
          <div className="max-w-md mx-auto">
            <div className="bg-white border border-gray-200 rounded-xl p-4 sm:p-6 lg:p-8 shadow-sm hover:shadow-md transition-shadow">
              <div className="space-y-6">
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Category</label>
                    <Select value={category} onValueChange={setCategory}>
                      <SelectTrigger className="w-full h-12 sm:h-14 text-sm sm:text-base font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4">
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="length" className="text-sm">Length</SelectItem>
                        <SelectItem value="weight" className="text-sm">Weight</SelectItem>
                        <SelectItem value="area" className="text-sm">Area</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>

                  <div>
                    <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">From</label>
                    <Select value={fromUnit} onValueChange={setFromUnit}>
                      <SelectTrigger className="w-full h-12 sm:h-14 text-sm sm:text-base font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4">
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent className="max-h-[300px] overflow-y-auto">
                        {units[category as keyof typeof units].map((unit) => (
                          <SelectItem key={unit.name} value={unit.name}>
                            {unit.name}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>

                  <div>
                    <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">To</label>
                    <Select value={toUnit} onValueChange={setToUnit}>
                      <SelectTrigger className="w-full h-12 sm:h-14 text-sm sm:text-base font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4">
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent className="max-h-[300px] overflow-y-auto">
                        {units[category as keyof typeof units].map((unit) => (
                          <SelectItem key={unit.name} value={unit.name}>
                            {unit.name}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>

                  <div>
                    <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Value</label>
                    <Input
                      type="number"
                      placeholder="0"
                      className="w-full h-12 sm:h-14 text-lg sm:text-xl font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                      value={value}
                      onChange={(e) => setValue(e.target.value)}
                    />
                  </div>
                </div>

                {value && (
                  <div className="text-center pt-4 sm:pt-6">
                    <div className="bg-green-50 border border-green-200 rounded-lg p-4 sm:p-6">
                      <div className="flex flex-col sm:flex-row items-center justify-center gap-2 sm:gap-4">
                        <p className="text-sm sm:text-base text-green-700 font-inter">
                          {value} {fromUnit}
                        </p>
                        <span className="text-sm sm:text-base text-green-600 font-inter">=</span>
                        <p className="text-lg sm:text-2xl font-bold text-green-800 font-inter">
                          {convert()}
                        </p>
                        <p className="text-sm sm:text-base text-green-700 font-inter">
                          {toUnit}
                        </p>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Bottom Banner Ad */}
      <div className="mt-8">
        <AdBanner
          slot="9012345678"
          className="w-full max-w-[728px] h-[90px] mx-auto"
          format="horizontal"
          adType="banner"
        />
      </div>
    </div>
  );
}