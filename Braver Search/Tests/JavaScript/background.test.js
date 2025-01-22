describe('Background Script', () => {
    let navigationListener;
    
    beforeEach(() => {
        // Reset the navigation listener
        navigationListener = null;
        
        // Set up the listener capture
        browser.webNavigation.onBeforeNavigate.addListener.mockImplementation(fn => {
            navigationListener = fn;
            return fn;
        });
        
        // Import the background script in isolation
        jest.isolateModules(() => {
            require('../../Shared (Extension)/Resources/background.js');
        });
        
        // Verify setup
        expect(navigationListener).toBeTruthy();
    });
    
    describe('isRedirectEnabled', () => {
        it('should return true when enabled in storage', async () => {
            // Setup
            browser.storage.local.get.mockImplementation(() => Promise.resolve({ enabled: true }));
            
            // Execute
            await navigationListener({
                url: 'https://google.com/search?q=test'
            });
            
            // Verify
            expect(browser.tabs.update).toHaveBeenCalledWith(
                undefined,
                { url: 'https://search.brave.com/search?q=test' }
            );
        });
        
        it('should not redirect when disabled in storage', async () => {
            // Setup
            browser.storage.local.get.mockImplementation(() => Promise.resolve({ enabled: false }));
            
            // Execute
            await navigationListener({
                url: 'https://google.com/search?q=test'
            });
            
            // Verify
            expect(browser.tabs.update).not.toHaveBeenCalled();
        });
    });
    
    describe('URL handling', () => {
        beforeEach(() => {
            browser.storage.local.get.mockImplementation(() => Promise.resolve({ enabled: true }));
        });
        
        it('should not redirect Brave Search URLs', async () => {
            await navigationListener({
                url: 'https://search.brave.com/search?q=test'
            });
            
            expect(browser.tabs.update).not.toHaveBeenCalled();
        });
        
        it('should not redirect URLs without search queries', async () => {
            await navigationListener({
                url: 'https://google.com'
            });
            
            expect(browser.tabs.update).not.toHaveBeenCalled();
        });
        
        it('should properly encode search queries', async () => {
            await navigationListener({
                url: 'https://google.com/search?q=test search'
            });
            
            expect(browser.tabs.update).toHaveBeenCalledWith(
                undefined,
                { url: 'https://search.brave.com/search?q=test%20search' }
            );
        });
    });
}); 