//
//  YJShufflingCollectionViewCell.h
//  YJShufflingScrollView
//
//  Created by YJ on 2019/9/10.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

@interface YJShufflingCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (copy, nonatomic) NSString *title;
@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;
@property(nonatomic,assign)BOOL isShowtitleLabe;
/*
 图片都会在view里面显示，并且比例不变 这就是说 如果图片和view的比例不一样 就会有留白
 UIViewContentModeScaleAspectFit
 
 这是整个view会被图片填满，图片比例不变 图片显示就会大于view
 UIViewContentModeScaleAspectFill
 
 //图片拉伸填充至整个UIImageView(图片可能会变形),这也是默认的属性,如果什么都不设置就是它在起作用
 UIViewContentModeScaleToFill
 */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

@end
