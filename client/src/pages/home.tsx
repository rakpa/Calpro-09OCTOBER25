import { Link } from "wouter";
import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
} from "@/components/ui/card";
import {
  Percent,
  Calculator,
  ArrowUpDown,
  DollarSign,
  FlaskConical,
  Clock,
  Home as HomeIcon,
  Calendar,
  Tag,
  CalendarDays,
} from "lucide-react";
import AdBanner from "@/components/AdBanner";
import Seo from "@/components/Seo";

const calculators = [
  {
    title: "Percentage Calculator",
    description: "Calculate percentages and proportions",
    icon: Percent,
    href: "/percentage",
    gradient: "from-emerald-400 to-teal-500",
    iconColor: "text-white",
    bgColor: "bg-gradient-to-br from-emerald-400 to-teal-500",
  },
  {
    title: "Basic Calculator",
    description: "Simple arithmetic calculations",
    icon: Calculator,
    href: "/basic",
    gradient: "from-blue-400 to-indigo-600",
    iconColor: "text-white",
    bgColor: "bg-gradient-to-br from-blue-400 to-indigo-600",
  },
  {
    title: "Unit Converter",
    description: "Convert between different units",
    icon: ArrowUpDown,
    href: "/convert",
    gradient: "from-purple-400 to-violet-600",
    iconColor: "text-white",
    bgColor: "bg-gradient-to-br from-purple-400 to-violet-600",
  },
  {
    title: "Financial Calculator",
    description: "Calculate loans, interest and more",
    icon: DollarSign,
    href: "/financial",
    gradient: "from-amber-400 to-orange-500",
    iconColor: "text-white",
    bgColor: "bg-gradient-to-br from-amber-400 to-orange-500",
  },
  {
    title: "Mortgage Calculator",
    description: "Calculate monthly mortgage payments",
    icon: HomeIcon,
    href: "/mortgage",
    gradient: "from-rose-400 to-pink-600",
    iconColor: "text-white",
    bgColor: "bg-gradient-to-br from-rose-400 to-pink-600",
  },
  {
    title: "Age Calculator",
    description: "Calculate exact age and date differences",
    icon: Calendar,
    href: "/age",
    gradient: "from-cyan-400 to-blue-500",
    iconColor: "text-white",
    bgColor: "bg-gradient-to-br from-cyan-400 to-blue-500",
  },
  {
    title: "Scientific Calculator",
    description: "Advanced mathematical calculations",
    icon: FlaskConical,
    href: "/scientific",
    gradient: "from-fuchsia-400 to-purple-600",
    iconColor: "text-white",
    bgColor: "bg-gradient-to-br from-fuchsia-400 to-purple-600",
  },
  {
    title: "Time Calculator",
    description: "Calculate time differences and durations",
    icon: Clock,
    href: "/time",
    gradient: "from-lime-400 to-green-500",
    iconColor: "text-white",
    bgColor: "bg-gradient-to-br from-lime-400 to-green-500",
  },
  {
    title: "Date Difference Calculator",
    description: "Calculate the exact difference between dates",
    icon: CalendarDays,
    href: "/date-diff",
    gradient: "from-orange-400 to-red-500",
    iconColor: "text-white",
    bgColor: "bg-gradient-to-br from-orange-400 to-red-500",
  },
  {
    title: "Discount Calculator",
    description: "Calculate sale prices and savings",
    icon: Tag,
    href: "/discount",
    gradient: "from-sky-400 to-blue-600",
    iconColor: "text-white",
    bgColor: "bg-gradient-to-br from-sky-400 to-blue-600",
  },
];

// Group calculators into rows of 3
const calculatorRows = calculators.reduce((acc, curr, i) => {
  const rowIndex = Math.floor(i / 3);
  if (!acc[rowIndex]) acc[rowIndex] = [];
  acc[rowIndex].push(curr);
  return acc;
}, [] as typeof calculators[]);

export default function HomePage() {
  return (
    <div className="container mx-auto px-4 space-y-8 font-inter min-h-screen">
      <Seo
        title="CalcPro - Free Online Calculators: Percentage, Unit Converter, Mortgage, Time, Age"
        description="Use CalcPro's free online calculators to solve daily math tasks: percentage calculator, unit converter, mortgage and loan calculators, time and age calculators, scientific functions, and more."
        keywords={["online calculator", "percentage calculator", "unit converter", "mortgage calculator", "time calculator", "age calculator", "scientific calculator", "discount calculator"]}
        canonicalPath="/"
      />
      <div className="text-center py-8">
        <h1 className="text-4xl font-bold tracking-tighter sm:text-5xl md:text-6xl font-inter text-black">
          Multi-Purpose Calculator
        </h1>
        <div className="mx-auto mt-6 max-w-[900px] text-muted-foreground text-lg font-inter space-y-3">
          <p>
            Free online calculators for percentages, unit conversion, loans, mortgages, and time calculations. Fast, mobile-friendly toolkit for students and professionals.
          </p>
        </div>
      </div>

      {/* Calculator grid - centered in page */}
      <div className="max-w-7xl mx-auto">
        {calculatorRows.map((row, rowIndex) => (
          <div key={rowIndex} className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 mb-6 justify-items-center">
            {row.map((calc) => {
              const Icon = calc.icon;
              return (
                <Link key={calc.href} href={calc.href} className="w-full max-w-xs group">
                  <Card className="cursor-pointer transition-all duration-500 hover:scale-105 hover:shadow-2xl h-full overflow-hidden border-0 shadow-xl rounded-xl">
                    <div className={`${calc.bgColor} p-6 text-white relative overflow-hidden h-full`}>
                      {/* Gradient overlay for better text readability */}
                      <div className="absolute inset-0 bg-black/10"></div>
                      
                      {/* Icon */}
                      <div className="relative z-10">
                        <Icon className={`h-12 w-12 ${calc.iconColor} mb-4 drop-shadow-lg transition-transform duration-300 group-hover:scale-110`} />
                      </div>
                      
                      {/* Title */}
                      <CardTitle className="text-lg font-bold text-white mb-2 font-inter relative z-10">
                        {calc.title}
                      </CardTitle>
                      
                      {/* Description */}
                      <CardDescription className="text-white/90 text-xs font-inter relative z-10 leading-relaxed">
                        {calc.description}
                      </CardDescription>
                      
                      {/* Decorative elements */}
                      <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16 transition-transform duration-300 group-hover:scale-110"></div>
                      <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/5 rounded-full translate-y-12 -translate-x-12 transition-transform duration-300 group-hover:scale-110"></div>
                      
                      {/* Hover effect overlay */}
                      <div className="absolute inset-0 bg-white/0 group-hover:bg-white/10 transition-all duration-300"></div>
                    </div>
                  </Card>
                </Link>
              );
            })}
          </div>
        ))}
      </div>

      {/* Bottom Banner Ad */}
      <AdBanner
        slot="5432109876"
        className="w-full max-w-[728px] h-[90px] mx-auto mt-8"
        format="horizontal"
      />
    </div>
  );
}