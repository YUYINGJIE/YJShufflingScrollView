//
//  YJShufflingScrollView.m
//  YJShufflingScrollView
//
//  Created by YJ on 2019/9/10.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "YJShufflingScrollView.h"
#import "YJShufflingCollectionViewCell.h"
#import "YJPageControl.h"
#import "YJShufflingFlowLayout.h"
#import <SDWebImage.h>
static NSString * const  ShufflingCellID = @"YJShufflingCollectionViewCell";

@interface YJShufflingScrollView ()<UICollectionViewDataSource,UICollectionViewDelegate>

/**定时器*/
@property(nonatomic,strong) dispatch_source_t dispatchTimer;
@property(nonatomic,strong) UICollectionView * collectionView;
@property(nonatomic,strong) UICollectionViewFlowLayout*flowLayout;
@property(nonatomic,strong) YJShufflingFlowLayout*CartoonflowLayout;
@property (nonatomic, strong) YJPageControl *pageControl;
@property(nonatomic,assign) NSInteger itemCount;
@property(nonatomic,strong) UIImage * placeholderImage;
@property(nonatomic,strong) NSArray<NSString*> * imagesStrings;
@property(nonatomic,assign) PagesStyle PagesStyle;
@end


@implementation YJShufflingScrollView


- (instancetype)initWithFrame:(CGRect)frame imagesStrs:(NSArray<NSString *>*)imagesStrs placeholderImage:(UIImage*)placeholderImage PagesStyle:(PagesStyle)PagesStyle;
{
    self = [super initWithFrame:frame];
    if (self) {
        _PagesStyle = PagesStyle;
        [self configdata];
        [self setupUI];
        self.imagesStrings = imagesStrs;
        self.placeholderImage = placeholderImage;
        self.backgroundColor = [UIColor redColor];
        [self YJ_openGCDTimerWithinterVal:_interVal];
        [self YJ_resumeTimer];
    }
    return self;
}

//默认值
-(void)configdata{
    if (_PagesStyle==PagesStyleComent) {
        _kitemSize = self.frame.size;
        _lineWidth = 0.0;
        _columnWidth =0.0;
        _bottomMargin = 10;
    }
    else{
        _kitemSize = CGSizeMake(k_YJWidth-80, (k_YJWidth - 80) * 9 / 16);
        _lineWidth = 10.0;
        _columnWidth=0.0;
        _bottomMargin = 20;
    }
   
    _PagescrollDirection = PagescrollDirectionHorizontal;
    _pageIndicatorTintColor = [UIColor whiteColor];
    _currentpageIndicatorTintColor = [UIColor greenColor];
    _margin = 5;
    _dotSize = CGSizeMake(8, 8);
    _interVal = 3;
    _currentPage = 0;
    _titleLabelTextAlignment = NSTextAlignmentLeft;
    _titleLabelTextColor = [UIColor whiteColor];
    _titleLabelTextFont= [UIFont systemFontOfSize:13];
    _titleLabelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _titleLabelHeight = 30;
    _isShowtitleLabe = NO;
    _bannerImageViewContentMode = UIViewContentModeScaleToFill;
    _pageControlAliment = PageContolAlimentCenter;
    _autoScroll = true;
    _loop=YES;
}

-(void)setupUI{
    
    [self addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self).mas_equalTo(0);
    }];
   
}

