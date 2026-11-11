//
//  AppDelegate.m
//  Table Tool
//
//  Created by Andreas Aigner on 06.07.15.
//  Copyright (c) 2015 Egger Apps. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "TTPreferencesWindowController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)initialize {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
        TTShowLineNumbersKey: @YES,
        TTShowColumnNumbersKey: @NO,
        TTShowColumnLettersKey: @NO,
        TTTableFontSizeKey: @13,
        TTAppearanceModeKey: @0  // 0 = System
    }];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self applyAppearanceMode];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(IBAction)showPreferences:(id)sender {
    [[TTPreferencesWindowController sharedController] showWindow:sender];
}

#pragma mark - Appearance Mode

// Appearance モードを適用
-(void)applyAppearanceMode {
    NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:TTAppearanceModeKey];

    switch (mode) {
        case 1:  // Light
            [NSApp setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameAqua]];
            break;
        case 2:  // Dark
            [NSApp setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameDarkAqua]];
            break;
        case 0:  // System
        default:
            [NSApp setAppearance:nil];
            break;
    }
}

// System モードに設定
-(IBAction)setAppearanceModeSystem:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TTAppearanceModeKey];
    [self applyAppearanceMode];
}

// Light モードに設定
-(IBAction)setAppearanceModeLight:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:TTAppearanceModeKey];
    [self applyAppearanceMode];
}

// Dark モードに設定
-(IBAction)setAppearanceModeDark:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:TTAppearanceModeKey];
    [self applyAppearanceMode];
}

// メニューアイテムの状態を検証（チェックマーク表示）
-(BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    NSInteger currentMode = [[NSUserDefaults standardUserDefaults] integerForKey:TTAppearanceModeKey];

    if (menuItem.action == @selector(setAppearanceModeSystem:)) {
        menuItem.state = (currentMode == 0) ? NSControlStateValueOn : NSControlStateValueOff;
    } else if (menuItem.action == @selector(setAppearanceModeLight:)) {
        menuItem.state = (currentMode == 1) ? NSControlStateValueOn : NSControlStateValueOff;
    } else if (menuItem.action == @selector(setAppearanceModeDark:)) {
        menuItem.state = (currentMode == 2) ? NSControlStateValueOn : NSControlStateValueOff;
    }

    return YES;
}

@end
