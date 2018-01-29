//
//  ViewModel.m
//  getSMSCode
//
//  Created by LLZ on 2018/1/25.
//  Copyright © 2018年 LLZ. All rights reserved.
//

#import "ViewModel.h"

@interface ViewModel()

@property (nonatomic, strong, readwrite) NSArray <SMSCodeModel *>*smsCodes;

@end

@implementation ViewModel

- (void)updateCodesInProjecttype:(ProjectType)type withHtmlString:(NSString *)htmlstring
{
//    NSString *temp = [htmlstring stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *temp = [htmlstring stringByReplacingOccurrencesOfString:@"\r" withString:@""];//换行
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];//回车
    temp = [temp stringByReplacingOccurrencesOfString:@"\t" withString:@""];//横向跳格,tab
    if (type == YHBank) {
        //处理字符串，方便后面截取
        temp = [temp stringByReplacingOccurrencesOfString:@"手机号或邮箱：" withString:@""];
        temp = [temp stringByReplacingOccurrencesOfString:@";时间：" withString:@"@"];
        temp = [temp stringByReplacingOccurrencesOfString:@"验证码：" withString:@"@"];
        
        self.smsCodes = [self parseSMSCodeWithHtmlStr:temp];
    } else if (type == XCBank){
        NSArray *tbs = [self parseTBODYWithHtmlStr:temp];
        if (tbs.count > 0) {
            NSArray *trs = [self parseTRWithHtmlStr:tbs[0]];
            self.smsCodes = [self parseSMSCodeWithTrStr:trs];
        } else {
            self.smsCodes = @[];
        }
    } else {
        self.smsCodes = @[];
    }
}

//YHBank用
//匹配li标签内容，并转成SMSCodeModel列表
- (NSArray <SMSCodeModel *>*)parseSMSCodeWithHtmlStr:(NSString *)html
{
    NSString *li = @"<li>(.|\n)*?</li>";
    NSArray <NSString *>*lis = [self matchesInString:html withPattern:li];
    
    NSMutableArray *smsModels = [NSMutableArray array];
    [lis enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SMSCodeModel *sms = [SMSCodeModel new];
        NSString *temp = [self removeHTMLLableWithString:obj];
        NSArray *array = [temp componentsSeparatedByString:@"@"];
        if (array.count == 3) {
            sms.phone = array[0];
            sms.time = array[1];
            sms.smsCode = array[2];
        }
        [smsModels addObject:sms];
    }];
    return smsModels;
}

- (NSArray <NSString *>*)parseTBODYWithHtmlStr:(NSString *)html
{
    NSString *tb = @"<tbody.*(?=>)(.|\n)*?</tbody>";
    return [self matchesInString:html withPattern:tb];
}

- (NSArray <NSString *>*)parseTRWithHtmlStr:(NSString *)html
{
    NSString *tr = @"<tr class=\"text-c\">(.|\n)*?</tr>";
    return [self matchesInString:html withPattern:tr];
}

- (NSArray <SMSCodeModel *>*)parseSMSCodeWithTrStr:(NSArray *)trs
{
    NSMutableArray *smsModels = [NSMutableArray array];
    [trs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *td = @"<td>(.|\n)*?</td>";
        NSArray <NSString *>*tds = [self matchesInString:obj withPattern:td];
        SMSCodeModel *sms = [SMSCodeModel new];
        if (tds.count == 7) {
            sms.time = [self removeHTMLLableWithString:tds[5]];
            sms.phone = [self removeHTMLLableWithString:tds[3]];
            
            NSString *temp = [self removeHTMLLableWithString:tds[2]];
            NSArray *array = [temp componentsSeparatedByString:@"，"];
            sms.smsCode = [self removeHTMLLableWithString:[array firstObject]];
        }
        [smsModels addObject:sms];
    }];
    return smsModels;
}

//根据正则表达式匹配字符串
- (NSArray <NSString *>*)matchesInString:(NSString *)string withPattern:(NSString *)pattern
{
    if (string.length > 0) {
        NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray <NSTextCheckingResult *>*arr = [regExp matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
        NSMutableArray *strs = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [strs addObject:[string substringWithRange:obj.range]];
        }];
        return strs;
    } else {
        return @[];
    }
}
//去除html标签
- (NSString *)removeHTMLLableWithString:(NSString *)string
{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    string = [regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    return string;
}
@end
