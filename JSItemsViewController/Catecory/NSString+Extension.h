//
//  NSString+Extension.h
//  JSItemsViewController
//
//  Created by Michael on 16/7/5.
//  Copyright © 2016年 com.51fanxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extension)

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font;

- (CGSize)mySizeWithFont:(UIFont *)font maxSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode;
- (CGSize)mySizeWithFont:(UIFont *)font;
- (CGSize)mySizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)mySizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
