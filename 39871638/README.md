# Crash when Decoding CGFloat in Swift

rdar://39871638

[OpenRadar](https://openradar.appspot.com/radar?id=5030450766544896)

## Summary:
When decoding a CGFloat value that has been encoded with NSKeyedUnarchiver, the decoding fails with the exception "*** -[NSKeyedUnarchiver decodeDoubleForKey:]: value for key (Value) is not a 64-bit float".

## Steps to Reproduce:
1. Have a CGFloat property in an NSCoding-conforming class that is encoded and decoded.
2. Archive an instance of the class.
3. Unarchive the archive data.

## Expected Results:
The value is decoded.

## Actual Results:
The app crashes at runtime because of the exception.

## Version/Build:
Xcode Version 9.3 (9E145)
iOS 11.3 (15E217)
Swift 4.1
