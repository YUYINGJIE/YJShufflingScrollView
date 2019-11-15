//
//  YJShufflingScrollView.h
//  YJShufflingScrollView
//
//  Created by YJ on 2019/9/10.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>


typedef enum {
    PageContolAlimentRight,
    PageContolAlimentLeft,
    PageContolAlimentCenter
} PageContolAliment;

typedef enum {
    PagescrollDirectionVertical,
    PagescrollDirectionHorizontal,
} PagescrollDirection;

typedef enum {
    PagesStyleComent,
    PagesStyleCartoon,
} PagesStyle;

@interface YJShufflingScrollView : UIView

- (instancetype)initWithFrame:(CGRect)frame imagesStrs:(NSArray<NSString *>*)imagesStrs placeholderImage:(UIImage*)placeholderImage PagesStyle:(PagesStyle)PagesStyle;
/**标题数组*/
@property(nonatomic,strong) NSArray *titles;
/**时间间隔*/
@property(nonatomic,assign) NSTimeInterval interVal;
/** 小圆标大小 */
@property (nonatomic) CGSize dotSize;
/** 默认小圆标颜色 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;
/** 当前小圆标颜色 */
@property (nonatomic, strong) UIColor *currentpageIndicatorTintColor;
/** 默认小圆标图片 */
@property (nonatomic, strong) UIImage *pageIndicatorImage;
/** 当前小圆标图片 */
@property (nonatomic, strong) UIImage *currentIndicatorpageImage;
/** 是否展示PageControl 默认true */
@property(nonatomic,assign)BOOL isShowPageControl;
/** 选中第几个 默认0*/
@property (nonatomic, assign)NSInteger currentPage;
/** 小圆标 间距 */
@property (nonatomic, assign) CGFloat margin;
/** PageControl距离下方的边距 */
@property (nonatomic, assign) CGFloat bottomMargin;
/** pageControl位置 左右中 */
@property (nonatomic, assign) PageContolAliment pageControlAliment;
/** 是否无限循环 */
@property(nonatomic,assign)BOOL loop;
/** 是否开启定时任务 */
@property(nonatomic,assign)BOOL autoScroll;
/** 图片渲染模式 */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;
/** 行间距 */
@property(nonatomic,assign) CGFloat lineWidth;
/** 列间距 */
@property(nonatomic,assign) CGFloat columnWidth;
/** cell大小 */
@property(nonatomic,assign) CGSize kitemSize;
/** 标题是否展示 */
@property(nonatomic,assign)BOOL isShowtitleLabe;
/** 标题字体颜色 */
@property (nonatomic, strong) UIColor *titleLabelTextColor;
/** 标题字体大小 */
@property (nonatomic, strong) UIFont *titleLabelTextFont;
/** 标题背景颜色 */
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
/** 标题高度 */
@property (nonatomic, assign) CGFloat titleLabelHeight;
/** 标题字体 左右中 */
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;
/** 滑动方向 */
@property (nonatomic, assign) PagescrollDirection PagescrollDirection;
/** 监听点击 */
@property (nonatomic, copy) void (^didSelectItemBlock)(NSInteger SelectIndex);
@end
