import { Switch, Route, useLocation } from "wouter";
import { queryClient } from "./lib/queryClient";
import { QueryClientProvider } from "@tanstack/react-query";
import { Toaster } from "@/components/ui/toaster";
import NavBar from "@/components/nav-bar";
import NotFound from "@/pages/not-found";
import Home from "@/pages/home";
import Percentage from "@/pages/percentage";
import Basic from "@/pages/basic";
import Convert from "@/pages/convert";
import Financial from "@/pages/financial";
import Scientific from "@/pages/scientific";
import Time from "@/pages/time";
import Age from "@/pages/age";
import Mortgage from "@/pages/mortgage";
import Discount from "@/pages/discount";
import DateDiff from "@/pages/date-diff";
import { useEffect, Component, ErrorInfo, ReactNode } from "react";

interface ErrorBoundaryState {
  hasError: boolean;
  error?: Error;
}

class ErrorBoundary extends Component<{ children: ReactNode }, ErrorBoundaryState> {
  constructor(props: { children: ReactNode }) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div style={{ padding: '20px', textAlign: 'center', fontFamily: 'Arial, sans-serif' }}>
          <h2>Something went wrong</h2>
          <p>Please refresh the page or check the console for more details.</p>
          <button onClick={() => window.location.reload()}>Refresh Page</button>
        </div>
      );
    }

    return this.props.children;
  }
}

function Router() {
  const [location] = useLocation();

  useEffect(() => {
    window.scrollTo({ top: 0, left: 0, behavior: "auto" });
  }, [location]);

  return (
    <div className="min-h-screen bg-background">
      <NavBar />
      <main className="container mx-auto px-4 py-8">
        <Switch>
          <Route path="/" component={Home} />
          <Route path="/percentage" component={Percentage} />
          <Route path="/basic" component={Basic} />
          <Route path="/convert" component={Convert} />
          <Route path="/financial" component={Financial} />
          <Route path="/scientific" component={Scientific} />
          <Route path="/time" component={Time} />
          <Route path="/age" component={Age} />
          <Route path="/mortgage" component={Mortgage} />
          <Route path="/discount" component={Discount} />
          <Route path="/date-diff" component={DateDiff} />
          <Route component={NotFound} />
        </Switch>
      </main>
    </div>
  );
}

function App() {
  return (
    <ErrorBoundary>
      <QueryClientProvider client={queryClient}>
        <Router />
        <Toaster />
      </QueryClientProvider>
    </ErrorBoundary>
  );
}

export default App;