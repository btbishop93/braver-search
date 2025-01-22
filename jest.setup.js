// Import jest-webextension-mock first
require('jest-webextension-mock');

// Clear all mocks before each test
beforeEach(() => {
    jest.clearAllMocks();
});

// Mock browser.storage API
global.browser = {
    storage: {
        local: {
            get: jest.fn(() => Promise.resolve({})),
            set: jest.fn(() => Promise.resolve())
        }
    },
    tabs: {
        update: jest.fn(() => Promise.resolve({}))
    },
    webNavigation: {
        onBeforeNavigate: {
            addListener: jest.fn(),
            removeListener: jest.fn(),
            hasListener: jest.fn()
        }
    }
};

// Mock console methods
global.console = {
    ...console,
    log: jest.fn(),
    error: jest.fn()
}; 