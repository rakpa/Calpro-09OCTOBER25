import { useState } from "react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import AdBanner from "@/components/AdBanner";
import Seo from "@/components/Seo";

export default function Time() {
  const [startTime, setStartTime] = useState("");
  const [endTime, setEndTime] = useState("");
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [timeDifference, setTimeDifference] = useState<string | null>(null);
  const [daysDifference, setDaysDifference] = useState<number | null>(null);

  const calculateTimeDifference = () => {
    const start = new Date(`1970/01/01 ${startTime}`);
    const end = new Date(`1970/01/01 ${endTime}`);

    let diff = end.getTime() - start.getTime();
    if (diff < 0) {
      diff += 24 * 60 * 60 * 1000;
    }

    const hours = Math.floor(diff / (1000 * 60 * 60));
    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));

    setTimeDifference(`${hours} hours and ${minutes} minutes`);
  };

  const calculateDaysBetween = () => {
    const start = new Date(startDate);
    const end = new Date(endDate);
    const diffTime = Math.abs(end.getTime() - start.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    setDaysDifference(diffDays);
  };

  // Clear inputs and results
  const clearAll = () => {
    setStartTime("");
    setEndTime("");
    setStartDate("");
    setEndDate("");
    setTimeDifference(null);
    setDaysDifference(null);
  };

  return (
    <div className="min-h-screen bg-gray-50 p-2 sm:p-4 lg:p-6 font-inter">
      <Seo
        title="Time Calculator - Time Difference and Days Between Dates | CalcPro"
        description="Calculate time differences between two times and find the number of days between dates. Free online time calculator."
        keywords={["time difference calculator", "hours and minutes", "days between dates", "time calculator"]}
        canonicalPath="/time"
      />
      
      {/* Main Container */}
      <div className="max-w-7xl mx-auto">
        <div className="bg-white rounded-2xl shadow-lg p-4 sm:p-6 lg:p-8">
          {/* Header */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-6 sm:mb-8 gap-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 sm:w-12 sm:h-12 bg-purple-600 rounded-full flex items-center justify-center">
                <span className="text-white font-bold text-lg sm:text-xl">⏰</span>
              </div>
              <h1 className="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-900 font-inter">Time Calculator</h1>
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
            Compute hours and minutes between two times, and quickly find the number of days between dates.
          </p>

          {/* Calculator Section */}
          <div className="max-w-md mx-auto">
            <div className="bg-white border border-gray-200 rounded-xl p-4 sm:p-6 lg:p-8 shadow-sm hover:shadow-md transition-shadow">
              <Tabs defaultValue="time" className="space-y-6">
                <TabsList className="grid w-full grid-cols-2 bg-gray-100 font-inter">
                  <TabsTrigger value="time" className="font-inter">Time Difference</TabsTrigger>
                  <TabsTrigger value="days" className="font-inter">Days Between</TabsTrigger>
                </TabsList>

                <TabsContent value="time" className="space-y-6">
                  <div className="space-y-4">
                    <div>
                      <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Start Time</label>
                      <Input
                        type="time"
                        className="w-full h-12 sm:h-14 text-base sm:text-lg font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                        value={startTime}
                        onChange={(e) => setStartTime(e.target.value)}
                      />
                    </div>
                    <div>
                      <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">End Time</label>
                      <Input
                        type="time"
                        className="w-full h-12 sm:h-14 text-base sm:text-lg font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                        value={endTime}
                        onChange={(e) => setEndTime(e.target.value)}
                      />
                    </div>
                  </div>
                  <Button
                    className="w-full h-12 sm:h-14 text-base sm:text-lg !bg-[#4B0082] hover:!bg-[#3A0066] disabled:!bg-[#4B0082] disabled:!opacity-100 text-white font-semibold rounded-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 font-inter"
                    onClick={calculateTimeDifference}
                    disabled={!startTime || !endTime}
                  >
                    Calculate Time Difference
                  </Button>
                  {timeDifference && (
                    <div className="text-center pt-4 sm:pt-6">
                      <div className="bg-green-50 border border-green-200 rounded-lg p-4 sm:p-6">
                        <p className="text-lg sm:text-2xl font-bold text-green-800 font-inter">
                          Time Difference: <span className="text-xl sm:text-3xl">{timeDifference}</span>
                        </p>
                      </div>
                    </div>
                  )}
              </TabsContent>

                <TabsContent value="days" className="space-y-6">
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
                    onClick={calculateDaysBetween}
                    disabled={!startDate || !endDate}
                  >
                    Calculate Days Between
                  </Button>
                  {daysDifference !== null && (
                    <div className="text-center pt-4 sm:pt-6">
                      <div className="bg-green-50 border border-green-200 rounded-lg p-4 sm:p-6">
                        <p className="text-lg sm:text-2xl font-bold text-green-800 font-inter">
                          Days Between: <span className="text-xl sm:text-3xl">{daysDifference} days</span>
                        </p>
                      </div>
                    </div>
                  )}
                </TabsContent>
              </Tabs>
            </div>
          </div>
        </div>
      </div>

      {/* Bottom Banner Ad */}
      <div className="mt-8">
        <AdBanner
          slot="0987654321"
          className="w-full max-w-[728px] h-[90px] mx-auto"
          format="horizontal"
          adType="banner"
        />
      </div>
    </div>
  );
}