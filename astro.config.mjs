import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";

export default defineConfig({
  site: "https://thiengtham.com",
  output: "static",
  build: {
    format: "directory",
  },
  integrations: [
    sitemap({
      i18n: {
        defaultLocale: "th",
        locales: {
          th: "th-TH",
          en: "en-US",
        },
      },
    }),
  ],
});
