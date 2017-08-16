//
//  WaterflowLayout.h
//  Water
//
//  Created by Libo on 17/8/15.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterflowLayout;

@protocol WaterflowLayoutDelegate <NSObject>
@required
- (CGFloat)waterflowLayout:(WaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(WaterflowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(WaterflowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(WaterflowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterflowLayout *)waterflowLayout;
@end

@interface WaterflowLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic, weak) id<WaterflowLayoutDelegate> delegate;
@end
