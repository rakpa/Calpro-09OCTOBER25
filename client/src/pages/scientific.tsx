import { useState } from "react";
import { Button } from "@/components/ui/button";
import AdBanner from "@/components/AdBanner";
import Seo from "@/components/Seo";

const buttons = [
  ["sin", "cos", "tan", "^"],
  ["7", "8", "9", "/"],
  ["4", "5", "6", "*"],
  ["1", "2", "3", "-"],
  ["0", ".", "=", "+"],
  ["(", ")", "π", "C"],
];

export default function Scientific() {
  const [display, setDisplay] = useState("0");
  const [operation, setOperation] = useState("");

  const handleInput = (value: string) => {
    if (value === "C") {
      setDisplay("0");
      setOperation("");
    } else if (value === "=") {
      try {
        let expr = display
          .replace(/π/g, Math.PI.toString())
          .replace(/sin/g, "Math.sin")
          .replace(/cos/g, "Math.cos")
          .replace(/tan/g, "Math.tan");
        const result = eval(expr);
        setDisplay(result.toString());
        setOperation("=");
      } catch (error) {
        setDisplay("Error");
      }
    } else {
      if (display === "0" || operation === "=") {
        setDisplay(value);
        setOperation("");
      } else {
        setDisplay(display + value);
      }
    }
  };

  // Clear all state
  const clearAll = () => {
    setDisplay("0");
    setOperation("");
  };

  return (
    <div className="min-h-screen bg-gray-50 p-2 sm:p-4 lg:p-6 font-inter">
      <Seo
        title="Scientific Calculator - Trigonometry and Advanced Math | CalcPro"
        description="Free online scientific calculator with trig functions (sin, cos, tan), exponents, parentheses and constants."
        keywords={["scientific calculator", "sin cos tan", "exponents calculator", "online calculator"]}
        canonicalPath="/scientific"
      />
      
      {/* Main Container */}
      <div className="max-w-7xl mx-auto">
        <div className="bg-white rounded-2xl shadow-lg p-4 sm:p-6 lg:p-8">
          {/* Header */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-6 sm:mb-8 gap-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 sm:w-12 sm:h-12 bg-purple-600 rounded-full flex items-center justify-center">
                <span className="text-white font-bold text-lg sm:text-xl">🔬</span>
              </div>
              <h1 className="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-900 font-inter">Scientific Calculator</h1>
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
            Perform trigonometry, powers, and more with a fast, mobile-friendly scientific calculator.
          </p>

          {/* Calculator Section */}
          <div className="max-w-md mx-auto">
            <div className="bg-white border border-gray-200 rounded-xl p-4 sm:p-6 lg:p-8 shadow-sm hover:shadow-md transition-shadow">
              <div className="bg-gray-100 p-4 sm:p-6 rounded-lg mb-6 text-right border-2 border-gray-200">
                <span className="text-2xl sm:text-3xl font-mono font-inter text-gray-900">{display}</span>
              </div>
              <div className="grid grid-cols-4 gap-3">
                {buttons.map((row, i) =>
                  row.map((btn) => (
                    <Button
                      key={btn}
                      className={`h-12 sm:h-14 text-base sm:text-lg font-inter font-semibold transition-all duration-200 ${
                        ["sin", "cos", "tan", "^", "(", ")", "π", "*", "/", "-", "+", "="].includes(btn) 
                          ? "!bg-[#4B0082] hover:!bg-[#3A0066] text-white" 
                          : "bg-gray-100 hover:bg-gray-200 text-gray-900 border border-gray-300"
                      }`}
                      onClick={() => handleInput(btn)}
                    >
                      {btn}
                    </Button>
                  ))
                )}
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Bottom Banner Ad */}
      <div className="mt-8">
        <AdBanner
          slot="5432109876"
          className="w-full max-w-[728px] h-[90px] mx-auto"
          format="horizontal"
          adType="banner"
        />
      </div>
    </div>
  );
}