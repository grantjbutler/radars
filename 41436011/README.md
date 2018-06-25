# Build & Run While Waiting to Attach the Debugger Does Not Redeploy an Application

rdar://41436011

[OpenRadar]()

## Summary:
When a scheme for an application is set to wait to attach the debugger until the executable is launched, any code changes (and maybe other changes, such as changes to Interface Builder files or assets, but I haven't checked those) are not deployed to the destination.

## Steps to Reproduce:
1. Open the sample project attached.
2. Run the app to deploy it to the simulator or a device.
3. Stop running the app.
4. Change the scheme to wait to attach the debugger until the app is launched.
5. Make a code change (for example, change the background color of the view from `.red to `.green` in ViewController.swift:16).
6. Build & Run.
7. Open the app.

## Expected Results:
The view is green.

## Actual Results:
The view is still red.

More specifically, I would expect code changes I make to be deployed to the destination when I. This does not appear to be the case.

## Version/Build:
This issue is reproducible on Xcode Version 9.4.1 (9F2000) and Version 10.0 beta 2 (10L177m).

