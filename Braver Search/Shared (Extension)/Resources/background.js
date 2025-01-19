'use strict';

browser.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
    if (changeInfo.url) {
        const url = new URL(changeInfo.url);
        const searchQuery = url.searchParams.get('q');
        
        if (searchQuery) {
            browser.runtime.sendNativeMessage("xyz.bsquared.braversearch", {})
                .then(response => {
                    const settings = JSON.parse(response);
                    
                    if (settings.enabled) {
                        const searchUrl = settings.searchUrl || "https://search.brave.com/search?q=";
                        const redirectUrl = searchUrl + encodeURIComponent(searchQuery);
                        browser.tabs.update(tabId, { url: redirectUrl });
                    }
                })
                .catch(error => {
                    console.error("Braver Search: Native message error", error);
                });
        }
    }
}); 