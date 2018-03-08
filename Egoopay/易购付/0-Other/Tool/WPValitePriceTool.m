//
//  WPValitePriceTool.m
//  Egoopay
//
//  Created by 易购付 on 2017/11/17.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

#import "WPValitePriceTool.h"

@implementation WPValitePriceTool


/** 验证价格 */
+ (BOOL)validatePrice:(NSString *)textField range:(NSRange)range replacementString:(NSString *)string
{
    if ([string length] == 0)
    {
        return YES;
    }
    else if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') //数据格式正确
        {
            if([textField length] == 0)
            {
                if(single == '.') //首字母不能为小数点
                {
                    return NO;
                }
                else
                {
                    return YES;
                }
            }
            if ([textField length] == 1)
            {
                if ([textField isEqualToString:@"0"] && single != '.') //首字母为0时，只能以0.开头
                {
                    return NO;
                }
                else
                {
                    return YES;
                }
            }
            if (single == '.')
            {
                if([textField rangeOfString:@"."].location == NSNotFound) //text中还没有小数点
                {
                    return YES;
                }
                else
                {
                    return NO;
                }
            }
            else
            {
                if([textField rangeOfString:@"."].location != NSNotFound) //text中有小数点
                {
                    NSRange ran = [textField rangeOfString:@"."];
                    if (range.location - ran.location <= 2)  //小数只有两位
                    {
                        return YES;
                    }
                    else
                    {
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}


@end
