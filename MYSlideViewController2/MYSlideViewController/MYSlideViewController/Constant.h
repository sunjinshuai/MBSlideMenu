//
//  Constant.h
//  MYSlideViewController
//
//  Created by michael on 2017/6/27.
//  Copyright © 2017年 Michael. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#import <Masonry.h>
#import "NSString+Extension.h"
#import "UIColor+Additions.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define FXScreenWidth [UIScreen mainScreen].bounds.size.width
#define FXScreenHeight [UIScreen mainScreen].bounds.size.height
#define FXRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#endif /* Constant_h */
