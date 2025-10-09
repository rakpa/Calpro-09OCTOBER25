import { useEffect, useState } from 'react';

interface AdBannerProps {
  slot: string;
  style?: React.CSSProperties;
  format?: 'auto' | 'fluid' | 'rectangle' | 'vertical' | 'horizontal' | 'responsive';
  className?: string;
  adType?: 'banner' | 'sidebar' | 'in-content' | 'sticky';
  responsive?: boolean;
}

export default function AdBanner({ 
  slot, 
  style, 
  format = 'auto', 
  className = '',
  adType = 'banner',
  responsive = true 
}: AdBannerProps) {
  const [isLoaded, setIsLoaded] = useState(false);

  useEffect(() => {
    try {
      // Push the ad only when component mounts
      ((window as any).adsbygoogle = (window as any).adsbygoogle || []).push({});
      
      // Track ad load success
      const checkAdLoaded = setInterval(() => {
        const adElement = document.querySelector(`[data-ad-slot="${slot}"]`);
        if (adElement && adElement.innerHTML.trim() !== '') {
          setIsLoaded(true);
          clearInterval(checkAdLoaded);
        }
      }, 100);

      // Cleanup after 10 seconds
      setTimeout(() => clearInterval(checkAdLoaded), 10000);
    } catch (err) {
      console.error('Error loading ad:', err);
    }
  }, [slot]);

  const getAdStyles = () => {
    const baseStyles = style || { display: 'block' };
    
    if (adType === 'sticky') {
      return {
        ...baseStyles,
        position: 'fixed',
        bottom: '20px',
        right: '20px',
        zIndex: 1000,
        maxWidth: '320px',
        width: '100%'
      };
    }
    
    if (adType === 'sidebar') {
      return {
        ...baseStyles,
        maxWidth: '300px',
        margin: '0 auto'
      };
    }
    
    return baseStyles;
  };

  const getResponsiveClass = () => {
    if (!responsive) return className;
    
    switch (adType) {
      case 'banner':
        return `${className} w-full max-w-[728px] h-[90px] mx-auto`;
      case 'sidebar':
        return `${className} w-full max-w-[300px] h-[600px] mx-auto`;
      case 'in-content':
        return `${className} w-full max-w-[728px] h-[90px] mx-auto my-4`;
      default:
        return className;
    }
  };

  return (
    <div className={getResponsiveClass()}>
      <ins
        className="adsbygoogle"
        style={getAdStyles()}
        data-ad-client="ca-pub-YOUR_PUBLISHER_ID" // Replace with your publisher ID
        data-ad-slot={slot}
        data-ad-format={format}
        data-full-width-responsive={responsive.toString()}
        data-adtest={process.env.NODE_ENV === 'development' ? 'on' : 'off'}
      />
      {!isLoaded && (
        <div className="bg-gray-100 h-full flex items-center justify-center text-gray-400 text-sm">
          Loading ad...
        </div>
      )}
    </div>
  );
}
