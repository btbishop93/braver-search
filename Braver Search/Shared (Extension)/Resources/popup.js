console.log("Hello World!", browser);

document.addEventListener('DOMContentLoaded', function() {
    const settingsLink = document.getElementById('settingsLink');
    const platform = navigator.platform.toLowerCase();
    const userAgent = navigator.userAgent.toLowerCase();
    
    console.log("Platform:", platform);
    console.log("User Agent:", userAgent);
    
    // Check if we're on iOS (including simulator)
    const isIOS = platform.includes('iphone') || 
                  platform.includes('ipad') || 
                  platform.includes('ipod') ||
                  userAgent.includes('iphone simulator') ||
                  userAgent.includes('ipad simulator') ||
                  (platform === 'macintel' && userAgent.includes('safari') && !userAgent.includes('macintosh'));
    
    console.log("Is iOS:", isIOS);
    
    if (isIOS) {
        settingsLink.href = 'App-Prefs:root=SAFARI';
    } else {
        // macOS
        settingsLink.href = 'xyz.bsquared.braversearch://';
    }
});
