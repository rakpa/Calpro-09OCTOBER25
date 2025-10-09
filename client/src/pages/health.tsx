import { useState } from "react";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import AdBanner from "@/components/AdBanner";
import Seo from "@/components/Seo";

export default function Health() {
  // BMI Calculator State
  const [weight, setWeight] = useState("");
  const [height, setHeight] = useState("");
  const [bmi, setBmi] = useState<number | null>(null);

  // Ideal Weight Calculator State
  const [gender, setGender] = useState<"male" | "female">("male");
  const [heightForIdeal, setHeightForIdeal] = useState("");
  const [idealWeight, setIdealWeight] = useState<number | null>(null);

  // BMI Calculation
  const calculateBMI = () => {
    const weightKg = parseFloat(weight);
    const heightM = parseFloat(height) / 100;
    const bmiValue = weightKg / (heightM * heightM);
    setBmi(parseFloat(bmiValue.toFixed(1)));
  };

  // Ideal Weight Calculation (Hamwi Formula)
  const calculateIdealWeight = () => {
    const heightCm = parseFloat(heightForIdeal);
    const heightInches = heightCm / 2.54;
    const baseHeight = 60; // 5 feet in inches

    let ideal = 0;
    if (gender === "male") {
      ideal = 48 + 2.7 * (heightInches - baseHeight);
    } else {
      ideal = 45.5 + 2.2 * (heightInches - baseHeight);
    }

    setIdealWeight(parseFloat((ideal * 0.453592).toFixed(1))); // Convert lbs to kg
  };

  const getBMICategory = (bmi: number) => {
    if (bmi < 18.5) return { category: "Underweight", color: "text-blue-500" };
    if (bmi < 25) return { category: "Normal weight", color: "text-green-500" };
    if (bmi < 30) return { category: "Overweight", color: "text-yellow-500" };
    return { category: "Obese", color: "text-red-500" };
  };

  // Clear relevant inputs and results
  const clearAll = () => {
    setWeight("");
    setHeight("");
    setBmi(null);
    setHeightForIdeal("");
    setIdealWeight(null);
  };

  return (
    <div className="space-y-8">
      <Seo
        title="Health Calculators - BMI and Ideal Weight | CalcPro"
        description="Calculate Body Mass Index (BMI) and estimate ideal weight using the Hamwi formula. Free online health calculators."
        keywords={["BMI calculator", "ideal weight", "Hamwi formula", "health calculator"]}
        canonicalPath="/health"
      />

      <div className="max-w-2xl mx-auto px-4">
        <h1 className="text-2xl font-semibold leading-none tracking-tight">Health Calculators</h1>
        <p className="mt-12 text-muted-foreground">
          Check your BMI and estimate an ideal weight based on height. For guidance only, not a medical diagnosis.
        </p>
      </div>

      <div className="max-w-2xl mx-auto px-4">
        <Card>
          <CardHeader>
            <div className="flex items-center justify-end">
              <Button variant="outline" onClick={clearAll}>Clear All</Button>
            </div>
          </CardHeader>
          <CardContent>
            <Tabs defaultValue="bmi" className="space-y-4">
              <TabsList className="grid w-full grid-cols-2">
                <TabsTrigger value="bmi">BMI Calculator</TabsTrigger>
                <TabsTrigger value="ideal">Ideal Weight</TabsTrigger>
              </TabsList>

              <TabsContent value="bmi" className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="weight">Weight (kg)</Label>
                  <Input
                    id="weight"
                    type="number"
                    value={weight}
                    onChange={(e) => setWeight(e.target.value)}
                    placeholder="Enter weight in kilograms"
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="height">Height (cm)</Label>
                  <Input
                    id="height"
                    type="number"
                    value={height}
                    onChange={(e) => setHeight(e.target.value)}
                    placeholder="Enter height in centimeters"
                  />
                </div>
                <Button
                  className="w-full !bg-[#4B0082] hover:!bg-[#3A0066] disabled:!bg-[#4B0082] disabled:!opacity-100"
                  onClick={calculateBMI}
                  disabled={!weight || !height}
                >
                  Calculate BMI
                </Button>
                {bmi !== null && (
                  <div className="pt-4 text-center space-y-2">
                    <p className="text-2xl font-semibold">
                      Your BMI: <span className="text-purple-600">{bmi}</span>
                    </p>
                    <p className={`text-lg ${getBMICategory(bmi).color}`}>
                      Category: {getBMICategory(bmi).category}
                    </p>
                    <p className="text-sm text-muted-foreground mt-2">
                      BMI Categories:<br />
                      Underweight: &lt; 18.5<br />
                      Normal weight: 18.5 - 24.9<br />
                      Overweight: 25 - 29.9<br />
                      Obese: ≥ 30
                    </p>
                  </div>
                )}
              </TabsContent>

              <TabsContent value="ideal" className="space-y-4">
                <div className="space-y-2">
                  <Label>Gender</Label>
                  <div className="flex gap-4">
                    <Button
                      variant={gender === "male" ? "default" : "outline"}
                      onClick={() => setGender("male")}
                      className="flex-1"
                    >
                      Male
                    </Button>
                    <Button
                      variant={gender === "female" ? "default" : "outline"}
                      onClick={() => setGender("female")}
                      className="flex-1"
                    >
                      Female
                    </Button>
                  </div>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="heightIdeal">Height (cm)</Label>
                  <Input
                    id="heightIdeal"
                    type="number"
                    value={heightForIdeal}
                    onChange={(e) => setHeightForIdeal(e.target.value)}
                    placeholder="Enter height in centimeters"
                  />
                </div>
                <Button
                  className="w-full !bg-[#4B0082] hover:!bg-[#3A0066] disabled:!bg-[#4B0082] disabled:!opacity-100"
                  onClick={calculateIdealWeight}
                  disabled={!heightForIdeal}
                >
                  Calculate Ideal Weight
                </Button>
                {idealWeight !== null && (
                  <div className="pt-4 text-center">
                    <p className="text-2xl font-semibold">
                      Ideal Weight: <span className="text-purple-600">{idealWeight} kg</span>
                    </p>
                    <p className="text-sm text-muted-foreground mt-2">
                      This is based on the Hamwi formula, which provides a rough estimate.<br />
                      Healthy weight can vary based on factors like body composition and activity level.
                    </p>
                  </div>
                )}
              </TabsContent>
            </Tabs>
          </CardContent>
        </Card>
      </div>

      {/* Bottom Banner Ad */}
      <AdBanner
        slot="0123456789"
        className="w-full max-w-[728px] h-[90px] mx-auto mt-8"
        format="horizontal"
      />
    </div>
  );
}