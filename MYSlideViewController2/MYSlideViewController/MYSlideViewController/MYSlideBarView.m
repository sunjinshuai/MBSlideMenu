//
//  MYSlideBarView.m
//  MYSlideViewController
//
//  Created by Michael on 2017/6/26.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "MYSlideBarView.h"
#import "MYSlideBarViewCell.h"
<<<<<<< HEAD
=======
#import "Constant.h"

//item间隔
static const CGFloat ItemMargin = 10.0f;
//最大放大倍数
static const CGFloat ItemMaxScale = 1.1;
>>>>>>> a8c51632bf1df33e7d6ca18c1ca4b498f75da3e5

@interface MYSlideBarView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
<<<<<<< HEAD
@property (nonatomic, strong) UIView *slideView;
=======
@property (nonatomic, strong) UIView *shadow;
>>>>>>> a8c51632bf1df33e7d6ca18c1ca4b498f75da3e5

@end

@implementation MYSlideBarView

<<<<<<< HEAD
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
=======
static NSString *reuseIdentifier = @"MYSlideBarViewCell";

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
>>>>>>> a8c51632bf1df33e7d6ca18c1ca4b498f75da3e5
    }
    return self;
}

<<<<<<< HEAD
- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
    //如果标题过少 自动居中
    [_collectionView performBatchUpdates:nil completion:^(BOOL finished) {
        if (_collectionView.contentSize.width < _collectionView.bounds.size.width) {
            CGFloat insetX = (_collectionView.bounds.size.width - _collectionView.contentSize.width)/2.0f;
            _collectionView.contentInset = UIEdgeInsetsMake(0, insetX, 0, insetX);
        }
    }];
    //设置阴影
    _slideView.backgroundColor = _itemSelectedColor;
    self.selectedIndex = _selectedIndex;
    _slideView.hidden = _hideShadow;
}

#pragma mark -
#pragma mark CollectionViewDelegate
=======
- (void)setupUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = ItemMargin;
    layout.sectionInset = UIEdgeInsetsMake(0, ItemMargin, 0, ItemMargin);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[MYSlideBarViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    _collectionView.showsHorizontalScrollIndicator = false;
    [self addSubview:_collectionView];
    
    _shadow = [[UIView alloc] init];
    [_collectionView addSubview:_shadow];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    // 如果标题过少 自动居中
    [self.collectionView performBatchUpdates:nil completion:^(BOOL finished) {
        if (self.collectionView.contentSize.width < self.collectionView.bounds.size.width) {
            CGFloat insetX = (self.collectionView.bounds.size.width - self.collectionView.contentSize.width)/2.0f;
            self.collectionView.contentInset = UIEdgeInsetsMake(0, insetX, 0, insetX);
        }
    }];
    self.shadow.frame = [self shadowRectOfIndex:self.selectedIndex];
}

#pragma mark - UICollectionViewDelegate、UICollectionViewDataSource
>>>>>>> a8c51632bf1df33e7d6ca18c1ca4b498f75da3e5
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
<<<<<<< HEAD
    return CGSizeMake([self itemWidthOfIndexPath:indexPath], _collectionView.bounds.size.height);
=======
    NSString *title = self.titles[indexPath.row];
    CGFloat titleWidth = [title sizeWithMaxWidth:MAXFLOAT font:[UIFont systemFontOfSize:17.0]].width;
    return CGSizeMake(titleWidth, self.bounds.size.height);
>>>>>>> a8c51632bf1df33e7d6ca18c1ca4b498f75da3e5
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MYSlideBarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MYSlideBarViewCell" forIndexPath:indexPath];
<<<<<<< HEAD
    cell.textLabel.text = _titles[indexPath.row];
    
=======
    cell.textLabel.text = self.titles[indexPath.row];
    CGFloat scale = indexPath.row == _selectedIndex ? ItemMaxScale : 1;
    cell.transform = CGAffineTransformMakeScale(scale, scale);
