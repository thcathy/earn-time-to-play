# App Store screenshots

Place App Store screenshots here for `fastlane ios release` / `ios metadata`.

Expected layout (fastlane deliver):

```
screenshots/
  en-US/
    1_iphone65_*.png
    ...
  zh-Hant/
  zh-Hans/
```

Required sizes for a modern iPhone listing typically include 6.7" (or current App Store Connect requirements).

By default `SKIP_SCREENSHOTS=true` so binary/metadata uploads work without this folder.
For a **first** App Store submission, either:

1. Upload screenshots once in App Store Connect, or
2. Add files here and run with `SKIP_SCREENSHOTS=false`
