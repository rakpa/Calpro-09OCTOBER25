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
    <div className="min-h-screen bg-gray-50 p-2 sm:p-4 lg:p-6 font-inter">
      <Seo
        title="Age Calculator - Calculate Exact Age in Years, Months, Days | CalcPro"
        description="Instantly calculate your exact age in years, months, and days, plus total days lived. Free online age calculator."
        keywords={["age calculator", "calculate age", "days lived", "exact age", "birth date calculator"]}
        canonicalPath="/age"
      />
      
      {/* Main Container */}
      <div className="max-w-7xl mx-auto">
        <div className="bg-white rounded-2xl shadow-lg p-4 sm:p-6 lg:p-8">
          {/* Header */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-6 sm:mb-8 gap-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 sm:w-12 sm:h-12 bg-purple-600 rounded-full flex items-center justify-center">
                <span className="text-white font-bold text-lg sm:text-xl">📅</span>
              </div>
              <h1 className="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-900 font-inter">Age Calculator</h1>
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
            Find your exact age in years, months, and days.
          </p>

          {/* Calculator Section */}
          <div className="max-w-md mx-auto">
            <div className="bg-white border border-gray-200 rounded-xl p-4 sm:p-6 lg:p-8 shadow-sm hover:shadow-md transition-shadow">
              <div className="space-y-6">
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Birth Date</label>
                    <Input
                      type="date"
                      className="w-full h-12 sm:h-14 text-base sm:text-lg font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                      value={birthDate}
                      onChange={(e) => setBirthDate(e.target.value)}
                    />
                  </div>
                  <div>
                    <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Calculate To Date</label>
                    <Input
                      type="date"
                      className="w-full h-12 sm:h-14 text-base sm:text-lg font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                      value={toDate}
                      onChange={(e) => setToDate(e.target.value)}
                    />
                  </div>
                </div>
                <Button
                  className="w-full h-12 sm:h-14 text-base sm:text-lg !bg-[#4B0082] hover:!bg-[#3A0066] disabled:!bg-[#4B0082] disabled:!opacity-100 text-white font-semibold rounded-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 font-inter"
                  onClick={calculateAge}
                  disabled={!birthDate || !toDate}
                >
                  Calculate Age
                </Button>
                {result && (
                  <div className="text-center pt-4 sm:pt-6">
                    <div className="bg-green-50 border border-green-200 rounded-lg p-4 sm:p-6">
                      <div className="grid grid-cols-3 gap-4 text-center mb-4">
                        <div>
                          <p className="text-sm sm:text-base text-green-700 font-inter">Years</p>
                          <p className="text-lg sm:text-2xl font-bold text-green-800 font-inter">
                            {result.years}
                          </p>
                        </div>
                        <div>
                          <p className="text-sm sm:text-base text-green-700 font-inter">Months</p>
                          <p className="text-lg sm:text-2xl font-bold text-green-800 font-inter">
                            {result.months}
                          </p>
                        </div>
                        <div>
                          <p className="text-sm sm:text-base text-green-700 font-inter">Days</p>
                          <p className="text-lg sm:text-2xl font-bold text-green-800 font-inter">
                            {result.days}
                          </p>
                        </div>
                      </div>
                      <div className="text-center pt-2 border-t border-green-200">
                        <p className="text-sm sm:text-base text-green-700 font-inter">Total Days</p>
                        <p className="text-lg sm:text-xl font-bold text-green-800 font-inter">{result.totalDays}</p>
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
          slot="0123456789"
          className="w-full max-w-[728px] h-[90px] mx-auto"
          format="horizontal"
          adType="banner"
        />
      </div>
    </div>
  );
}