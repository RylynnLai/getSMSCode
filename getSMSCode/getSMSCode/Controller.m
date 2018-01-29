//
//  Controller.m
//  getSMSCode
//
//  Created by LLZ on 2018/1/25.
//  Copyright © 2018年 LLZ. All rights reserved.
//

#import "Controller.h"
#import <AppKit/AppKit.h>
#import "PopOverVC.h"
#import "ViewModel.h"

static NSString *YHBankSMSCodeURL = @"http://fyyhm.ucsmy.com/account/numberCode.do";
static NSString *XCBankSMSCodeURL = @"http://tmxc.ucsmy.com/Test/TestSmsList?TemplateName=ValidateCode";

@interface Controller()<NSUserNotificationCenterDelegate>
@property (nonatomic, strong) NSStatusItem *statusItem;//状态栏图标
@property (nonatomic, strong) NSPopover *popOverView;//弹窗

@property (nonatomic, assign, readwrite) BOOL isRequesting;
@property (nonatomic, strong, readwrite) ViewModel *viewModel;
@end

@implementation Controller

+ (instancetype)shareController{
    static dispatch_once_t pred;
    static Controller *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [Controller new];
    });
    return sharedInstance;
}

- (void)start
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem.button setImage:[NSImage imageNamed:@"logo"]];
    self.statusItem.target = self;
    self.statusItem.action = @selector(popOverView:);
    
    self.popOverView = [NSPopover new];
    self.popOverView.behavior = NSPopoverBehaviorTransient;
    self.popOverView.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
    self.popOverView.contentViewController = [PopOverVC new];
    
    self.viewModel = [ViewModel new];
    
    //添加一个全局的鼠标左键点击事件，关闭popoverview
    __weak typeof (self) weakself = self;
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown handler:^(NSEvent * _Nonnull event) {
        if (weakself.popOverView.isShown) {
            [weakself.popOverView close];
        }
    }];
    
    
//    [self.viewModel addObserver:self forKeyPath:NSStringFromSelector(@selector(isLogin)) options:NSKeyValueObservingOptionNew context:nil];
//    [self.viewModel addObserver:self forKeyPath:NSStringFromSelector(@selector(hasNewBugs)) options:NSKeyValueObservingOptionNew context:nil];
    
//    [self checkChanDao];
//    [self startTimer];
    [self checkSMSCodeWithProjecttype:YHBank];
}

- (void)popOverView:(NSStatusBarButton *)btn
{
    [self.popOverView showRelativeToRect:btn.bounds ofView:btn preferredEdge:NSRectEdgeMaxY];
}

- (void)checkSMSCodeWithProjecttype:(ProjectType)type
{
    NSString *url = nil;
    switch (type) {
        case YHBank:
            url = YHBankSMSCodeURL;
            break;
        case XCBank:
            url = XCBankSMSCodeURL;
            break;
        default:
            break;
    }
    NSMutableURLRequest *SMSCodeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    SMSCodeRequest.HTTPMethod = @"GET";
    self.isRequesting = YES;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:SMSCodeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"当前线程：%@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isRequesting = NO;
            NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [self.viewModel updateCodesInProjecttype:type withHtmlString:htmlStr];
        });
    }];
    [task resume];
}

@end