#pragma mark - UICollectionView delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemCount;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    YJShufflingCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:ShufflingCellID forIndexPath:indexPath];
    NSInteger item = (NSInteger)indexPath.item % self.imagesStrings.count;
    NSString *imagstr = self.imagesStrings[item];
    if (_titles.count!=0) {
        NSString *titlestr = _titles[item];
        cell.title =titlestr;
    }

    cell.bannerImageViewContentMode = _bannerImageViewContentMode;
    cell.isShowtitleLabe = _isShowtitleLabe;
    cell.titleLabelTextAlignment = _titleLabelTextAlignment;
    cell.titleLabelTextFont = _titleLabelTextFont;
    cell.titleLabelTextColor = _titleLabelTextColor;
    cell.titleLabelHeight = _titleLabelHeight;
    cell.titleLabelBackgroundColor = _titleLabelBackgroundColor;
    
    if ([imagstr hasPrefix:@"http"]) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagstr] placeholderImage:self.placeholderImage];
    } else {
        UIImage *image = [UIImage imageNamed:imagstr];
        if (!image) {
            image = [UIImage imageWithContentsOfFile:imagstr];
        }
        cell.imageView.image = image;
    }
    return cell;

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectItemBlock) {
        NSInteger item = (NSInteger)indexPath.item % self.imagesStrings.count;
        self.didSelectItemBlock(item);
    }
}

-(void)setImagesStrings:(NSArray<NSString *> *)imagesStrings{
    NSAssert(imagesStrings.count != 0, @"图片数组不可为空！");
    _imagesStrings = imagesStrings;
    _itemCount =imagesStrings.count*200;
    self.currentPage=0;
    [self.collectionView reloadData];
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).mas_equalTo(-_bottomMargin);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_offset(10);
        make.width.mas_offset(0);
    }];
}

-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    NSAssert(titles.count != 0, @"图片数组与标题数组数量必须一致且不可为空！");
    [self.collectionView reloadData];
    
}

- (NSInteger)getCurrentIndex
{
    if (_PagesStyle==PagesStyleComent) {
        int index = 0;
        if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            index = (self.collectionView.contentOffset.x + self.flowLayout.itemSize.width/2) / self.flowLayout.itemSize.width+_lineWidth;
        } else {
            index = (self.collectionView.contentOffset.y + self.flowLayout.itemSize.height/2) / self.flowLayout.itemSize.height;
        }
        return MAX(0, index);
    }
    else{
        int index = 0;
        index = (self.collectionView.contentOffset.x+self.CartoonflowLayout.itemSize.width/2) / (self.CartoonflowLayout.itemSize.width+10);
        
        return MAX(0, index);
    }
}

-(void)autoscrollToItem{
    if (_imagesStrings.count==0) return;
    NSInteger currentIndex = [self getCurrentIndex];
    NSInteger SelectIndex = currentIndex + 1;
    [self scrollToIndex:SelectIndex];
    
}

- (void)scrollToIndex:(NSInteger)targetIndex{
    
    if (targetIndex >= _itemCount) {
        
            targetIndex = 0;
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark -ScrollView代理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.imagesStrings.count==0) return;
    NSInteger itemIndex = [self getCurrentIndex];
    NSInteger item = itemIndex % self.imagesStrings.count;
    self.pageControl.currentPage =item;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self YJ_stopGCDTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self YJ_stopGCDTimer];
        [self YJ_openGCDTimerWithinterVal:_interVal];
        [self YJ_resumeTimer];
    }
}

#pragma mark lazy
-(UICollectionView*)collectionView{
    
    if (_collectionView==nil) {
        if (_PagesStyle ==PagesStyleComent) {
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
            _collectionView.pagingEnabled = YES;
        }
        else{
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.CartoonflowLayout];
            _collectionView.pagingEnabled = NO;
        }
        _collectionView.backgroundColor =[UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled=YES;
        _collectionView.scrollsToTop=NO;
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.showsHorizontalScrollIndicator=NO;
        [_collectionView registerClass:[YJShufflingCollectionViewCell class] forCellWithReuseIdentifier:ShufflingCellID];
    }
    return _collectionView;
}

