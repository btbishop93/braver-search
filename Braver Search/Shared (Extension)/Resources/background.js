'use strict';

console.log("Braver Search: Background script loaded");

browser.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
    console.log("Braver Search: Tab updated", { 
        tabId, 
        changeInfo, 
        tab,
        platform: navigator.platform,
        userAgent: navigator.userAgent
    });
    
    if (changeInfo.url) {
        console.log("Braver Search: URL changed", changeInfo.url);
        const url = new URL(changeInfo.url);
        
        // Skip if already on Brave Search
        if (url.hostname === 'search.brave.com') {
            console.log("Braver Search: Skipping Brave Search URL");
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
            console.log("Braver Search: Sending native message");
            browser.runtime.sendNativeMessage("xyz.bsquared.braversearch", {})
                .then(response => {
                    console.log("Braver Search: Native message response received", response);
                    const settings = JSON.parse(response);
                    console.log("Braver Search: Parsed settings", settings);
                    
                    if (settings.enabled) {
                        const searchUrl = settings.searchUrl || "https://search.brave.com/search?q=";
                        const redirectUrl = searchUrl + encodeURIComponent(searchQuery);
                        console.log("Braver Search: Attempting redirect to", redirectUrl);
                        browser.tabs.update(tabId, { url: redirectUrl })
                            .then(() => console.log("Braver Search: Redirect successful"))
                            .catch(error => console.error("Braver Search: Redirect failed", error));
                    } else {
                        console.log("Braver Search: Extension is disabled in settings");
                    }
                })
                .catch(error => {
                    console.error("Braver Search: Native message error", error);
                });
        } else {
            console.log("Braver Search: No search query found in URL");
        }
    } else {
        console.log("Braver Search: No URL change in this update", changeInfo);
    }
}); 