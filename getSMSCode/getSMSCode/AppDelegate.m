//
//  AppDelegate.m
//  getSMSCode
//
//  Created by LLZ on 2018/1/25.
//  Copyright © 2018年 LLZ. All rights reserved.
//

#import "AppDelegate.h"
#import "Controller.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [[Controller shareController] start];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
