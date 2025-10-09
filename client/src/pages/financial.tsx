import { useState } from "react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import AdBanner from "@/components/AdBanner";
import Seo from "@/components/Seo";

export default function Financial() {
  const [principal, setPrincipal] = useState("");
  const [rate, setRate] = useState("");
  const [time, setTime] = useState("");
  const [result, setResult] = useState<number | null>(null);

  const calculateCompoundInterest = () => {
    const p = parseFloat(principal);
    const r = parseFloat(rate) / 100;
    const t = parseFloat(time);
    const amount = p * Math.pow(1 + r, t);
    setResult(parseFloat(amount.toFixed(2)));
  };

  // Clear inputs and result
  const clearAll = () => {
    setPrincipal("");
    setRate("");
    setTime("");
    setResult(null);
  };

  return (
    <div className="min-h-screen bg-gray-50 p-2 sm:p-4 lg:p-6 font-inter">
      <Seo
        title="Compound Interest Calculator - Free Financial Calculator | CalcPro"
        description="Calculate compound interest and future value over years with this free financial calculator. Plan investments and savings growth."
        keywords={["compound interest calculator", "future value", "investment calculator", "financial calculator"]}
        canonicalPath="/financial"
      />
      
      {/* Main Container */}
      <div className="max-w-7xl mx-auto">
        <div className="bg-white rounded-2xl shadow-lg p-4 sm:p-6 lg:p-8">
          {/* Header */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-6 sm:mb-8 gap-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 sm:w-12 sm:h-12 bg-purple-600 rounded-full flex items-center justify-center">
                <span className="text-white font-bold text-lg sm:text-xl">$</span>
              </div>
              <h1 className="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-900 font-inter">Compound Interest Calculator</h1>
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
            Estimate the future value of investments using compound interest. Enter principal, annual rate, and years to project growth.
          </p>

          {/* Calculator Section */}
          <div className="max-w-md mx-auto">
            <div className="bg-white border border-gray-200 rounded-xl p-4 sm:p-6 lg:p-8 shadow-sm hover:shadow-md transition-shadow">
              <div className="space-y-6">
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Principal Amount</label>
                    <Input
                      type="number"
                      placeholder="0"
                      className="w-full h-12 sm:h-14 text-lg sm:text-xl font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                      value={principal}
                      onChange={(e) => setPrincipal(e.target.value)}
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Annual Interest Rate (%)</label>
                    <Input
                      type="number"
                      placeholder="0"
                      className="w-full h-12 sm:h-14 text-lg sm:text-xl font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                      value={rate}
                      onChange={(e) => setRate(e.target.value)}
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Time (Years)</label>
                    <Input
                      type="number"
                      placeholder="0"
                      className="w-full h-12 sm:h-14 text-lg sm:text-xl font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                      value={time}
                      onChange={(e) => setTime(e.target.value)}
                    />
                  </div>
                </div>
                <Button
                  className="w-full h-12 sm:h-14 text-base sm:text-lg !bg-[#4B0082] hover:!bg-[#3A0066] disabled:!bg-[#4B0082] disabled:!opacity-100 text-white font-semibold rounded-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 font-inter"
                  onClick={calculateCompoundInterest}
                  disabled={!principal || !rate || !time}
                >
                  Calculate
                </Button>
              </div>
              {result !== null && (
                <div className="text-center pt-4 sm:pt-6">
                  <div className="bg-green-50 border border-green-200 rounded-lg p-4 sm:p-6">
                    <p className="text-lg sm:text-2xl font-bold text-green-800 font-inter">
                      Future Value: <span className="text-xl sm:text-3xl">${result.toFixed(2)}</span>
                    </p>
                    <p className="text-sm sm:text-base text-green-700 font-inter mt-2">
                      Interest Earned: ${(result - parseFloat(principal)).toFixed(2)}
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