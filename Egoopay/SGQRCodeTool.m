//
//  SGQRCodeTool.m
//  SGQRCodeExample
//
//  Created by Sorgle on 16/12/2.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "SGQRCodeTool.h"

@implementation SGQRCodeTool

/**
 *  生成一张普通的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param imageViewWidth    图片的宽度
 */
+ (UIImage *)SG_generateWithDefaultQRCodeData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth
{
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *info = data;
    // 将字符串转换成
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    
    // 通过KVC设置滤镜inputMessage数据
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    return [SGQRCodeTool createNonInterpolatedUIImageFormCIImage:outputImage withSize:imageViewWidth];
}

/** 根据CIImage生成指定大小的UIImage */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


/**
 *  生成一张带有logo的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param logoImage    logo的image
 *  @param logoScaleToSuperView    logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+ (UIImage *)SG_generateWithLogoQRCodeData:(NSString *)data logoImage:(UIImage *)logoImage logoScaleToSuperView:(CGFloat)logoScaleToSuperView
{
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = data;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 图片小于(20,20),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    // 4、将CIImage类型转成UIImage类型
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
//    start_image = [self imageWithColor:[UIColor blueColor] image:start_image];
    
    
    // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
    // 5、开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
    UIGraphicsBeginImageContext(start_image.size);
    
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    
    // 再把小图片画上去
    UIImage *icon_image = logoImage;
    CGFloat icon_imageW = start_image.size.width * logoScaleToSuperView;
    CGFloat icon_imageH = start_image.size.height * logoScaleToSuperView;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    
    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 6、获取当前画得的这张图片
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 7、关闭图形上下文
    UIGraphicsEndImageContext();
    
    return final_image;
}

/**
 *  生成一张彩色的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param backgroundColor    背景色
 *  @param mainColor    主颜色
 */
+ (UIImage *)SG_generateWithColorQRCodeData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor
{
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = data;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    
    // 4、创建彩色过滤器(彩色的用的不多)
    CIFilter * color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    
    // 设置默认值
    [color_filter setDefaults];
    
    // 5、KVC 给私有属性赋值
    [color_filter setValue:outputImage forKey:@"inputImage"];
    
    // 6、需要使用 CIColor
    [color_filter setValue:backgroundColor forKey:@"inputColor0"];
    [color_filter setValue:mainColor forKey:@"inputColor1"];
    
    // 7、设置输出
    CIImage *colorImage = [color_filter outputImage];
    
    return [UIImage imageWithCIImage:colorImage];
}


+ (UIImage *)imageWithColor:(UIColor *)color image:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(contextRef, 0, image.size.height - 20);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    CGContextSetBlendMode(contextRef, kCGBlendModeNormal);
    
    CGRect rect = CGRectMake(0, 0, image.size.width - 20, image.size.height - 20);
    CGContextClipToMask(contextRef, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(contextRef, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// 给图片添加logo
+ (UIImage *)addWatemarkImageWithLogoImage:(UIImage *)logoImage watemarkImage:(UIImage *)watemarkImage logoImageRect:(CGRect)logoImageRect watemarkImageRect:(CGRect)watemarkImageRect
{
    // 创建一个graphics context来画我们的东西
    UIGraphicsBeginImageContext(logoImageRect.size);
    // graphics context就像一张能让我们画上任何东西的纸。我们要做的第一件事就是把person画上去
    [logoImage drawInRect:CGRectMake(0, 0, logoImageRect.size.width, logoImageRect.size.height)];
    // 然后在把hat画在合适的位置
    [watemarkImage drawInRect:CGRectMake(watemarkImageRect.origin.x, watemarkImageRect.origin.y, watemarkImageRect.size.width, watemarkImageRect.size.height)];
    // 通过下面的语句创建新的UIImage
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    // 最后，我们必须得清理并关闭这个再也不需要的context
    UIGraphicsEndImageContext();
    return resultImage;
}


@end

