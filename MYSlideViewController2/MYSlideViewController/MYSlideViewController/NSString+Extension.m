//
//  NSString+Extension.m
//  MYSlideViewController
//
//  Created by michael on 2017/6/27.
//  Copyright © 2017年 Michael. All rights reserved.
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

@end
