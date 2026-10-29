# Wayfile

iOS mileage log. Milestone 0: record a drive, list it, swipe to classify it, edit it, see a monthly total. Everything stays on the phone.

## Build
Push to `main`. GitHub Actions generates the Xcode project with XcodeGen, builds an unsigned app and uploads `Wayfile.ipa` as a build artifact (Actions tab, latest run, Artifacts).

## Install on an iPhone from Windows (free Apple ID)
1. Install iTunes or the Apple Devices app so Windows can see the phone.
2. Install Sideloadly. Connect the iPhone, trust the computer.
3. Drag `Wayfile.ipa` into Sideloadly, enter your Apple ID, click Start.
4. On the phone: Settings > General > VPN & Device Management > trust your Apple ID.
5. Free Apple ID apps expire after 7 days. Reinstall to renew. Apple's free-account limits can change, so check Sideloadly's notes.

Bundle ID is `com.wayfile.app` in `project.yml`. Sideloadly can change it if Apple says it is taken.

## Test the recording
Press Record on the Drives tab, allow location, drive, press Stop. Drives under about 0.1 mile are discarded. The lock-screen blue indicator means background tracking is on.
