'use strict';

// Block page load immediately
window.stop();
console.log("Braver Search: Content script loaded and page load blocked");

// Only proceed if this is a Google search URL
const isGoogleSearch = window.location.hostname.match(/^(www\.)?google\.(com|co\.uk|ca|com\.au)$/) && 
                      window.location.pathname === '/search';

if (!isGoogleSearch) {
    console.log("Braver Search: Not a Google search page, allowing load");
    return;
}

const searchQuery = new URLSearchParams(window.location.search).get('q');
if (!searchQuery) {
    console.log("Braver Search: No search query found, allowing load");
    return;
}

// Check if enabled before redirecting
browser.runtime.sendMessage({ type: "content" }).then(response => {
    console.log("Braver Search: Got response from background", response);
    if (!response.enabled) {
        console.log("Braver Search: Extension is disabled, allowing load");
        return;
    }

    // Set minimal page content while redirecting
    document.documentElement.innerHTML = `
        <html>
            <head>
                <meta name="theme-color" content="${window.matchMedia("(prefers-color-scheme: dark)").matches ? '#1c1c1e' : '#f2f2f7'}">
            </head>
            <body style="background: ${window.matchMedia("(prefers-color-scheme: dark)").matches ? '#1c1c1e' : '#f2f2f7'}">
            </body>
        </html>
    `;

    // Redirect to Brave Search
    const searchUrl = response.searchUrl || "https://search.brave.com/search?q=";
    const redirectUrl = searchUrl + encodeURIComponent(searchQuery);
    console.log("Braver Search: Redirecting to", redirectUrl);
    window.location.replace(redirectUrl);
}).catch(error => {
    console.error("Braver Search: Error getting response from background", error);
});