>>>>>>> a8c51632bf1df33e7d6ca18c1ca4b498f75da3e5
    cell.textLabel.textColor = indexPath.row == _selectedIndex ? _itemSelectedColor : _itemNormalColor;
    return cell;
}

<<<<<<< HEAD
//获取文字宽度
- (CGFloat)itemWidthOfIndexPath:(NSIndexPath*)indexPath {
    NSString *title = _titles[indexPath.row];
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],
                                 NSParagraphStyleAttributeName:style
                                 };
    CGSize textSize = [title boundingRectWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height)
                                          options:opts
                                       attributes:attributes
                                          context:nil].size;
    return textSize.width;
}


- (CGRect)shadowRectOfIndex:(NSInteger)index {
    return CGRectMake([_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]].frame.origin.x, self.bounds.size.height - 2, [self itemWidthOfIndexPath:[NSIndexPath indexPathForRow:index inSection:0]], 2);
=======
- (CGRect)shadowRectOfIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSString *title = self.titles[indexPath.row];
    CGFloat titleWidth = [title sizeWithMaxWidth:MAXFLOAT font:[UIFont systemFontOfSize:17.0]].width;
    MYSlideBarViewCell *currentCell = (MYSlideBarViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return CGRectMake(currentCell.frame.origin.x, self.bounds.size.height - 2, titleWidth, 2);
>>>>>>> a8c51632bf1df33e7d6ca18c1ca4b498f75da3e5
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    _ignoreAnimation = true;
}

<<<<<<< HEAD
#pragma mark -
#pragma mark 功能性方法
- (UIColor *)transformFromColor:(UIColor*)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress {
    
    progress = progress >= 1 ? 1 : progress;
    
    progress = progress <= 0 ? 0 : progress;
    
    const CGFloat * fromeComponents = CGColorGetComponents(fromColor.CGColor);
    
    const CGFloat * toComponents = CGColorGetComponents(toColor.CGColor);
    
    size_t  fromColorNumber = CGColorGetNumberOfComponents(fromColor.CGColor);
    size_t  toColorNumber = CGColorGetNumberOfComponents(toColor.CGColor);
    
=======
#pragma mark - setter & getter
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    _shadow.frame = [self shadowRectOfIndex:selectedIndex];
    
    // 居中滚动标题
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    [self.collectionView reloadData];
    
    // 执行代理方法
    if ([_delegate respondsToSelector:@selector(slideBarSelectedAtIndex:)]) {
        [_delegate slideBarSelectedAtIndex:_selectedIndex];
    }
}

// 更新下划线位置
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    // 如果手动点击则不执行以下动画
    if (_ignoreAnimation) {
        return;
    }
    // 更新下划线位置
    [self updateShadowPosition:progress];
    // 更新标题颜色、大小
    [self updateItem:progress];
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self.collectionView reloadData];
}

- (void)updateShadowPosition:(CGFloat)progress {
    
    // progress > 1 向左滑动表格反之向右滑动表格
    NSInteger nextIndex = progress > 1 ? _selectedIndex + 1 : _selectedIndex - 1;
    if (nextIndex < 0 || nextIndex == _titles.count) {
        return;
    }
    // 获取当前阴影位置
    CGRect currentRect = [self shadowRectOfIndex:_selectedIndex];
    CGRect nextRect = [self shadowRectOfIndex:nextIndex];
    // 如果在此时cell不在屏幕上 则不显示动画
    if (CGRectGetMinX(currentRect) <= 0 || CGRectGetMinX(nextRect) <= 0) {
        return;
    }
    
    progress = progress > 1 ? progress - 1 : 1 - progress;
    
    // 更新宽度
    CGFloat width = currentRect.size.width + progress*(nextRect.size.width - currentRect.size.width);
    CGRect bounds = _shadow.bounds;
    bounds.size.width = width;
    _shadow.bounds = bounds;
    
    // 更新位置
    CGFloat distance = CGRectGetMidX(nextRect) - CGRectGetMidX(currentRect);
    _shadow.center = CGPointMake(CGRectGetMidX(currentRect) + progress* distance, _shadow.center.y);
}

