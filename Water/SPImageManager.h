//
//  SPImageManager.h
//  Water
//
//  Created by Libo on 17/8/16.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPImageManager : NSObject

+ (instancetype)shareImageManager;

// 根据url获取网络图片的大小
- (CGSize)sizeWithUrlString:(NSString *)urlString;

@end
