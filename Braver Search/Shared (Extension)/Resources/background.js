'use strict';

let isEnabled = true;

// Listen for messages from the native app
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.type === "content") {
        browser.runtime.sendNativeMessage("xyz.bsquared.braversearch", {}).then(response => {
            const settings = JSON.parse(response);
            isEnabled = settings.enabled;
            sendResponse(settings);
        }).catch(error => {
            sendResponse({ enabled: true });
        });
        return true;
    }
});

// Intercept Google search requests
browser.webRequest.onBeforeRequest.addListener(
    (details) => {
        if (!isEnabled) {
            return { cancel: false };
        }

        const url = new URL(details.url);
        const searchQuery = url.searchParams.get('q');

        if (!searchQuery) {
            return { cancel: false };
        }

        return {
            redirectUrl: `https://search.brave.com/search?q=${encodeURIComponent(searchQuery)}`
        };
    },
    {
        urls: [
            "https://www.google.com/search*",
            "https://www.google.co.uk/search*",
            "https://www.google.ca/search*",
            "https://www.google.com.au/search*"
        ],
        types: ["main_frame"]
    },
    ["blocking"]
); 