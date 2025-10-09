import { useState, useEffect } from "react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { cn } from "@/lib/utils";
import AdBanner from "@/components/AdBanner";
import Seo from "@/components/Seo";

export default function Percentage() {
  // Separate state for each calculator section
  const [percentOf, setPercentOf] = useState({ value1: "", value2: "" });
  const [whatPercent, setWhatPercent] = useState({ value1: "", value2: "" });
  const [percentChange, setPercentChange] = useState({ value1: "", value2: "" });
  const [activeSection, setActiveSection] = useState<number>(0);
  const [result1, setResult1] = useState<number | null>(null);
  const [result2, setResult2] = useState<number | null>(null);
  const [result3, setResult3] = useState<number | null>(null);

  // Reset results when switching between sections
  useEffect(() => {
    setResult1(null);
    setResult2(null);
    setResult3(null);
  }, [activeSection]);

  const calculatePercentageOf = () => {
    const num = parseFloat(percentOf.value1);
    const percent = parseFloat(percentOf.value2);
    setResult1((num * percent) / 100);
  };

  const calculateWhatPercent = () => {
    const num = parseFloat(whatPercent.value1);
    const total = parseFloat(whatPercent.value2);
    setResult2((num / total) * 100);
  };

  const calculatePercentageChange = () => {
    const from = parseFloat(percentChange.value1);
    const to = parseFloat(percentChange.value2);
    setResult3(((to - from) / from) * 100);
  };

  // Helper function to determine if an input should be highlighted
  const shouldHighlight = (section: number, values: { value1: string, value2: string }) => {
    if (section !== activeSection) return false;
    return values.value1.length > 0 && values.value2.length === 0;
  };

  // Clear all inputs and results across sections
  const clearAll = () => {
    setPercentOf({ value1: "", value2: "" });
    setWhatPercent({ value1: "", value2: "" });
    setPercentChange({ value1: "", value2: "" });
    setResult1(null);
    setResult2(null);
    setResult3(null);
    setActiveSection(-1);
  };

  return (
    <div className="min-h-screen bg-gray-50 p-2 sm:p-4 lg:p-6 font-inter">
      <Seo
        title="Percentage Calculator - Find Percentages and Percentage Change | CalcPro"
        description="Calculate percentages easily: X% of Y, what percent X is of Y, and percentage increase/decrease. Free online percentage calculator."
        keywords={["percentage calculator", "% of", "percent change", "what percent"]}
        canonicalPath="/percentage"
      />
      
      {/* Main Container */}
      <div className="max-w-7xl mx-auto">
        <div className="bg-white rounded-2xl shadow-lg p-4 sm:p-6 lg:p-8">
          {/* Header */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-6 sm:mb-8 gap-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 sm:w-12 sm:h-12 bg-purple-600 rounded-full flex items-center justify-center">
                <span className="text-white font-bold text-lg sm:text-xl">%</span>
              </div>
              <h1 className="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-900">Percentage Calculator</h1>
            </div>
            <Button 
              variant="outline" 
              onClick={clearAll}
              className="px-3 py-2 text-sm border-gray-300 hover:bg-gray-50 w-full sm:w-auto"
            >
              Clear All
            </Button>
          </div>

          <p className="text-gray-600 mb-6 sm:mb-8 text-sm sm:text-base">
            Solve common percentage problems in seconds: compute X% of Y, what percent one number is of another, and the percentage increase or decrease.
          </p>

          {/* Calculator Sections */}
          <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-4 sm:gap-6 lg:gap-8" style={{ gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))' }}>
          {/* Calculate X% of Y */}
          <div className="bg-white border border-gray-200 rounded-xl p-4 sm:p-6 lg:p-8 shadow-sm hover:shadow-md transition-shadow">
            <div className="h-16 sm:h-20 mb-6 sm:mb-8">
              <div className="flex items-center gap-3 sm:gap-4">
                <div className="w-10 h-10 sm:w-12 sm:h-12 bg-green-100 rounded-full flex items-center justify-center">
                  <span className="text-green-600 font-bold text-base sm:text-lg">%</span>
                </div>
                <h3 className="text-lg sm:text-xl font-semibold text-gray-900 font-inter whitespace-nowrap">What is X% of Y?</h3>
              </div>
            </div>
            
            <div className="space-y-6">
              <div className="space-y-4">
                <div>
                  <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">What is</label>
                  <Input
                    type="number"
                    placeholder="0"
                    className="w-full h-12 sm:h-14 text-lg sm:text-xl font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                    value={percentOf.value1}
                    onChange={(e) => {
                      setPercentOf(prev => ({ ...prev, value1: e.target.value }));
                      setActiveSection(0);
                    }}
                  />
                </div>
                
                <div className="text-center text-gray-500 font-medium font-inter text-base sm:text-lg">% of</div>
                
                <div>
                  <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Number</label>
                  <Input
                    type="number"
                    placeholder="0"
                    className={cn(
                      "w-full h-12 sm:h-14 text-lg sm:text-xl font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4",
                      shouldHighlight(0, percentOf) && "ring-2 ring-primary ring-offset-2"
                    )}
                    value={percentOf.value2}
                    onChange={(e) => setPercentOf(prev => ({ ...prev, value2: e.target.value }))}
                  />
                </div>
              </div>
              
              <Button 
                onClick={calculatePercentageOf}
                disabled={!percentOf.value1 || !percentOf.value2}
                className="w-full h-12 sm:h-14 text-base sm:text-lg !bg-[#4B0082] hover:!bg-[#3A0066] disabled:!bg-[#4B0082] disabled:!opacity-100 text-white font-semibold rounded-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 font-inter"
              >
                Calculate
              </Button>
            </div>
            {result1 !== null && (
              <div className="text-center pt-4 sm:pt-6">
                <div className="bg-green-50 border border-green-200 rounded-lg p-4 sm:p-6">
                  <p className="text-lg sm:text-2xl font-bold text-green-800">
                    Result: <span className="text-xl sm:text-3xl">{result1.toFixed(2)}</span>
                  </p>
                </div>
              </div>
            )}
          </div>



          {/* Calculate what percent X is of Y */}
          <div className="bg-white border border-gray-200 rounded-xl p-4 sm:p-6 lg:p-8 shadow-sm hover:shadow-md transition-shadow">
            <div className="h-16 sm:h-20 mb-6 sm:mb-8">
              <div className="flex items-center gap-3 sm:gap-4">
                <div className="w-10 h-10 sm:w-12 sm:h-12 bg-blue-100 rounded-full flex items-center justify-center">
                  <span className="text-blue-600 font-bold text-base sm:text-lg">?</span>
                </div>
                <h3 className="text-lg sm:text-xl font-semibold text-gray-900 font-inter whitespace-nowrap">X is what percent of Y?</h3>
              </div>
            </div>
            
            <div className="space-y-6">
              <div className="space-y-4">
                <div>
                  <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Number</label>
                  <Input
                    type="number"
                    placeholder="0"
                    className="w-full h-12 sm:h-14 text-lg sm:text-xl font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                    value={whatPercent.value1}
                    onChange={(e) => {
                      setWhatPercent(prev => ({ ...prev, value1: e.target.value }));
                      setActiveSection(1);
                    }}
                  />
                </div>
                
                <div className="text-center text-gray-500 font-medium font-inter text-base sm:text-lg">is what percent of</div>
                
                <div>
                  <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Total</label>
                  <Input
                    type="number"
                    placeholder="0"
                    className={cn(
                      "w-full h-12 sm:h-14 text-lg sm:text-xl font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4",
                      shouldHighlight(1, whatPercent) && "ring-2 ring-primary ring-offset-2"
                    )}
                    value={whatPercent.value2}
                    onChange={(e) => setWhatPercent(prev => ({ ...prev, value2: e.target.value }))}
                  />
                </div>
              </div>
              
              <Button 
                onClick={calculateWhatPercent}
                disabled={!whatPercent.value1 || !whatPercent.value2}
                className="w-full h-12 sm:h-14 text-base sm:text-lg !bg-[#4B0082] hover:!bg-[#3A0066] disabled:!bg-[#4B0082] disabled:!opacity-100 text-white font-semibold rounded-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 font-inter"
              >
                Calculate
              </Button>
            </div>
            {result2 !== null && (
              <div className="text-center pt-4 sm:pt-6">
                <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 sm:p-6">
                  <p className="text-lg sm:text-2xl font-bold text-blue-800">
                    Result: <span className="text-xl sm:text-3xl">{result2.toFixed(2)}%</span>
                  </p>
                </div>
              </div>
            )}
          </div>

          {/* Calculate percentage increase/decrease */}
          <div className="bg-white border border-gray-200 rounded-xl p-4 sm:p-6 lg:p-8 shadow-sm hover:shadow-md transition-shadow overflow-hidden">
            <div className="h-16 sm:h-20 mb-6 sm:mb-8">
              <div className="flex items-center gap-3 sm:gap-4">
                <div className="w-10 h-10 sm:w-12 sm:h-12 bg-orange-100 rounded-full flex items-center justify-center">
                  <span className="text-orange-600 font-bold text-base sm:text-lg">↗</span>
                </div>
                <h3 className="text-lg sm:text-xl font-semibold text-gray-900 font-inter">Percentage Change</h3>
              </div>
            </div>
            
            <div className="space-y-6">
              <div className="space-y-4">
                <div>
                  <p className="text-sm sm:text-base text-gray-600 font-inter whitespace-nowrap mb-2 sm:mb-3">
                    What is the percentage increase/decrease from
                  </p>
                  <Input
                    type="number"
                    placeholder="0"
                    className="w-full h-12 sm:h-14 text-lg sm:text-xl font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                    value={percentChange.value1}
                    onChange={(e) => {
                      setPercentChange(prev => ({ ...prev, value1: e.target.value }));
                      setActiveSection(2);
                    }}
                  />
                </div>
                
                <div className="text-center text-gray-500 font-medium font-inter text-base sm:text-lg">to</div>
                
                <div>
                  <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">To</label>
                  <Input
                    type="number"
                    placeholder="0"
                    className={cn(
                      "w-full h-12 sm:h-14 text-lg sm:text-xl font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4",
                      shouldHighlight(2, percentChange) && "ring-2 ring-primary ring-offset-2"
                    )}
                    value={percentChange.value2}
                    onChange={(e) => setPercentChange(prev => ({ ...prev, value2: e.target.value }))}
                  />
                </div>
              </div>
              
              <Button 
                onClick={calculatePercentageChange}
                disabled={!percentChange.value1 || !percentChange.value2}
                className="w-full h-12 sm:h-14 text-base sm:text-lg !bg-[#4B0082] hover:!bg-[#3A0066] disabled:!bg-[#4B0082] disabled:!opacity-100 text-white font-semibold rounded-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 font-inter"
              >
                Calculate
              </Button>
            </div>
            {result3 !== null && (
              <div className="text-center pt-4 sm:pt-6">
                <div className={`border rounded-lg p-4 sm:p-6 ${
                  result3 > 0 
                    ? 'bg-green-50 border-green-200' 
                    : result3 < 0 
                    ? 'bg-red-50 border-red-200' 
                    : 'bg-gray-50 border-gray-200'
                }`}>
                  <p className={`text-lg sm:text-2xl font-bold ${
                    result3 > 0 
                      ? 'text-green-800' 
                      : result3 < 0 
                      ? 'text-red-800' 
                      : 'text-gray-800'
                  }`}>
                    Result: <span className="text-xl sm:text-3xl">{result3 > 0 ? "+" : ""}{result3.toFixed(2)}%</span>
                  </p>
                </div>
              </div>
            )}
          </div>
          </div>
        </div>
      </div>

      {/* Bottom Banner Ad */}
      <div className="mt-8">
        <AdBanner
          slot="3456789012"
          className="w-full max-w-[728px] h-[90px] mx-auto"
          format="horizontal"
          adType="banner"
        />
      </div>
    </div>
  );
}