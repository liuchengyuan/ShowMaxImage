//
//  SeeMAxImage.m
//  Template
//
//  Created by 刘诚远 on 16/1/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "ShowMaxImage.h"

@implementation ShowMaxImage
{
    //主要滚动视图
    UIScrollView *FScrollView;
    
    //主要显示图片视图
    UIImageView *FShowImageView;
    
    //图片原始框架
    CGRect FImageOriginalRect;
    
    //默认缩放比例
    CGFloat FProportionFloat;
    
    //水平边距
    CGFloat FLevelFloat;
    
    //垂直边距
    CGFloat FVerticalFloat;
}


//获取单利
+(ShowMaxImage *)showMaxImage {
    
    static ShowMaxImage *showMaxImage = nil;
    
    if (showMaxImage == nil)  {
        
        showMaxImage = [[ShowMaxImage alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    [showMaxImage initView];
    
    return showMaxImage;
}


#pragma mark - 初始化方法
//初始化视图
- (void)initView {
    
    //初始化滚动视图
    FScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    [FScrollView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    
    [FScrollView setShowsHorizontalScrollIndicator:NO];
    
    [FScrollView setShowsVerticalScrollIndicator:NO];
    
    [FScrollView setDelegate:self];
    
    [self addSubview:FScrollView];
    
    //添加按手势————单击还原关闭图片
    UITapGestureRecognizer *oneTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];

    [FScrollView addGestureRecognizer:oneTap];
    
    //添加按手势————双击放大缩小图片
    UITapGestureRecognizer *twoTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
    
    [twoTap setNumberOfTapsRequired:2];
    
    [FScrollView addGestureRecognizer:twoTap];
    
    //设置单、双击优先级(先识别双击，再识别单击)
    [oneTap requireGestureRecognizerToFail:twoTap];
    
    FShowImageView = [[UIImageView alloc] init];
    
    [FShowImageView setUserInteractionEnabled:YES];
    
    [FScrollView addSubview:FShowImageView];
}

#pragma mark - 自定义共有方法
//显示图片
- (void)showImage:(UIImageView *)imageView {
    //添加显示视图
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    //初始化图片显示视图
    [self initImageView:imageView];
    
    //图片适应居中显示(带动画)
    [self ImageAdaptCenter];
}

#pragma mark - 自定义私有方法
//初始化显示图片
- (void)initImageView:(UIImageView *)imageView {
    
    //保存图片原始框架————相对屏幕位置
    {
        FImageOriginalRect = imageView.bounds;
        
        FImageOriginalRect.origin = [imageView convertPoint:CGPointMake(0, 0) toView:[[UIApplication sharedApplication] keyWindow]];
    }
    
    //计算默认缩放比例
    {
        CGSize AImageSize = imageView.image.size;
        
        FProportionFloat = CGRectGetHeight(self.frame) / AImageSize.height;
        
        if (AImageSize.width * FProportionFloat > CGRectGetWidth(self.frame)) {
            
            FProportionFloat = CGRectGetWidth(self.frame) / AImageSize.width;
        }
    }
    
    //初始化图片视图
    {
        [FShowImageView setImage:imageView.image];
        
        [FShowImageView setFrame:FImageOriginalRect];
    }
}

//初始化缩放比例
- (void)initScaling {
    
    //设置主要滚动视图滚动范围和缩放比例
    [FScrollView setContentSize:FShowImageView.image.size];
    
    //设置最小伸缩比例
    [FScrollView setMinimumZoomScale:FProportionFloat];
    
    //设置最大伸缩比例
    [FScrollView setMaximumZoomScale:FProportionFloat * 3];
    
    //默认缩放比例
    [FScrollView setZoomScale:FProportionFloat];
}

//初始化边距
- (void)initMargin {
    
    //水平边距
    FLevelFloat = (self.frame.size.width - FShowImageView.image.size.width * FScrollView.zoomScale)  / 2.0;
    if (FLevelFloat < 0) {
        
        FLevelFloat = 0;
    }
    
    //垂直边距
    FVerticalFloat = (CGRectGetHeight(self.frame) - FShowImageView.image.size.height * FScrollView.zoomScale) / 2.0;
    if (FVerticalFloat < 0) {
        
        FVerticalFloat = 0;
    }
    
    //设置边距
    [FScrollView setContentInset:UIEdgeInsetsMake(FVerticalFloat, FLevelFloat, FVerticalFloat, FLevelFloat)];
}

//图片适应居中(带动画效果)
- (void)ImageAdaptCenter {
    
    [UIView animateWithDuration:0.4 animations:^{
        
        [FScrollView setBackgroundColor:[UIColor blackColor]];
        
        CGRect ARect = FShowImageView.frame;
        
        ARect.size.width = FShowImageView.image.size.width * FProportionFloat;
        
        ARect.size.height = FShowImageView.image.size.height * FProportionFloat;
        
        FShowImageView.frame = ARect;
        
        FShowImageView.center = self.center;
        
        
    } completion:^(BOOL finished) {
        
        [FShowImageView setFrame:CGRectMake(0, 0, FShowImageView.image.size.width, FShowImageView.image.size.height)];
        
        //初始化缩放比例
        [self initScaling];
        
        //初始化边距
        [self initMargin];
    }];
}

//图片还原关闭(带动画效果)
- (void)ImageReductionClose {

    [UIView animateWithDuration:0.4 animations:^{
        
        //背景图透明
        [FScrollView setBackgroundColor:[UIColor clearColor]];
        
        //还原缩放比例
        FScrollView.zoomScale = FProportionFloat;
        
        //还原图片初始框架
        CGRect ARect = FShowImageView.frame;
        
        ARect.origin.x = FImageOriginalRect.origin.x - FLevelFloat;
        
        ARect.origin.y = FImageOriginalRect.origin.y - FVerticalFloat;
        
        ARect.size.width = FImageOriginalRect.size.width;
        
        ARect.size.height = FImageOriginalRect.size.height;
        
        FShowImageView.frame = ARect;
        
        [UIView commitAnimations];

    } completion:^(BOOL finished) {
        
        [FShowImageView removeFromSuperview];
        
        FShowImageView = nil;
        
        [FScrollView removeFromSuperview];
        
        FScrollView = nil;
        
        [self removeFromSuperview];
    }];
}

/*
 *作用：放大图片
 *参数：
 *      ponint  双击点相对屏幕坐标
 */
- (void)enlargeImage:(CGPoint)ponint {

    [UIView animateWithDuration:0.4 animations:^{
        
        [FScrollView setZoomScale:FScrollView.maximumZoomScale];
    }];
    
    //相对边距坐标
    CGPoint APanNextPoint =  CGPointMake((ponint.x - FLevelFloat), (ponint.y - FVerticalFloat));
    
    //滚动视图真实偏移坐标
    CGPoint AOffsetPoint = FScrollView.contentOffset;
    
    if (FShowImageView.image.size.height * FProportionFloat * FScrollView.maximumZoomScale > self.frame.size.height)
    {
        CGFloat Y = APanNextPoint.y * FScrollView.zoomScale / FProportionFloat - FShowImageView.center.y;
        
        AOffsetPoint.y = AOffsetPoint.y + Y;
        
        CGFloat AMaxContentHeight= FScrollView.contentSize.height - CGRectGetHeight(FScrollView.frame);
        
        AOffsetPoint.y = AOffsetPoint.y < AMaxContentHeight ? AOffsetPoint.y : AMaxContentHeight;
        
        AOffsetPoint.y = AOffsetPoint.y > 0 ? AOffsetPoint.y : 0;
    }
    
    if (FShowImageView.image.size.width * FProportionFloat * FScrollView.maximumZoomScale > self.frame.size.width)
    {
        CGFloat X = (APanNextPoint.x * FScrollView.zoomScale / FProportionFloat - FShowImageView.center.x);
        
        AOffsetPoint.x = AOffsetPoint.x + X;
        
        CGFloat AMaxContentWidth= FScrollView.contentSize.width - CGRectGetWidth(FScrollView.frame);
        
        AOffsetPoint.x = AOffsetPoint.x < AMaxContentWidth ? AOffsetPoint.x : AMaxContentWidth;
        
        AOffsetPoint.x = AOffsetPoint.x > 0 ? AOffsetPoint.x : 0;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        [FScrollView setContentOffset:AOffsetPoint];
    }];
}

#pragma mark - UICollectionViewDelegate
//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return FShowImageView;
}

//缩放时调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    if (scrollView.zoomScale < FProportionFloat) {
        
        [FShowImageView setCenter:self.center];
        
        CGRect ARect = FShowImageView.frame;
        
        ARect.origin.x = ARect.origin.x - FLevelFloat;
        
        ARect.origin.y = ARect.origin.y - FVerticalFloat;
        
        FShowImageView.frame = ARect;
    }
    else if (scrollView.zoomScale == FProportionFloat) {
        
        [FShowImageView setCenter:self.center];
        
        CGRect ARect = FShowImageView.frame;
        
        ARect.origin.x = 0;
        
        ARect.origin.y = 0;
        
        FShowImageView.frame = ARect;
    }
    
    //初始化边距
    [self initMargin];
}


#pragma mark - 手势触发
//点击触发————单击还原关闭图片  双击放大缩小图片
- (void)Tap:(UITapGestureRecognizer *)sender {
    //单击----还原关闭大图
    if (sender.numberOfTapsRequired == 1) {
        
        [self ImageReductionClose];
    }
    
    //双击---放大或还原
    else if (sender.numberOfTapsRequired == 2)
    {
        if (FScrollView.zoomScale > FProportionFloat)  {
            [FScrollView setZoomScale:FProportionFloat animated:YES];
        }
        else {
            //双击坐标相对屏幕坐标
            CGPoint point = [sender locationInView:self];
            //放大图片
            [self enlargeImage:point];
        }
    }
}

@end
