//
//  SMSCodeModel.h
//  getSMSCode
//
//  Created by LLZ on 2018/1/25.
//  Copyright © 2018年 LLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSCodeModel : NSObject

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *smsCode;

@end
