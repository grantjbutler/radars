# FileManager.currentDirectoryPath Can Return nil, Not Annotated as an Optional

rdar://42442333	

[OpenRadar](https://openradar.appspot.com/radar?id=4926250791469056)

## Summary
According to the docs for FileManager.currentDirectoryPath:

> If the current working directory is not accessible for any reason, the value of this property is nil.

However, currentDirectoryPath is not annotated as an Optional.

## Steps to Reproduce
1. Look at the docs for FileManager.currentDirectoryPath: https://developer.apple.com/documentation/foundation/filemanager/1410766-currentdirectorypath
2. Look at the generated interface for FileManager in Xcode.

## Expected Results
The property is annotated as an Optional, since the docs say the value can be nil.

## Actual Results
The property is not an Optional.

## Version/Build
Current docs on developer.apple.com as of July 20th, 2018
Xcode Version 10.0 beta 4 (10L213o)
