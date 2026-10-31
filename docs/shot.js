// Screenshot driver for the README images.
// One browser, one page, shots taken in sequence by switching emulated media.
// The browser identity is replaced with a neutral stub so the images carry
// no real browser name, version or platform of the machine that made them.
// Run: make shots   (or NODE_PATH=<dir containing playwright> node docs/shot.js)
const { chromium } = require('playwright');
const path = require('path');

const APP = 'file://' + path.resolve(__dirname, '..', 'index.html');
const out = name => path.join(__dirname, name);

(async () => {
  const browser = await chromium.launch({ headless: true });
  try {
    const context = await browser.newContext({
      viewport: { width: 1280, height: 860 },
      deviceScaleFactor: 2,
      colorScheme: 'light',
      userAgent: 'DemoBrowser/1.0',
    });
    await context.addInitScript(() => {
      const data = { brands: [{ brand: 'Demo browser', version: '1' }], mobile: false, platform: 'Demo OS' };
      Object.defineProperty(Navigator.prototype, 'userAgentData', { get: () => data });
      Object.defineProperty(Navigator.prototype, 'platform', { get: () => 'Demo OS' });
    });
    const page = await context.newPage();
    await page.goto(APP, { waitUntil: 'domcontentloaded' });
    await page.waitForFunction(() => document.querySelector('#v-big')?.textContent !== '—');
    const settle = () => page.waitForTimeout(1400); // let the row flash animation finish

    // 1. light system preference
    await settle();
    await page.screenshot({ path: out('screenshot-light.png') });

    // 2. switch to dark: the page reacts live and logs the change
    await page.emulateMedia({ colorScheme: 'dark' });
    await settle();
    await page.screenshot({ path: out('screenshot-dark.png') });

    // 3. accessibility layer: forced colors (contrast theme) active
    await page.emulateMedia({ colorScheme: 'dark', forcedColors: 'active' });
    await settle();
    await page.screenshot({ path: out('screenshot-forced-colors.png') });
    await page.emulateMedia({ colorScheme: 'dark', forcedColors: 'none' });
    await settle();

    // 4. the change log card after the switches above
    await page.locator('section.card:has(#log)').screenshot({ path: out('screenshot-change-log.png') });

    // 5. CSS system colors table, full width
    await page.locator('section.card:has(#sc)').screenshot({ path: out('screenshot-system-colors.png') });

  } finally {
    await browser.close();
  }
})().catch(e => { console.error(e); process.exit(1); });
