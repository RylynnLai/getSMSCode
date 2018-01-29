//
//  ViewModel.h
//  getSMSCode
//
//  Created by LLZ on 2018/1/25.
//  Copyright © 2018年 LLZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSCodeModel.h"
#import "Controller.h"

@interface ViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray <SMSCodeModel *>*smsCodes;

- (void)updateCodesInProjecttype:(ProjectType)type withHtmlString:(NSString *)htmlstring;
@end