-(UICollectionViewFlowLayout*)flowLayout{
    
    if (_flowLayout==nil) {
        self.flowLayout =[[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = _kitemSize;
        _flowLayout.minimumLineSpacing = _lineWidth;//行间距
        _flowLayout.minimumInteritemSpacing = _columnWidth;//列间距
        if (_PagescrollDirection==PagescrollDirectionHorizontal) {
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        }
        else{
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        }
    }
    return _flowLayout;
}

-(YJShufflingFlowLayout*)CartoonflowLayout{
    
    if (_CartoonflowLayout==nil) {
        _CartoonflowLayout =[[YJShufflingFlowLayout alloc] init];
        _CartoonflowLayout.itemSize = _kitemSize;
        _CartoonflowLayout.minimumLineSpacing = _lineWidth;//行间距
        _CartoonflowLayout.minimumInteritemSpacing = _columnWidth;
        _CartoonflowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
    }
    return _CartoonflowLayout;
}

-(YJPageControl *)pageControl{
    
    if (_pageControl==nil) {
        _pageControl=[[YJPageControl alloc]initWithFrame:CGRectZero];
        _pageControl.numberOfPages=self.imagesStrings.count;
        _pageControl.dotSize = _dotSize;
        _pageControl.margin = _margin;
        _pageControl.currentPage = _currentPage;
        _pageControl.pageControlAliment = _pageControlAliment;
        _pageControl.currentpageTintColor=_currentpageIndicatorTintColor;
        _pageControl.pageTintColor = _pageIndicatorTintColor;
        _pageControl.backgroundColor = [UIColor clearColor];
    }
    return _pageControl;
}

-(void)setPagescrollDirection:(PagescrollDirection)PagescrollDirection{
    _PagescrollDirection = PagescrollDirection;
    if (_PagesStyle==PagesStyleComent) {
        if (_PagescrollDirection==PagescrollDirectionHorizontal) {
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        }
        else{
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        }
    }
    else{
        _CartoonflowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    }
    
}
-(void)setKitemSize:(CGSize)kitemSize{
    _kitemSize =kitemSize;
    if (_PagesStyle==PagesStyleComent) {
        self.flowLayout.itemSize = kitemSize;
    }
    else{
        self.CartoonflowLayout.itemSize = kitemSize;

    }
}
-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    if (_PagesStyle==PagesStyleComent) {
        self.flowLayout.minimumLineSpacing = lineWidth;
    }
    else{
        self.CartoonflowLayout.minimumLineSpacing = lineWidth;
    }
}
-(void)setColumnWidth:(CGFloat)columnWidth{
    _columnWidth = columnWidth;
    if (_PagesStyle==PagesStyleComent) {
        self.flowLayout.minimumInteritemSpacing = columnWidth;
    }
    else{
        self.CartoonflowLayout.minimumInteritemSpacing = columnWidth;

    }
}
#pragma mark -pageControl相关配置
-(void)setCurrentIndicatorpageImage:(UIImage *)currentIndicatorpageImage{
    _currentIndicatorpageImage = currentIndicatorpageImage;
    self.pageControl.currentPageIndicatorTintColor = [UIColor clearColor]; self.pageControl.currentIndicatorpageImage=currentIndicatorpageImage;
}
-(void)setPageIndicatorImage:(UIImage *)pageIndicatorImage{
    _pageIndicatorImage = pageIndicatorImage;
    self.pageControl.pageIndicatorTintColor = [UIColor clearColor]; self.pageControl.pageIndicatorImage=pageIndicatorImage;

}

-(void)setCurrentpageIndicatorTintColor:(UIColor *)currentpageIndicatorTintColor{
    _currentpageIndicatorTintColor = currentpageIndicatorTintColor;
    self.pageControl.currentpageTintColor=currentpageIndicatorTintColor;

}
-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    _pageIndicatorTintColor = pageIndicatorTintColor;
   self.pageControl.pageTintColor=pageIndicatorTintColor;
}
-(void)setDotSize:(CGSize)dotSize{
    _dotSize = dotSize;
    self.pageControl.dotSize=dotSize;
    
}
-(void)setIsShowPageControl:(BOOL)isShowPageControl{
    self.pageControl.hidden = !isShowPageControl;
}

