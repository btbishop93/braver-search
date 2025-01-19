'use strict';

// Execute immediately before page load
console.log("Braver Search: Content script loaded");

browser.runtime.sendMessage({ type: "content" }).then(response => {
    console.log("Braver Search: Got response from background", response);
    const enabled = response.enabled;
    const searchUrl = response.searchUrl || "https://search.brave.com/search?q=";
    
    if (!enabled) {
        console.log("Braver Search: Extension is disabled");
        return;
    }

    const Domain = window.location.hostname;
    const Path = window.location.pathname;
    const URL = window.location.href;

    console.log("Braver Search: Checking URL", { Domain, Path, URL });

    const queryParam = getParam(URL, "q");
    const redirectUrl = searchUrl + encodeURIComponent(queryParam);

    if (Domain === "www.google.com" && Path === "/search") {
        console.log("Braver Search: Redirecting to", redirectUrl);
        window.location.replace(redirectUrl);
        return; // Exit early
    }
}).catch(error => {
    console.error("Braver Search: Error getting response from background", error);
});

function getParam(url, param) {
    const urlObj = new URL(url);
    const urlParams = new URLSearchParams(urlObj.search);
    return urlParams.get(param);
} 