//
//  WaterMatchResultModel.h
//  Water
//
//  Created by Libo on 17/8/15.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kVpadding 5
#define kLRMargin 3
#define kFont [UIFont systemFontOfSize:15]
#define kCommonHeight 21

@interface WaterMatchResultModel : NSObject

@property (nonatomic, copy) NSString *dnCity;
@property (nonatomic, assign) NSInteger dnDoctorType;
@property (nonatomic, assign) NSInteger dnFollowStatus;
@property (nonatomic, assign) NSInteger dnHours;
@property (nonatomic, copy) NSString *dnIntroAudioUrl;
@property (nonatomic, assign) NSInteger dnIntroPointer;
@property (nonatomic, copy) NSString *dnIntroSentence;
@property (nonatomic, assign) NSInteger dnLevel;
@property (nonatomic, copy) NSString *dnLifePhoto;
@property (nonatomic, copy) NSString *dnLocation;
@property (nonatomic, copy) NSString *dnNickName;
@property (nonatomic, assign) NSInteger dnOnlineStatus;
@property (nonatomic, copy) NSString *dnRealName;
@property (nonatomic, copy) NSString *dnSkill;
@property (nonatomic, assign) NSInteger id;

// 辅助属性
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGFloat imageWidth;

// cell的宽度
@property (nonatomic, assign) CGFloat cellWidth;

// 提前计算好cell的高度
- (CGFloat)cellHeightWithCellWidth:(CGFloat)cellWidth;

@end
