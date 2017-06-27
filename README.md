# MYSlideViewController



![效果图1](https://github.com/sunjinshuai/MYSementViewController/blob/master/MYSlideViewController1/MYSlideViewController.gif)

![效果图2](https://github.com/sunjinshuai/MYSementViewController/blob/master/MYSlideViewController2/MYSlideViewController.gif)


===================================  

目前在项目中需要品牌分类的功能，于是自己就封装了一个控制器，主要用到了UICollectionView和UIScrollView的组合，效果类似电商app的嗨购和蜜芽的滚动条，感觉还行就把我的思路和制作过程写下来给大家分享一下。

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/588630-42392129475860ba.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

首先，界面分析。
上半部分用的是UICollectionView
下半部分用的是UIScrollView

上半部分的UICollectionView的Item是可以动态配置的，随着字体的宽度决定的。

```
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
CGFloat height = collectionView.frame.size.height;
CGFloat width = 0;
CGRect bgFrame = CGRectFromString(self.indicatorBgFrames[indexPath.row]);
width = bgFrame.size.width;
return CGSizeMake(width, height);
}
```

下半的是UIScrollView则写的有点复杂了，为了节省空间，控制器的个数当>=3的时候，只会显示3个。

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/588630-f9e5ed8ae5e02bb9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


最后有2个代理方法恭你选择
```
- (void)slideViewController:(MYSlideViewController *)slideViewController didSelectViewIndex:(NSInteger)selectViewIndex;

- (BOOL)slideViewController:(MYSlideViewController *)slideViewController shouldSelectViewIndex:(NSInteger)selectViewIndex;
```

ps:
我是一个iOS的苦行僧，喜欢开源，平常也会在github上上传一些个人的项目，欢迎志同道合的朋友一起加入。
另外，如果我封装的这个控制器能帮到你，就star一下吧。
