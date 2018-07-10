# UINavigationBar Prompt Does not Animate Correctly

rdar://42029168

[OpenRadar]()

## Area:
UIKit

## Summary:
When pushing a view controller onto the navigation stack that has a prompt set on its navigation item, the incoming title and prompt don't animate in; they just appear. Additionally, when popping the detail view controller of the navigation stack, the title of the detail view controller immediately disappears, instead of animating out.

## Steps to Reproduce:
1. Have a master/detail view controller relationship set up.
2. Set a prompt on the detail view controller.
3. Push an instance of the detail view controller onto the navigation stack.

See the attached project and video that demonstrate this issue.

## Expected Results:
The navigation bar correctly animates the incoming title and prompt.

## Actual Results:
The prompt and title of the detail view controller just appear.

## Version/Build:
iOS 12.0 (16A5318d)

