import { useEffect, useRef, useState, useCallback } from 'react';
import AdBanner from './AdBanner';

interface AdOptimizerProps {
  slot: string;
  adType?: 'banner' | 'sidebar' | 'in-content' | 'sticky';
  format?: 'auto' | 'fluid' | 'rectangle' | 'vertical' | 'horizontal' | 'responsive';
  className?: string;
  lazyLoad?: boolean;
  threshold?: number;
  testVariant?: 'A' | 'B' | 'C';
}

export default function AdOptimizer({
  slot,
  adType = 'banner',
  format = 'auto',
  className = '',
  lazyLoad = true,
  threshold = 0.1,
  testVariant = 'A'
}: AdOptimizerProps) {
  const [isVisible, setIsVisible] = useState(!lazyLoad);
  const [isLoaded, setIsLoaded] = useState(false);
  const [loadTime, setLoadTime] = useState<number | null>(null);
  const adRef = useRef<HTMLDivElement>(null);

  // Intersection Observer for lazy loading
  useEffect(() => {
    if (!lazyLoad) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsVisible(true);
          observer.disconnect();
        }
      },
      { threshold }
    );

    if (adRef.current) {
      observer.observe(adRef.current);
    }

    return () => observer.disconnect();
  }, [lazyLoad, threshold]);

  // Performance tracking
  const trackAdPerformance = useCallback((startTime: number) => {
    const endTime = performance.now();
    const loadDuration = endTime - startTime;
    setLoadTime(loadDuration);

    // Send performance data to analytics
    if (typeof gtag !== 'undefined') {
      gtag('event', 'ad_performance', {
        ad_slot: slot,
        ad_type: adType,
        load_time: loadDuration,
        test_variant: testVariant,
        event_category: 'ads',
        event_label: 'ad_load_time'
      });
    }
  }, [slot, adType, testVariant]);

  // A/B testing logic
  const getTestVariantSlot = useCallback(() => {
    const baseSlot = slot;
    switch (testVariant) {
      case 'B':
        return `${baseSlot}-variant-b`;
      case 'C':
        return `${baseSlot}-variant-c`;
      default:
        return baseSlot;
    }
  }, [slot, testVariant]);

  // Ad load tracking
  useEffect(() => {
    if (!isVisible) return;

    const startTime = performance.now();
    const checkAdLoaded = setInterval(() => {
      const adElement = document.querySelector(`[data-ad-slot="${getTestVariantSlot()}"]`);
      if (adElement && adElement.innerHTML.trim() !== '') {
        setIsLoaded(true);
        trackAdPerformance(startTime);
        clearInterval(checkAdLoaded);
      }
    }, 100);

    // Cleanup after 10 seconds
    setTimeout(() => {
      clearInterval(checkAdLoaded);
      if (!isLoaded) {
        trackAdPerformance(startTime);
      }
    }, 10000);

    return () => clearInterval(checkAdLoaded);
  }, [isVisible, isLoaded, getTestVariantSlot, trackAdPerformance]);

  // Error handling
  const handleAdError = useCallback(() => {
    if (typeof gtag !== 'undefined') {
      gtag('event', 'ad_error', {
        ad_slot: slot,
        ad_type: adType,
        test_variant: testVariant,
        event_category: 'ads',
        event_label: 'ad_load_error'
      });
    }
  }, [slot, adType, testVariant]);

  if (!isVisible) {
    return (
      <div ref={adRef} className={`${className} bg-gray-100 flex items-center justify-center text-gray-400 text-sm`}>
        <div className="animate-pulse">Loading ad...</div>
      </div>
    );
  }

  return (
    <div ref={adRef} className={className}>
      <AdBanner
        slot={getTestVariantSlot()}
        adType={adType}
        format={format}
        className={className}
      />
      {loadTime && (
        <div className="hidden">
          {/* Performance tracking data */}
          <script
            dangerouslySetInnerHTML={{
              __html: `
                window.adPerformance = window.adPerformance || {};
                window.adPerformance['${slot}'] = {
                  loadTime: ${loadTime},
                  adType: '${adType}',
                  testVariant: '${testVariant}',
                  timestamp: ${Date.now()}
                };
              `
            }}
          />
        </div>
      )}
    </div>
  );
}

// Hook for ad performance analytics
export const useAdAnalytics = () => {
  const trackAdClick = useCallback((slot: string, adType: string, position: string) => {
    if (typeof gtag !== 'undefined') {
      gtag('event', 'ad_click', {
        ad_slot: slot,
        ad_type: adType,
        ad_position: position,
        event_category: 'ads',
        event_label: 'ad_click'
      });
    }
  }, []);

  const trackAdImpression = useCallback((slot: string, adType: string, position: string) => {
    if (typeof gtag !== 'undefined') {
      gtag('event', 'ad_impression', {
        ad_slot: slot,
        ad_type: adType,
        ad_position: position,
        event_category: 'ads',
        event_label: 'ad_impression'
      });
    }
  }, []);

  return { trackAdClick, trackAdImpression };
};

// Utility for responsive ad sizing
export const getResponsiveAdSize = (screenSize: 'mobile' | 'tablet' | 'desktop') => {
  const sizes = {
    mobile: { width: '320px', height: '50px' },
    tablet: { width: '728px', height: '90px' },
    desktop: { width: '728px', height: '90px' }
  };
  
  return sizes[screenSize] || sizes.desktop;
};

// Utility for A/B testing
export const getABTestVariant = (slot: string): 'A' | 'B' | 'C' => {
  // Simple hash-based variant selection
  const hash = slot.split('').reduce((a, b) => {
    a = ((a << 5) - a) + b.charCodeAt(0);
    return a & a;
  }, 0);
  
  const variants: ('A' | 'B' | 'C')[] = ['A', 'B', 'C'];
  return variants[Math.abs(hash) % variants.length];
};
