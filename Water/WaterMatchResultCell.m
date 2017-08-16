//
//  WaterMatchResultCell.m
//  Water
//
//  Created by Libo on 17/8/15.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import "WaterMatchResultCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface WaterMatchResultCell()

// 医生的头像
@property (nonatomic, strong) UIImageView *doctorHeaderIconView;
// 头像底部的一个带阴影效果背景图
@property (nonatomic, strong) UIImageView *bottomShadowImageView;
// 医生的名字
@property (nonatomic, strong) UILabel *doctorNameLabel;
// 喜欢的小图标，”心形“
@property (nonatomic, strong) UIButton *likeIconView;
// 喜欢的数量Label
@property (nonatomic, strong) UILabel *likeCountLabel;
// 医生的个性签名Label
@property (nonatomic, strong) UILabel *descLabel;
// 地图小图标
@property (nonatomic, strong) UIImageView *mapIconView;
// 地址＋距离Label
@property (nonatomic, strong) UILabel *addressLabel;
// 时间小图标
@property (nonatomic, strong) UIImageView *timeIconView;
// 时间Label
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation WaterMatchResultCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.doctorHeaderIconView];
        [self.contentView addSubview:self.bottomShadowImageView];
        [self.contentView addSubview:self.doctorNameLabel];
        [self.contentView addSubview:self.likeIconView];
        [self.contentView addSubview:self.likeCountLabel];
        [self.contentView addSubview:self.descLabel];
        [self.contentView addSubview:self.mapIconView];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.timeIconView];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)setModel:(WaterMatchResultModel *)model {
    _model = model;
    
    [self.doctorHeaderIconView sd_setImageWithURL:[NSURL URLWithString:model.dnLifePhoto] placeholderImage:nil];
    
    self.doctorNameLabel.text = model.dnRealName;
    [self.likeIconView setImage:[UIImage imageNamed:@"icon_heart_normal"] forState:UIControlStateNormal];
    self.likeCountLabel.text = @"123k";
    self.descLabel.text = model.dnIntroSentence;
    self.mapIconView.image = [UIImage imageNamed:@"icon_location"];
    self.addressLabel.text = model.dnLocation;
    self.timeIconView.image = [UIImage imageNamed:@"icon_clock"];
    self.timeLabel.text = [NSString stringWithFormat:@"%zd",model.dnHours];
    
    [self setNeedsUpdateConstraints];

}

- (void)updateConstraints {
    
    // 这里用remake
    [self.doctorHeaderIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        // 防止图片的大小为0，如果图片的大小是0，则给一个固定高度150
        if (self.model.imageWidth) {
            make.height.mas_equalTo(self.model.imageHeight*self.model.cellWidth/self.model.imageWidth);
        } else {
            make.height.mas_equalTo(150);
        }
    }];
    
    [self.doctorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.doctorHeaderIconView).offset(kLRMargin);
        make.bottom.mas_equalTo(self.doctorHeaderIconView);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(kCommonHeight);
    }];
    
    [self.likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.doctorHeaderIconView);
        make.right.mas_equalTo(self.doctorHeaderIconView).offset(-kLRMargin);
        make.height.mas_equalTo(kCommonHeight);
    }];
    
    [self.likeIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.likeCountLabel.mas_left).offset(-kLRMargin);
        make.centerY.mas_equalTo(self.likeCountLabel);
        make.width.height.mas_equalTo(15);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.doctorHeaderIconView.mas_bottom).offset(kVpadding);
        make.left.mas_equalTo(kLRMargin);
        make.right.mas_equalTo(-kLRMargin);
        
    }];
    
    [self.mapIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(kVpadding);
        make.width.height.mas_equalTo(kCommonHeight);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mapIconView.mas_right).offset(kLRMargin);
        make.bottom.top.mas_equalTo(self.mapIconView);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kLRMargin);
        make.top.bottom.mas_equalTo(self.addressLabel);
        
    }];
    
    [self.timeIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.timeLabel);
        make.right.mas_equalTo(self.timeLabel.mas_left).offset(-kLRMargin);
        make.width.height.mas_equalTo(kCommonHeight);
    }];
    
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (UIImageView *)doctorHeaderIconView {
    
    if (!_doctorHeaderIconView) {
        _doctorHeaderIconView = [[UIImageView alloc] init];
        
    }
    return _doctorHeaderIconView;
}

- (UIImageView *)bottomShadowImageView {
    
    if (!_bottomShadowImageView) {
        _bottomShadowImageView = [[UIImageView alloc] init];
        
    }
    return _doctorHeaderIconView;
}

- (UILabel *)doctorNameLabel {
    
    if (!_doctorNameLabel) {
        _doctorNameLabel = [[UILabel alloc] init];
        _doctorNameLabel.textColor = [UIColor whiteColor];
        _doctorNameLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _doctorNameLabel;
}


- (UIButton *)likeIconView {
    
    if (!_likeIconView) {
        _likeIconView = [[UIButton alloc] init];
        
    }
    return _likeIconView;
}


- (UILabel *)likeCountLabel {
    
    if (!_likeCountLabel) {
        _likeCountLabel = [[UILabel alloc] init];
        [_likeCountLabel setContentCompressionResistancePriority:1000.f forAxis:UILayoutConstraintAxisHorizontal];
        _likeCountLabel.textColor = [UIColor whiteColor];
        _likeCountLabel.font = [UIFont systemFontOfSize:14];
    }
    return _likeCountLabel;
}

- (UILabel *)descLabel {
    
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        // 抗压缩
        [_timeLabel setContentCompressionResistancePriority:1000.f forAxis:UILayoutConstraintAxisVertical];
        _descLabel.numberOfLines = 0;
        _descLabel.font = [UIFont systemFontOfSize:15];

    }
    return _descLabel;
}

- (UIImageView *)mapIconView {
    
    if (!_mapIconView) {
        _mapIconView = [[UIImageView alloc] init];
        
    }
    return _mapIconView;
}

- (UILabel *)addressLabel {
    
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:13];
        [_addressLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
        
    }
    return _addressLabel;
}

- (UIImageView *)timeIconView {
    
    if (!_timeIconView) {
        _timeIconView = [[UIImageView alloc] init];
        
    }
    return _timeIconView;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        // 设置抗压缩优先级,优先级越高越不容易被压缩,默认的优先级是750
        [_timeLabel setContentCompressionResistancePriority:1000.f forAxis:UILayoutConstraintAxisHorizontal];
        [_timeLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
        _timeLabel.font = [UIFont systemFontOfSize:13];

    }
    return _timeLabel;
}


@end
