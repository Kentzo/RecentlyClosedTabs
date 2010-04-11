//
//  RCTUpdaterMain.m
//  RecentlyClosedTabs
//
//  Created by Ilya Kulakov on 11.04.10.
//  Copyright 2010. All rights reserved.
//

#import "RCTUpdaterMain.h"
#import <Sparkle/Sparkle.h>


@implementation RCTUpdaterMain

- (void)awakeFromNib {
    NSArray* arguments = [[NSProcessInfo processInfo] arguments];
    if ([arguments count] > 4) {
        bundleIdentifier = [arguments objectAtIndex:1];
        processID = [[arguments objectAtIndex:2] integerValue];
        pathToRelaunch = [arguments objectAtIndex:3];
        isBackground = [[arguments objectAtIndex:4] isEqualToString:@"--background"];
        
        // Add observer for SUUpdateDriverFinished notification to terminate updater app
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateDidFinish:)
                                                     name:@"SUUpdateDriverFinished"
                                                   object:nil];
        
        [[SUUpdater sharedUpdater] setDelegate:self];
        
        if (isBackground) {
            [[SUUpdater sharedUpdater] checkForUpdatesInBackground];
        }
        else {
            [[SUUpdater sharedUpdater] checkForUpdates:0];
        }
    }
}

- (void)updateDidFinish:(NSNotification*)notification {
    [NSApp terminate:self];
}

#pragma mark SUUpdaterDelegate 
// As SUUpdaterDelegate is informal protocol, we have to add selectors manually
- (NSString *)pathToRelaunchForUpdater:(SUUpdater *)updater {
    return pathToRelaunch;
}
- (NSInteger)PIDToListenForRelaunch:(SUUpdater *)updater {
    return processID;
}
- (BOOL)updater:(SUUpdater *)updater shouldPostponeRelaunchForUpdate:(SUAppcastItem *)update untilInvoking:(NSInvocation *)invocation {
    [NSApp activateIgnoringOtherApps:YES];
    
    // 
    NSInteger result = NSRunAlertPanel(@"Relaunch Safari now?",
                                       @"To use the new features of RecentlyClosedTabs, Safari needs to be relaunched.",
                                       @"Relaunch",
                                       @"Do not relaunch",
                                       nil);
    
    BOOL shouldPostpone = YES;
    if (result == NSAlertDefaultReturn) {
        
        NSAppleEventDescriptor *target = [NSAppleEventDescriptor descriptorWithDescriptorType:typeApplicationBundleID
																						 data:[bundleIdentifier dataUsingEncoding:NSUTF8StringEncoding]];
		NSAppleEventDescriptor *quitEvent = [NSAppleEventDescriptor appleEventWithEventClass:kCoreEventClass
																					 eventID:kAEQuitApplication
																			targetDescriptor:target
																					returnID:kAutoGenerateReturnID
																			   transactionID:kAnyTransactionID];
		OSStatus err = AESendMessage([quitEvent aeDesc],    //  theAppleEvent
									 NULL,                  //  reply
									 kAENoReply,            //  sendMode
									 0);                    //  sendPriority
        if (err == noErr) {
            shouldPostpone = NO;
        }
    }
    
    return shouldPostpone;
}
- (void)updater:(SUUpdater *)updater didFindValidUpdate:(SUAppcastItem *)update {
    [NSApp activateIgnoringOtherApps:YES];
}
         
@end
