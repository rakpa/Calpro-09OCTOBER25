import { useState } from "react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import AdBanner from "@/components/AdBanner";
import Seo from "@/components/Seo";

export default function DateDiff() {
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [result, setResult] = useState<{
    days: number;
    months: number;
    years: number;
  } | null>(null);

  const calculateDifference = () => {
    const start = new Date(startDate);
    const end = new Date(endDate);
    
    // Calculate the time difference
    const diffTime = Math.abs(end.getTime() - start.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    
    // Calculate years and remaining days
    const years = Math.floor(diffDays / 365);
    const remainingDays = diffDays % 365;
    
    // Calculate months (approximate)
    const months = Math.floor(remainingDays / 30);
    const days = remainingDays % 30;

    setResult({
      days,
      months,
      years
    });
  };

  // Clear inputs and result
  const clearAll = () => {
    setStartDate("");
    setEndDate("");
    setResult(null);
  };

  return (
    <div className="min-h-screen bg-gray-50 p-2 sm:p-4 lg:p-6 font-inter">
      <Seo
        title="Date Difference Calculator - Days, Months, Years Between Dates | CalcPro"
        description="Quickly calculate the exact number of days, months, and years between two dates. Useful for planning timelines, deadlines, and age differences."
        keywords={["date difference calculator", "days between dates", "months between dates", "years between dates", "time between dates"]}
        canonicalPath="/date-diff"
      />
      
      {/* Main Container */}
      <div className="max-w-7xl mx-auto">
        <div className="bg-white rounded-2xl shadow-lg p-4 sm:p-6 lg:p-8">
          {/* Header */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-6 sm:mb-8 gap-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 sm:w-12 sm:h-12 bg-purple-600 rounded-full flex items-center justify-center">
                <span className="text-white font-bold text-lg sm:text-xl">📊</span>
              </div>
              <h1 className="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-900 font-inter">Date Difference Calculator</h1>
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
            Find the number of days, months, and years between two dates. Enter a start and end date to get precise results for schedules, events, anniversaries, and more.
          </p>

          {/* Calculator Section */}
          <div className="max-w-md mx-auto">
            <div className="bg-white border border-gray-200 rounded-xl p-4 sm:p-6 lg:p-8 shadow-sm hover:shadow-md transition-shadow">
              <div className="space-y-6">
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Start Date</label>
                    <Input
                      type="date"
                      className="w-full h-12 sm:h-14 text-base sm:text-lg font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                      value={startDate}
                      onChange={(e) => setStartDate(e.target.value)}
                    />
                  </div>
                  <div>
                    <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">End Date</label>
                    <Input
                      type="date"
                      className="w-full h-12 sm:h-14 text-base sm:text-lg font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                      value={endDate}
                      onChange={(e) => setEndDate(e.target.value)}
                    />
                  </div>
                </div>
                <Button
                  className="w-full h-12 sm:h-14 text-base sm:text-lg !bg-[#4B0082] hover:!bg-[#3A0066] disabled:!bg-[#4B0082] disabled:!opacity-100 text-white font-semibold rounded-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 font-inter"
                  onClick={calculateDifference}
                  disabled={!startDate || !endDate}
                >
                  Calculate Difference
                </Button>
                {result && (
                  <div className="text-center pt-4 sm:pt-6">
                    <div className="bg-green-50 border border-green-200 rounded-lg p-4 sm:p-6">
                      <div className="grid grid-cols-3 gap-4 text-center">
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
          slot="3456789012"
          className="w-full max-w-[728px] h-[90px] mx-auto"
          format="horizontal"
          adType="banner"
        />
      </div>
    </div>
  );
}
