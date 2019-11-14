//
//  YJPageControl.h
//  YJShufflingScrollView
//
//  Created by 于英杰 on 2019/11/12.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJShufflingScrollView.h"
#define k_YJWidth [UIScreen mainScreen].bounds.size.width
#define k_YJHeight [UIScreen mainScreen].bounds.size.height
@interface YJPageControl : UIPageControl

/** 默认小圆标颜色 */
@property (nonatomic, strong) UIColor *pageTintColor;
/** 当前小圆标颜色 */
@property (nonatomic, strong) UIColor *currentpageTintColor;
/** 小圆标大小 */
@property (nonatomic) CGSize dotSize;
/** 小圆标图片 */
@property (nonatomic, strong) UIImage *pageIndicatorImage;
/** 当前小圆标图片 */
@property (nonatomic, strong) UIImage *currentIndicatorpageImage;
/** 小圆标 间距 */
@property (nonatomic, assign) CGFloat margin;
/** pageControl位置 左右中 */
@property (nonatomic, assign) PageContolAliment pageControlAliment;

@end


