'use strict';

console.log("Braver Search: Background script loaded");

const SEARCH_ENGINE_HOSTS = [
    'google.com',
    'google.co.uk',
    'google.ca',
    'google.com.au',
    'bing.com',
    'duckduckgo.com',
    'www.google.com',
    'www.bing.com',
    'www.duckduckgo.com',
    'www.yandex.com',
    'search.yahoo.com',
    'www.yandex.com'
];

function isSupportedSearchEngine(hostname) {
    return SEARCH_ENGINE_HOSTS.some(domain => 
        hostname === domain
    );
}

// Function to check if redirect is enabled
async function isRedirectEnabled() {
    try {
        const result = await browser.storage.local.get('enabled');
        console.log("Braver Search: Redirect enabled?", result.enabled);
        return result.enabled || false;
    } catch (error) {
        console.error("Braver Search: Failed to get enabled state", error);
        return false;
    }
}

browser.webNavigation.onBeforeNavigate.addListener(async (details) => {
    console.log("Braver Search: Navigation detected", { 
        details,
        userAgent: navigator.userAgent
    });
    
    // First check if redirect is enabled
    const enabled = await isRedirectEnabled();
    if (!enabled) {
        console.log("Braver Search: Redirect is disabled, skipping");
        return;
    }
    
    if (details.url) {
        console.log("Braver Search: URL detected", details.url);
        const url = new URL(details.url);
        
        // Check if this is a supported search engine domain
        if (!isSupportedSearchEngine(url.hostname)) {
            console.log("Braver Search: Not a supported search engine", url.hostname);
            return;
        }
        
        const searchQuery = url.searchParams.get('q');
        console.log("Braver Search: Search query found", { 
            url: url.toString(), 
            hostname: url.hostname,
            pathname: url.pathname,
            searchQuery 
        });
        
        if (searchQuery) {
            const searchUrl = "https://search.brave.com/search?q=";
            const redirectUrl = searchUrl + encodeURIComponent(searchQuery);
            console.log("Braver Search: Attempting redirect to", redirectUrl);
            
            browser.tabs.update(details.tabId, { url: redirectUrl })
                .then(() => console.log("Braver Search: Redirect successful"))
                .catch(error => console.error("Braver Search: Redirect failed", error));
        } else {
            console.log("Braver Search: No search query found in URL");
        }
    } else {
        console.log("Braver Search: No URL in navigation details", details);
    }
}); 