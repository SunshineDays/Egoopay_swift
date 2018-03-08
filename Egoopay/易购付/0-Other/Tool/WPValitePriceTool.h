//
//  WPValitePriceTool.h
//  Egoopay
//
//  Created by 易购付 on 2017/11/17.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPValitePriceTool : NSObject

+ (BOOL)validatePrice:(NSString *)textField range:(NSRange)range replacementString:(NSString *)string;


@end
