//
//  RCTUpdaterMain.h
//  RecentlyClosedTabs
//
//  Created by Илья Кулаков on 11.04.10.
//  Copyright 2010. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SUUpdater, SUAppcastItem;

@interface RCTUpdaterMain : NSObject /*SUUpdater delegate*/ {
    NSString* bundleIdentifier;
    NSInteger processID;
    NSString* pathToRelaunch;
    BOOL isBackground;
}

- (void)updateDidFinish:(NSNotification*)notification;

// As SUUpdaterDelegate is informal protocol, we have to add selectors manually
- (NSString *)pathToRelaunchForUpdater:(SUUpdater *)updater;
- (NSInteger)PIDToListenForRelaunch:(SUUpdater *)updater;
- (BOOL)updater:(SUUpdater *)updater shouldPostponeRelaunchForUpdate:(SUAppcastItem *)update untilInvoking:(NSInvocation *)invocation;
- (void)updater:(SUUpdater *)updater didFindValidUpdate:(SUAppcastItem *)update;

@end
