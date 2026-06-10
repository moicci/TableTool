//
//  TTTableHeaderView.h
//  Table Tool
//

#import <Cocoa/Cocoa.h>

@interface TTTableHeaderView : NSTableHeaderView

+ (CGFloat)preferredHeight;
+ (NSString *)columnLetterForIndex:(NSInteger)index;

@end
