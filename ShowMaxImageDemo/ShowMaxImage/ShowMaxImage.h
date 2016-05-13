//
//  SeeMAxImage.h
//  Template
//
//  Created by 刘诚远 on 16/1/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMaxImage : UIView <UIScrollViewDelegate>

//获取单利
+(ShowMaxImage *)showMaxImage;

//设置显示图片
- (void)showImage:(UIImageView *)imageView;

@end
