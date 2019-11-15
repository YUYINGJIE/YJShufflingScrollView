//
//  ViewController.m
//  YJShufflingScrollView
//
//  Created by YJ on 2019/9/10.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "ViewController.h"
#import "YJShufflingScrollView.h"
#import "YJShufflingCollectionViewCell.h"
#import "YJShufflingFlowLayout.h"
#import <SDWebImage.h>

#define k_YJWidth [UIScreen mainScreen].bounds.size.width
#define k_YJHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@end

@implementation ViewController
static NSString * const  ShufflingCellID = @"YJShufflingCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"轮播banner";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *demoContainerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100)];
    demoContainerView.contentSize = CGSizeMake(self.view.frame.size.width, 1200);
    [self.view addSubview:demoContainerView];
    
   __block NSArray *arrr = @[@"h1.jpg",
                            @"h2.jpg",
                            @"h3.jpg",
                            @"h4.jpg",
                            ];
    YJShufflingScrollView * ShufflingScrollView =[[YJShufflingScrollView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 200) imagesStrs:arrr placeholderImage:[UIImage imageNamed:@"placeholder"]PagesStyle:PagesStyleCartoon];
    ShufflingScrollView.currentPage = 1;
    ShufflingScrollView.didSelectItemBlock = ^(NSInteger SelectIndex) {
        NSLog(@"------%zd",SelectIndex);
    };
    
    [demoContainerView addSubview:ShufflingScrollView];
    
  __block NSArray *arrr2 = @[
                                  @"https://seopic.699pic.com/photo/50142/0987.jpg_wh1200.jpg",
                                  @"https://seopic.699pic.com/photo/50142/0973.jpg_wh1200.jpg",
                                  @"https://seopic.699pic.com/photo/50140/7669.jpg_wh1200.jpg"
                                  ];
    
    YJShufflingScrollView * ShufflingScrollView2 =[[YJShufflingScrollView alloc]initWithFrame:CGRectMake(0, 220,self.view.frame.size.width, 200) imagesStrs:arrr2 placeholderImage:[UIImage imageNamed:@"placeholder"]PagesStyle:PagesStyleComent];
    ShufflingScrollView2.autoScroll=YES;
    ShufflingScrollView2.loop = YES;
    [demoContainerView addSubview:ShufflingScrollView2];
    
    ShufflingScrollView2.didSelectItemBlock = ^(NSInteger SelectIndex) {
        NSLog(@"---%@-%@-",@(SelectIndex),arrr2[SelectIndex]);
    };
    
    YJShufflingScrollView * ShufflingScrollView3 =[[YJShufflingScrollView alloc]initWithFrame:CGRectMake(0, 440,self.view.frame.size.width, 200) imagesStrs:arrr placeholderImage:[UIImage imageNamed:@"placeholder"]PagesStyle:PagesStyleComent];
    ShufflingScrollView3.PagescrollDirection = PagescrollDirectionVertical;
    ShufflingScrollView3.autoScroll=YES;
    ShufflingScrollView3.loop = YES;
    ShufflingScrollView3.isShowPageControl = NO;
    [demoContainerView addSubview:ShufflingScrollView3];
    ShufflingScrollView3.didSelectItemBlock = ^(NSInteger SelectIndex) {
        NSLog(@"---%@-%@-",@(SelectIndex),arrr[SelectIndex]);
    };
    
    YJShufflingScrollView * ShufflingScrollView4 =[[YJShufflingScrollView alloc]initWithFrame:CGRectMake(0, 680,self.view.frame.size.width, 200) imagesStrs:arrr placeholderImage:[UIImage imageNamed:@"placeholder"]PagesStyle:PagesStyleComent];
    ShufflingScrollView4.PagescrollDirection = PagescrollDirectionHorizontal;
    ShufflingScrollView4.autoScroll=YES;
    ShufflingScrollView4.loop = YES;
    ShufflingScrollView4.isShowPageControl = NO;
    ShufflingScrollView4.isShowtitleLabe =YES;
    [demoContainerView addSubview:ShufflingScrollView4];
    ShufflingScrollView4.titles = arrr;
    ShufflingScrollView4.titleLabelTextFont = [UIFont systemFontOfSize:15];
    ShufflingScrollView4.didSelectItemBlock = ^(NSInteger SelectIndex) {
        NSLog(@"---%@-%@-",@(SelectIndex),arrr[SelectIndex]);
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
