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

    const engines = {
        "google": {
            domain: ["www.google.com", "www.google.co.uk", "www.google.ca", "www.google.com.au"],
            path: "/search",
            param: "q"
        },
        "yahoo": {
            domain: ["search.yahoo.com"],
            path: "/search",
            param: "p",
            check: { param: "fr", ids: ["iphone", "appsfch2", "osx"] }
        },
        "bing": {
            domain: ["www.bing.com"],
            path: "/search",
            param: "q",
            check: { param: "form", ids: ["APIPH1", "APMCS1", "APIPA1"] }
        },
        "duckduckgo": {
            domain: ["duckduckgo.com"],
            path: "/",
            param: "q",
            check: { param: "t", ids: ["iphone", "osx", "ipad"] }
        },
        "yandex": {
            domain: ["yandex.com"],
            path: "/search",
            param: "text"
        }
    };

    // Stop any current loading
    window.stop();

    for (const engineKey in engines) {
        const engine = engines[engineKey];
        console.log("Braver Search: Checking engine", engineKey);
        if (engine.domain.includes(Domain)) {
            console.log("Braver Search: Domain match found for", engineKey);
            const param = typeof engine.param === 'function' ? engine.param(Domain) : engine.param;
            const check = typeof engine.check === 'function' ? engine.check(Domain) : engine.check;
            const queryParam = getParam(URL, param);
            const checkParam = check ? getParam(URL, check.param) : null;
            
            console.log("Braver Search: Parameters", {
                param,
                queryParam,
                checkParam,
                shouldRedirect: Path.startsWith(engine.path) &&
                    queryParam != null &&
                    (!check || !check.ids.includes(checkParam))
            });

            if (Path.startsWith(engine.path) && queryParam != null) {
                if (!check || !check.ids.includes(checkParam)) {
                    // Redirect immediately
                    const redirectUrl = searchUrl + encodeURIComponent(queryParam);
                    console.log("Braver Search: Redirecting to", redirectUrl);
                    
                    // Set a minimal page content while redirecting
                    document.documentElement.innerHTML = `
                        <html>
                            <head>
                                <meta name="theme-color" content="${window.matchMedia("(prefers-color-scheme: dark)").matches ? '#1c1c1e' : '#f2f2f7'}">
                            </head>
                            <body style="background: ${window.matchMedia("(prefers-color-scheme: dark)").matches ? '#1c1c1e' : '#f2f2f7'}">
                            </body>
                        </html>
                    `;
                    
                    window.location.replace(redirectUrl);
                    return; // Exit early
                }
            }
        }
    }
}).catch(error => {
    console.error("Braver Search: Error getting response from background", error);
});

function getParam(url, param) {
    const urlObj = new URL(url);
    const urlParams = new URLSearchParams(urlObj.search);
    return urlParams.get(param);
} 