import platformPlugin from "@base44/vite-plugin"
import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    platformPlugin({
      // Opt-in for code still using the legacy @/integrations, @/entities import style
      legacySDKImports: process.env.LEGACY_SDK_IMPORTS === 'true',
      hmrNotifier: true,
      navigationNotifier: true,
      analyticsTracker: true,
      visualEditAgent: true
    }),
    react(),
  ],
  server: {
    // Pre-transform the entry graph as soon as the dev server starts listening,
    // so the first page load does not pay for on-demand compilation of the app.
    warmup: {
      clientFiles: ['./src/main.jsx'],
    },
  },
});
