import { useState } from "react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import AdBanner from "@/components/AdBanner";
import Seo from "@/components/Seo";

export default function Discount() {
  // Single Discount Calculator State
  const [originalPrice, setOriginalPrice] = useState("");
  const [discountPercent, setDiscountPercent] = useState("");
  const [result, setResult] = useState<{
    finalPrice: number;
    savedAmount: number;
  } | null>(null);

  // Multiple Discounts Calculator State
  const [basePrice, setBasePrice] = useState("");
  const [discounts, setDiscounts] = useState(["", "", ""]);
  const [multipleResult, setMultipleResult] = useState<{
    finalPrice: number;
    totalSaved: number;
    discountBreakdown: number[];
  } | null>(null);

  const calculateSingleDiscount = () => {
    const price = parseFloat(originalPrice);
    const discount = parseFloat(discountPercent);
    const savedAmount = (price * discount) / 100;
    const finalPrice = price - savedAmount;

    setResult({
      finalPrice: parseFloat(finalPrice.toFixed(2)),
      savedAmount: parseFloat(savedAmount.toFixed(2)),
    });
  };

  const calculateMultipleDiscounts = () => {
    const price = parseFloat(basePrice);
    let currentPrice = price;
    const savings: number[] = [];

    discounts.forEach((discount) => {
      if (discount) {
        const discountAmount = (currentPrice * parseFloat(discount)) / 100;
        savings.push(parseFloat(discountAmount.toFixed(2)));
        currentPrice -= discountAmount;
      }
    });

    const totalSaved = savings.reduce((acc, curr) => acc + curr, 0);

    setMultipleResult({
      finalPrice: parseFloat(currentPrice.toFixed(2)),
      totalSaved: parseFloat(totalSaved.toFixed(2)),
      discountBreakdown: savings,
    });
  };

  // Clear all inputs and results
  const clearAll = () => {
    setOriginalPrice("");
    setDiscountPercent("");
    setResult(null);
    setBasePrice("");
    setDiscounts(["", "", ""]);
    setMultipleResult(null);
  };

  return (
    <div className="min-h-screen bg-gray-50 p-2 sm:p-4 lg:p-6 font-inter">
      <Seo
        title="Discount Calculator - Single and Multiple Discounts | CalcPro"
        description="Calculate sale price and savings with single or multiple discounts. Free online discount calculator."
        keywords={["discount calculator", "sale price", "percent off", "multiple discounts"]}
        canonicalPath="/discount"
      />
      
      {/* Main Container */}
      <div className="max-w-7xl mx-auto">
        <div className="bg-white rounded-2xl shadow-lg p-4 sm:p-6 lg:p-8">
          {/* Header */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-6 sm:mb-8 gap-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 sm:w-12 sm:h-12 bg-purple-600 rounded-full flex items-center justify-center">
                <span className="text-white font-bold text-lg sm:text-xl">🏷️</span>
              </div>
              <h1 className="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-900 font-inter">Discount Calculator</h1>
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
            Work out final price after a single discount or multiple sequential discounts, and see how much you save.
          </p>

          {/* Calculator Section */}
          <div className="max-w-2xl mx-auto">
            <div className="bg-white border border-gray-200 rounded-xl p-4 sm:p-6 lg:p-8 shadow-sm hover:shadow-md transition-shadow">
              <Tabs defaultValue="single" className="space-y-6">
                <TabsList className="grid w-full grid-cols-2 bg-gray-100 font-inter">
                  <TabsTrigger value="single" className="font-inter">Single Discount</TabsTrigger>
                  <TabsTrigger value="multiple" className="font-inter">Multiple Discounts</TabsTrigger>
                </TabsList>

                <TabsContent value="single" className="space-y-6">
                  <div className="space-y-4">
                    <div>
                      <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Original Price ($)</label>
                      <Input
                        type="number"
                        placeholder="0"
                        className="w-full h-12 sm:h-14 text-base sm:text-lg font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                        value={originalPrice}
                        onChange={(e) => setOriginalPrice(e.target.value)}
                      />
                    </div>
                    <div>
                      <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Discount Percentage (%)</label>
                      <Input
                        type="number"
                        placeholder="0"
                        className="w-full h-12 sm:h-14 text-base sm:text-lg font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                        value={discountPercent}
                        onChange={(e) => setDiscountPercent(e.target.value)}
                      />
                    </div>
                  </div>
                  <Button
                    className="w-full h-12 sm:h-14 text-base sm:text-lg !bg-[#4B0082] hover:!bg-[#3A0066] disabled:!bg-[#4B0082] disabled:!opacity-100 text-white font-semibold rounded-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 font-inter"
                    onClick={calculateSingleDiscount}
                    disabled={!originalPrice || !discountPercent}
                  >
                    Calculate Discount
                  </Button>
                  {result && (
                    <div className="text-center pt-4 sm:pt-6">
                      <div className="bg-green-50 border border-green-200 rounded-lg p-4 sm:p-6">
                        <p className="text-lg sm:text-2xl font-bold text-green-800 font-inter">
                          Final Price: <span className="text-xl sm:text-3xl">${result.finalPrice}</span>
                        </p>
                        <p className="text-sm sm:text-base text-green-700 font-inter mt-2">
                          You Save: ${result.savedAmount}
                        </p>
                      </div>
                    </div>
                  )}
              </TabsContent>

                <TabsContent value="multiple" className="space-y-6">
                  <div className="space-y-4">
                    <div>
                      <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">Original Price ($)</label>
                      <Input
                        type="number"
                        placeholder="0"
                        className="w-full h-12 sm:h-14 text-base sm:text-lg font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                        value={basePrice}
                        onChange={(e) => setBasePrice(e.target.value)}
                      />
                    </div>
                    {discounts.map((discount, index) => (
                      <div key={index}>
                        <label className="block text-sm sm:text-base font-medium text-gray-700 font-inter mb-2 sm:mb-3">
                          Discount {index + 1} Percentage (%)
                        </label>
                        <Input
                          type="number"
                          placeholder="0"
                          className="w-full h-12 sm:h-14 text-base sm:text-lg font-inter text-black border-2 border-gray-200 focus:border-purple-500 focus:ring-2 focus:ring-purple-200 rounded-lg px-3 sm:px-4"
                          value={discount}
                          onChange={(e) => {
                            const newDiscounts = [...discounts];
                            newDiscounts[index] = e.target.value;
                            setDiscounts(newDiscounts);
                          }}
                        />
                      </div>
                    ))}
                  </div>
                  <Button
                    className="w-full h-12 sm:h-14 text-base sm:text-lg !bg-[#4B0082] hover:!bg-[#3A0066] disabled:!bg-[#4B0082] disabled:!opacity-100 text-white font-semibold rounded-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 font-inter"
                    onClick={calculateMultipleDiscounts}
                    disabled={!basePrice || !discounts.some(d => d !== "")}
                  >
                    Calculate Multiple Discounts
                  </Button>
                  {multipleResult && (
                    <div className="text-center pt-4 sm:pt-6">
                      <div className="bg-green-50 border border-green-200 rounded-lg p-4 sm:p-6">
                        <p className="text-lg sm:text-2xl font-bold text-green-800 font-inter">
                          Final Price: <span className="text-xl sm:text-3xl">${multipleResult.finalPrice}</span>
                        </p>
                        <p className="text-sm sm:text-base text-green-700 font-inter mt-2">
                          Total Savings: ${multipleResult.totalSaved}
                        </p>
                        <div className="mt-4 text-sm sm:text-base text-green-700 font-inter">
                          <p className="font-medium">Savings Breakdown:</p>
                          {multipleResult.discountBreakdown.map((saving, index) => (
                            saving > 0 && (
                              <p key={index} className="mt-1">
                                Discount {index + 1}: ${saving}
                              </p>
                            )
                          ))}
                        </div>
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
          slot="4567890123"
          className="w-full max-w-[728px] h-[90px] mx-auto"
          format="horizontal"
          adType="banner"
        />
      </div>
    </div>
  );
}
