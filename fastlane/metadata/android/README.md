# Google Play screenshots & feature graphic

Fastlane expects Play assets under locale folders, for example:

```
metadata/android/
  en-US/
    images/
      phoneScreenshots/
        1_en-US.png
        2_en-US.png
      featureGraphic.png
      icon.png
  zh-CN/
  zh-TW/
```

By default `SKIP_UPLOAD_SCREENSHOTS=true` and `SKIP_UPLOAD_IMAGES=true` so you can upload the AAB + text metadata first.

Do not put an `images/` folder directly under `metadata/android/` — supply treats every subdirectory as a locale name.

For a **first** Play Store submission you still need screenshots and a feature graphic in Play Console (or add them here and set the skip flags to `false`).

See: https://docs.fastlane.tools/actions/upload_to_play_store/
