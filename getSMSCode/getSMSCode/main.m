//
//  main.m
//  getSMSCode
//
//  Created by LLZ on 2018/1/25.
//  Copyright © 2018年 LLZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    NSApplication *app = [NSApplication sharedApplication];
    id delegate = [[AppDelegate alloc]init];
    app.delegate = delegate;
    return NSApplicationMain(argc, argv);
}
