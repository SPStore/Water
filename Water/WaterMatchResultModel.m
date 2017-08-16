//
//  WaterMatchResultModel.m
//  Water
//
//  Created by Libo on 17/8/15.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import "WaterMatchResultModel.h"

@implementation WaterMatchResultModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (CGFloat)cellHeightWithCellWidth:(CGFloat)cellWidth {
    
    CGFloat textHeight = [self.dnIntroSentence boundingRectWithSize:CGSizeMake(cellWidth-2*kLRMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFont} context:nil].size.height;
    
    CGFloat cellHeight;
    
    if (!_imageWidth) {
        cellHeight = 150+textHeight+3*kVpadding+kCommonHeight;
    } else {
        cellHeight = _imageHeight*cellWidth/_imageWidth+textHeight+3*kVpadding+kCommonHeight;
    }

    return cellHeight;
}

@end
