'use strict';

browser.runtime.onMessage.addListener((request, sender) => {
    if (request.type === "content") {
        return new Promise((resolve, reject) => {
            browser.runtime.sendNativeMessage("xyz.bsquared.braversearch", {})
                .then(response => {
                    console.log("Braver Search: Native message response", response);
                    const obj = JSON.parse(response);
                    resolve(obj);
                })
                .catch(error => {
                    console.error("Braver Search: Native message error", error);
                    reject(error);
                });
        });
    }
    return false;
}); 