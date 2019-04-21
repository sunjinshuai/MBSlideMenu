//
//  MBNavigationBar.h
//  MBSlideMenu
//
//  Created by sunjinshuai on 2019/4/21.
//  Copyright © 2019 sunjinshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBNavigationBar : UIView

@property (nonatomic, copy) void(^onClickLeftButton)(void);
@property (nonatomic, copy) void(^onClickRightButton)(void);

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) UIColor  *titleLabelColor;
@property (nonatomic, strong) UIFont   *titleLabelFont;
@property (nonatomic, strong) UIColor  *barBackgroundColor;
@property (nonatomic, strong) UIImage  *barBackgroundImage;

- (void)setBottomLineHidden:(BOOL)hidden;
- (void)setBackgroundAlpha:(CGFloat)alpha;
- (void)setTintColor:(UIColor *)color;

- (void)setLeftButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted;
- (void)setLeftButtonWithImage:(UIImage *)image;
- (void)setLeftButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;

- (void)setRightButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted;
- (void)setRightButtonWithImage:(UIImage *)image;
- (void)setRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;

@end

NS_ASSUME_NONNULL_END
