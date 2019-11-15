//
//  YJShufflingCollectionViewCell.m
//  YJShufflingScrollView
//
//  Created by YJ on 2019/9/10.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "YJShufflingCollectionViewCell.h"


@interface YJShufflingCollectionViewCell ()


@end

@implementation YJShufflingCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self layout];
    }
    return self;
}

-(void)layout{
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.bottom.equalTo(self.contentView).mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.equalTo(self.contentView).mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

-(void)setTitleLabelTextAlignment:(NSTextAlignment)titleLabelTextAlignment
{
    _titleLabelTextAlignment = titleLabelTextAlignment;
    _titleLabel.textAlignment = titleLabelTextAlignment;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = [NSString stringWithFormat:@" %@",title];
   
}
-(void)setIsShowtitleLabe:(BOOL)isShowtitleLabe{
    _isShowtitleLabe = isShowtitleLabe;
    _titleLabel.hidden =!isShowtitleLabe;
}
-(void)setTitleLabelHeight:(CGFloat)titleLabelHeight{
    _titleLabelHeight = titleLabelHeight;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(titleLabelHeight);
    }];
}
-(void)setBannerImageViewContentMode:(UIViewContentMode)bannerImageViewContentMode{
    _bannerImageViewContentMode = bannerImageViewContentMode;
    _imageView.contentMode = bannerImageViewContentMode;
}
-(UIImageView*)imageView{
    if (_imageView ==nil) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _imageView;
}

-(UILabel*)titleLabel{
    
    if (_titleLabel ==nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}
@end