// 更新标题颜色
- (void)updateItem:(CGFloat)progress {
    
    NSInteger nextIndex = progress > 1 ? _selectedIndex + 1 : _selectedIndex - 1;
    if (nextIndex < 0 || nextIndex == _titles.count) {
        return;
    }
    
    MYSlideBarViewCell *currentItem = (MYSlideBarViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    MYSlideBarViewCell *nextItem = (MYSlideBarViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndex inSection:0]];
    progress = progress > 1 ? progress - 1 : 1 - progress;
    
    // 更新颜色
    currentItem.textLabel.textColor = [self transformFromColor:_itemSelectedColor toColor:_itemNormalColor progress:progress];
    nextItem.textLabel.textColor = [self transformFromColor:_itemNormalColor toColor:_itemSelectedColor progress:progress];
    
    // 更新放大
    CGFloat currentItemScale = ItemMaxScale - (ItemMaxScale - 1) * progress;
    CGFloat nextItemScale = 1 + (ItemMaxScale - 1) * progress;
    currentItem.transform = CGAffineTransformMakeScale(currentItemScale, currentItemScale);
    nextItem.transform = CGAffineTransformMakeScale(nextItemScale, nextItemScale);
}

- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
    _itemSelectedColor = itemSelectedColor;
    _shadow.backgroundColor = itemSelectedColor;
}

- (void)setHideShadow:(BOOL)hideShadow {
    _hideShadow = hideShadow;
    _shadow.hidden = _hideShadow;
}

#pragma mark - Private Method
- (UIColor *)transformFromColor:(UIColor*)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress
{
    progress = progress >= 1 ? 1 : progress;
    progress = progress <= 0 ? 0 : progress;
    const CGFloat * fromeComponents = CGColorGetComponents(fromColor.CGColor);
    const CGFloat * toComponents = CGColorGetComponents(toColor.CGColor);
    size_t fromColorNumber = CGColorGetNumberOfComponents(fromColor.CGColor);
    size_t toColorNumber = CGColorGetNumberOfComponents(toColor.CGColor);
>>>>>>> a8c51632bf1df33e7d6ca18c1ca4b498f75da3e5
    if (fromColorNumber == 2) {
        CGFloat white = fromeComponents[0];
        fromColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        fromeComponents = CGColorGetComponents(fromColor.CGColor);
    }
<<<<<<< HEAD
    
=======
>>>>>>> a8c51632bf1df33e7d6ca18c1ca4b498f75da3e5
    if (toColorNumber == 2) {
        CGFloat white = toComponents[0];
        toColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        toComponents = CGColorGetComponents(toColor.CGColor);
    }
<<<<<<< HEAD
    
    CGFloat red = fromeComponents[0]*(1 - progress) + toComponents[0]*progress;
    CGFloat green = fromeComponents[1]*(1 - progress) + toComponents[1]*progress;
    CGFloat blue = fromeComponents[2]*(1 - progress) + toComponents[2]*progress;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

#pragma mark - setter & getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 20;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MYSlideBarViewCell class] forCellWithReuseIdentifier:@"MYSlideBarViewCell"];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIView *)slideView {
    if (!_slideView) {
        _slideView = [[UIView alloc] init];
    }
    return _slideView;
=======
    CGFloat red = fromeComponents[0] * (1 - progress) + toComponents[0] * progress;
    CGFloat green = fromeComponents[1] * (1 - progress) + toComponents[1] * progress;
    CGFloat blue = fromeComponents[2] * (1 - progress) + toComponents[2] * progress;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
>>>>>>> a8c51632bf1df33e7d6ca18c1ca4b498f75da3e5
}

@end
