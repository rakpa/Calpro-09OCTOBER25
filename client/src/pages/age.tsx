import { useState } from "react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import AdBanner from "@/components/AdBanner";
import Seo from "@/components/Seo";

export default function Age() {
  const [birthDate, setBirthDate] = useState("");
  const [toDate, setToDate] = useState(new Date().toISOString().split('T')[0]);
  const [result, setResult] = useState<{
    years: number;
    months: number;
    days: number;
    totalDays: number;
  } | null>(null);

  const calculateAge = () => {
    const birth = new Date(birthDate);
    const end = new Date(toDate);

    // Calculate the time difference
    const diffTime = Math.abs(end.getTime() - birth.getTime());
    const totalDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    // Calculate years
    const years = Math.floor(totalDays / 365);

    // Calculate months
    const months = Math.floor((totalDays % 365) / 30);

    // Calculate remaining days
    const days = totalDays % 30;

    setResult({
      years,
      months,
      days,
      totalDays,
    });
  };

  // Clear all inputs and results
  const clearAll = () => {
    setBirthDate("");
    setToDate("");
    setResult(null);
  };

  return (
    <div className="min-h-screen bg-gray-50 font-inter">
      <Seo
        title="Age Calculator - Calculate Exact Age in Years, Months, Days | CalcPro"
        description="Instantly calculate your exact age in years, months, and days, plus total days lived. Free online age calculator."
        keywords={["age calculator", "calculate age", "days lived", "exact age", "birth date calculator"]}
        canonicalPath="/age"
      />
      
      {/* Main Container */}
      <div className="max-w-4xl mx-auto p-4 sm:p-6">
        <div className="bg-white rounded-2xl shadow-lg overflow-hidden">
          {/* Header */}
          <div className="bg-gradient-to-r from-purple-600 to-purple-700 p-4 sm:p-6">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 bg-white/20 rounded-full flex items-center justify-center">
                  <span className="text-white font-bold text-xl">📅</span>
                </div>
                <div>
                  <h1 className="text-2xl sm:text-3xl font-bold text-white font-inter">Age Calculator</h1>
                  <p className="text-purple-100 text-sm sm:text-base mt-1">
                    Find your exact age in years, months, and days
                  </p>
                </div>
              </div>
              <Button 
                variant="outline" 
                onClick={clearAll}
                className="bg-white/10 border-white/20 text-white hover:bg-white/20 px-4 py-2 text-sm font-inter"
              >
                Clear All
              </Button>
            </div>
          </div>

          {/* Calculator Section */}
          <div className="p-4 sm:p-6">
            <div className="space-y-6">
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 font-inter mb-2">Birth Date</label>
                  <Input
                    type="date"
                    className="w-full h-12 text-base font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3"
                    value={birthDate}
                    onChange={(e) => setBirthDate(e.target.value)}
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 font-inter mb-2">Calculate To Date</label>
                  <Input
                    type="date"
                    className="w-full h-12 text-base font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3"
                    value={toDate}
                    onChange={(e) => setToDate(e.target.value)}
                  />
                </div>
              </div>
              <Button
                className="w-full h-12 text-base !bg-purple-600 hover:!bg-purple-700 text-white font-semibold rounded-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 font-inter"
                onClick={calculateAge}
                disabled={!birthDate || !toDate}
              >
                Calculate Age
              </Button>
              {result && (
                <div className="mt-6">
                  <div className="bg-green-50 border border-green-200 rounded-lg p-4">
                    <div className="grid grid-cols-3 gap-2 sm:gap-4 text-center mb-4">
                      <div>
                        <p className="text-xs sm:text-sm text-green-700 font-inter">Years</p>
                        <p className="text-lg sm:text-2xl font-bold text-green-800 font-inter">
                          {result.years}
                        </p>
                      </div>
                      <div>
                        <p className="text-xs sm:text-sm text-green-700 font-inter">Months</p>
                        <p className="text-lg sm:text-2xl font-bold text-green-800 font-inter">
                          {result.months}
                        </p>
                      </div>
                      <div>
                        <p className="text-xs sm:text-sm text-green-700 font-inter">Days</p>
                        <p className="text-lg sm:text-2xl font-bold text-green-800 font-inter">
                          {result.days}
                        </p>
                      </div>
                    </div>
                    <div className="text-center pt-3 border-t border-green-200">
                      <p className="text-xs sm:text-sm text-green-700 font-inter">Total Days</p>
                      <p className="text-base sm:text-xl font-bold text-green-800 font-inter">{result.totalDays}</p>
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Bottom Banner Ad */}
      <div className="px-4 pb-4">
        <AdBanner
          slot="0123456789"
          className="w-full max-w-[728px] h-[90px] mx-auto"
          format="horizontal"
          adType="banner"
        />
      </div>
    </div>
  );
}