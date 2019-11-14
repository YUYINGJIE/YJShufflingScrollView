//
//  YJPageControl.m
//  YJShufflingScrollView
//
//  Created by 于英杰 on 2019/11/12.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "YJPageControl.h"



@implementation YJPageControl

//重写方法 修改间距

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //计算圆点间距
    CGFloat marginX = _margin + self.dotSize.width;
    //计算整个pageControll的宽度
    CGFloat newW = (self.subviews.count) * marginX-_margin;
    //设置新frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);
    if (_pageControlAliment == PageContolAlimentRight) {
        self.frame = CGRectMake(k_YJWidth-newW-_margin*2, self.frame.origin.y, newW, self.frame.size.height);
    }
    else if(_pageControlAliment==PageContolAlimentLeft){
        self.frame = CGRectMake(_margin*2, self.frame.origin.y, newW, self.frame.size.height);
    }
    else{
        //设置居中
        CGPoint center = self.center;
        center.x = self.superview.center.x;
        self.center = center;
    }
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, self.dotSize.width, self.dotSize.height)];
    }
}

//重写方法 改变点点的大小
- (void)setCurrentPage:(NSInteger)page {
    
    [super setCurrentPage:page];
    
    for (NSUInteger i =0; i < [self.subviews count]; i++) {
        UIView* dot = [self.subviews objectAtIndex:i];
         [dot setFrame:CGRectMake((_margin+self.dotSize.width)*i, dot.frame.origin.y,self.dotSize.width, self.dotSize.height)];
        dot.layer.cornerRadius =self.dotSize.height/2;
        dot.clipsToBounds = YES;
        if ([dot.subviews count] == 0) {
            UIImageView * view = [[UIImageView alloc]initWithFrame:dot.bounds];
            [dot addSubview:view];
        };
        UIImageView *imageView = dot.subviews[0];
        if (i == page) {
            if (_currentIndicatorpageImage) {
                imageView.image = _currentIndicatorpageImage;
            }
            else{
                imageView.backgroundColor = _currentpageTintColor;
            }
        }
        else {
            if (_pageIndicatorImage) {
                imageView.image = _pageIndicatorImage;
            }
            else{
                imageView.backgroundColor = _pageTintColor;
            }
        }
    }
}

-(void)setPageTintColor:(UIColor *)pageTintColor{
    _pageTintColor = pageTintColor;
}

-(void)setCurrentpageTintColor:(UIColor *)currentpageTintColor{
    _currentpageTintColor = currentpageTintColor;
}
-(void)setPageIndicatorImage:(UIImage *)pageIndicatorImage{
    _pageIndicatorImage = pageIndicatorImage;
    
}
-(void)setCurrentIndicatorpageImage:(UIImage *)currentIndicatorpageImage{
    _currentIndicatorpageImage = currentIndicatorpageImage;
}
-(void)setMargin:(CGFloat)margin{
    _margin = margin;
}
-(void)setPageControlAliment:(PageContolAliment)pageControlAliment{
    _pageControlAliment = pageControlAliment;
    
}
@end


