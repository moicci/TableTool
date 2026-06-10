//
//  TTTableHeaderView.m
//  Table Tool
//

#import "TTTableHeaderView.h"
#import "Constants.h"

static const CGFloat TTIndicatorRowHeight = 18.0;
static const CGFloat TTHeaderLabelRowHeight = 23.0;

@implementation TTTableHeaderView

+ (CGFloat)preferredHeight {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL showNumbers = [defaults boolForKey:TTShowColumnNumbersKey];
    BOOL showLetters = [defaults boolForKey:TTShowColumnLettersKey];
    if (showNumbers || showLetters) {
        return TTIndicatorRowHeight + TTHeaderLabelRowHeight;
    }
    return TTHeaderLabelRowHeight;
}

+ (NSString *)columnLetterForIndex:(NSInteger)index {
    int columnBase = 26;
    int digitMax = 7;
    NSString *digits = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    if (index < columnBase) {
        return [digits substringWithRange:NSMakeRange(index, 1)];
    }

    NSMutableArray *columnName = [[NSMutableArray alloc] initWithCapacity:digitMax];
    for (int i = 0; i < digitMax; i++) {
        columnName[i] = @"";
    }

    int workingIndex = (int)index + 1;
    int offset = digitMax;
    while (workingIndex > 0) {
        [columnName replaceObjectAtIndex:--offset withObject:[digits substringWithRange:NSMakeRange(--workingIndex % columnBase, 1)]];
        workingIndex /= columnBase;
    }

    return [columnName componentsJoinedByString:@""];
}

- (BOOL)showsColumnIndicators {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:TTShowColumnNumbersKey] || [defaults boolForKey:TTShowColumnLettersKey];
}

- (NSString *)indicatorTextForDataColumnIndex:(NSInteger)dataColumnIndex {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL showNumbers = [defaults boolForKey:TTShowColumnNumbersKey];
    BOOL showLetters = [defaults boolForKey:TTShowColumnLettersKey];

    if (showNumbers && showLetters) {
        return [NSString stringWithFormat:@"%ld - %@", (long)(dataColumnIndex + 1), [TTTableHeaderView columnLetterForIndex:dataColumnIndex]];
    }
    if (showNumbers) {
        return [NSString stringWithFormat:@"%ld", (long)(dataColumnIndex + 1)];
    }
    if (showLetters) {
        return [TTTableHeaderView columnLetterForIndex:dataColumnIndex];
    }
    return @"";
}

- (NSDictionary *)indicatorTextAttributes {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    return @{
        NSFontAttributeName: [NSFont systemFontOfSize:[NSFont smallSystemFontSize]],
        NSForegroundColorAttributeName: [NSColor secondaryLabelColor],
        NSParagraphStyleAttributeName: style
    };
}

- (void)drawIndicatorInRect:(NSRect)rect text:(NSString *)text {
    if (text.length == 0) return;
    [text drawInRect:NSInsetRect(rect, 4, 1) withAttributes:[self indicatorTextAttributes]];
}

- (NSColor *)headerBackgroundColor {
    return self.tableView.backgroundColor ?: [NSColor controlBackgroundColor];
}

- (NSDictionary *)headerLabelTextAttributesForColumn:(NSTableColumn *)column {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = column.headerCell.alignment;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    return @{
        NSFontAttributeName: column.headerCell.font ?: [NSFont systemFontOfSize:[NSFont smallSystemFontSize]],
        NSForegroundColorAttributeName: [NSColor headerTextColor],
        NSParagraphStyleAttributeName: style
    };
}

- (void)drawHeaderLabelInRect:(NSRect)rect column:(NSTableColumn *)column {
    NSString *title = column.headerCell.stringValue;
    if (title.length == 0) return;
    [title drawInRect:NSInsetRect(rect, 4, 2) withAttributes:[self headerLabelTextAttributesForColumn:column]];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (![self showsColumnIndicators]) {
        [super drawRect:dirtyRect];
        return;
    }

    [[self headerBackgroundColor] setFill];
    NSRectFill(dirtyRect);

    NSTableView *tableView = self.tableView;
    NSInteger dataColumnIndex = 0;

    for (NSInteger columnIndex = 0; columnIndex < tableView.numberOfColumns; columnIndex++) {
        NSTableColumn *column = tableView.tableColumns[columnIndex];
        NSRect columnRect = [self headerRectOfColumn:columnIndex];

        NSRect indicatorRect = NSMakeRect(NSMinX(columnRect), 0, NSWidth(columnRect), TTIndicatorRowHeight);
        NSRect labelRect = NSMakeRect(NSMinX(columnRect), TTIndicatorRowHeight, NSWidth(columnRect), TTHeaderLabelRowHeight);

        if ([column.identifier isEqualToString:TTLineNumberColumnIdentifier]) {
            [self drawIndicatorInRect:indicatorRect text:@""];
        } else {
            [self drawIndicatorInRect:indicatorRect text:[self indicatorTextForDataColumnIndex:dataColumnIndex]];
            dataColumnIndex++;
        }

        [self drawHeaderLabelInRect:labelRect column:column];
    }

    [self drawGridInRect:dirtyRect];
}

- (void)drawGridInRect:(NSRect)rect {
    [[NSColor gridColor] setStroke];
    NSBezierPath *path = [NSBezierPath bezierPath];

    CGFloat y = TTIndicatorRowHeight;
    [path moveToPoint:NSMakePoint(NSMinX(rect), y)];
    [path lineToPoint:NSMakePoint(NSMaxX(rect), y)];
    [path stroke];
}

@end
