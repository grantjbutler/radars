# Slow Unarchive Without Secure Coding in Simulator

rdar://36776294

[OpenRadar](http://openradar.appspot.com/radar?id=5038858769006592)

## Summary:
When not using secure coding to unarchive data using `NSKeyedUnarchiver` on the simulator, the unarchive process can take significantly longer than the unarchive process when secure coding is enabled.

## Steps to Reproduce:
1. Run the attached sample project in the simulator.
2. Ensure "Use Secure Coding?" is on.
3. Run the test.
4. Observe the run time of the test.
5. Turn off "Use Secure Coding?"
6. Run the test.
7. Observe and compare the results to the first test. 

## Expected Results:
There should be nominal difference in time between running the two tests.

## Actual Results:
Unarchiving without secure coding enabled takes about 16x as long as unarchiving with secure coding enabled.

## Notes:
This issue only affects the simulator. If you run the attached project on a device, you will see a nominal slowdown when not using secure coding (for 1,000 objects, I was seeing ~0.3 seconds with secure coding, and ~0.38 seconds without secure coding).

In a past app I had worked on, we were fetching a bool value from user defaults to check if, from our set of color factory methods, we should return an actual color or a random color. We noticed that, in the simulator, it would take a while to open a screen in that app where we were displaying ~150 views that called maybe 5 different color factory methods. We were able to trace it to user defaults being slow, so we started caching the bool value whenever user defaults changed, instead of fetching it fresh each time. That change resulted in a significant improvement in the load time of the view when running the app in the simulator.

I bring this up because some basic digging into this issue (and disassembling of Foundation) has revealed that the value for the user default key `com.apple.foundation.secure-coding.strict` is fetched every time a value is decoded from `NSKeyedUnarchiver`. Given my past experience with improving a view's load time by caching a user defaults value, this seems like this might be a good place to start investigating.

## Version/Build:
iOS 11.2 (15C107)
Xcode 9.2 (9C40b)