-(void)setPageControlAliment:(PageContolAliment)pageControlAliment{
    _pageControlAliment = pageControlAliment;
    self.pageControl.pageControlAliment =pageControlAliment;
}

-(void)setMargin:(CGFloat)margin{
    _margin = margin;
    self.pageControl.margin = _margin;
}

-(void)setBottomMargin:(CGFloat)bottomMargin{
    _bottomMargin = bottomMargin;
    [self.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).mas_offset(-bottomMargin);
    }];
}

-(void)setCurrentPage:(NSInteger)currentPage{
    
    if (currentPage>_imagesStrings.count) {
        currentPage =0;
    }
    _currentPage = currentPage;
    if (0 == _itemCount) return;
    NSInteger item = _loop? currentPage+self.imagesStrings.count*100:currentPage;
    [self layoutIfNeeded];
    [self scrollToIndex:item];
    
}

#pragma mark - 循环滚动相关配置
-(void)setLoop:(BOOL)loop{
    _loop = loop;
    self.imagesStrings = self.imagesStrings;
     _itemCount = loop ? self.imagesStrings.count * 200 : self.imagesStrings.count;
    [self.collectionView reloadData];
    if (loop) {
        [self YJ_stopGCDTimer];
        [self YJ_openGCDTimerWithinterVal:_interVal];
        [self YJ_resumeTimer];
    }
    else{
        [self YJ_stopGCDTimer];
    }
}

-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    [self YJ_stopGCDTimer];
    [self YJ_openGCDTimerWithinterVal:_interVal];
    [self YJ_resumeTimer];
}


-(void)setBannerImageViewContentMode:(UIViewContentMode)bannerImageViewContentMode{
    _bannerImageViewContentMode = bannerImageViewContentMode;
    [self layoutIfNeeded];
}
#pragma 标题相关配置
-(void)setIsShowtitleLabe:(BOOL)isShowtitleLabe{
    _isShowtitleLabe = isShowtitleLabe;
}
-(void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor{
    _titleLabelBackgroundColor =titleLabelBackgroundColor;
}
-(void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor{
    _titleLabelTextColor =titleLabelTextColor;
}
-(void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont{
    _titleLabelTextFont = titleLabelTextFont;
}
-(void)setTitleLabelHeight:(CGFloat)titleLabelHeight{
    _titleLabelHeight = titleLabelHeight;
}
-(void)setTitleLabelTextAlignment:(NSTextAlignment)titleLabelTextAlignment{
    _titleLabelTextAlignment = titleLabelTextAlignment;
}

#pragma mark - 定时器相关配置
-(void)setInterVal:(NSTimeInterval)interVal{
    _interVal = interVal;
    [self YJ_stopGCDTimer];
    [self YJ_openGCDTimerWithinterVal:_interVal];
    [self YJ_resumeTimer];
}
-(void)YJ_openGCDTimerWithinterVal:(NSTimeInterval)interVal{
    
     if (_autoScroll) {
        __weak typeof(self)weakself = self;
        _interVal = interVal;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _dispatchTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interVal * NSEC_PER_SEC));//等待执行时间
        uint64_t interval = (uint64_t)(interVal * NSEC_PER_SEC);//定时间隔时间
        dispatch_source_set_timer(_dispatchTimer, start, interval, 0); //每秒执行
        dispatch_source_set_event_handler(_dispatchTimer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself autoscrollToItem];
            });
        });
    }
  
}

-(void)YJ_pauseTimer{
    
    if(_dispatchTimer){
        dispatch_suspend(_dispatchTimer);
    }
}

-(void)YJ_resumeTimer{
    
    if(_dispatchTimer){
        dispatch_resume(_dispatchTimer);
    }
}

-(void)YJ_stopGCDTimer{
    
    if(_dispatchTimer){
        dispatch_source_cancel(_dispatchTimer);
        _dispatchTimer = nil;
    }
}

@end
