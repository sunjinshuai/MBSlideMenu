//
//  NSString+Extension.m
//  JSItemsViewController
//
//  Created by Michael on 16/7/5.
//  Copyright © 2016年 com.51fanxing. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth addributes:(NSDictionary *)attributes
{
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = font;
    return [self sizeWithMaxWidth:maxWidth addributes:attributes];
}

- (CGSize)mySizeWithFont:(UIFont *)font maxSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode
{
    CGSize realSize = CGSizeZero;
    CGRect textRect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    realSize = textRect.size;
    realSize.width = ceilf(realSize.width);
    realSize.height = ceilf(realSize.height);
    return realSize;
}

- (CGSize)mySizeWithFont:(UIFont *)font
{
    CGSize resultSize = [self mySizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, font.lineHeight)];
    
    return resultSize;
}

- (CGSize)mySizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize resultSize = [self mySizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    return resultSize;
}

- (CGSize)mySizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize resultSize = [self mySizeWithFont:font maxSize:size lineBreakMode:lineBreakMode];
    
    return resultSize;
}


@end
