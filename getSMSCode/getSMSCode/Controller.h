//
//  Controller.h
//  getSMSCode
//
//  Created by LLZ on 2018/1/25.
//  Copyright © 2018年 LLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    YHBank,
    XCBank,
} ProjectType;

@class ViewModel;
@interface Controller : NSObject

@property (nonatomic, strong, readonly) ViewModel *viewModel;

@property (nonatomic, assign, readonly) BOOL isRequesting;
/**
 单例
 
 @return 单例
 */
+ (instancetype)shareController;
/**
 初始化状态栏图标，及其他设置
 */
- (void)start;

- (void)checkSMSCodeWithProjecttype:(ProjectType)type;
@end
