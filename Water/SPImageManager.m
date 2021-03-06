//
//  SPImageManager.m
//  Water
//
//  Created by Libo on 17/8/16.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import "SPImageManager.h"
#import "UIImageView+WebCache.h"

@implementation SPImageManager

+ (instancetype)shareImageManager {
    static SPImageManager *mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (mgr == nil) {
            mgr = [[SPImageManager alloc] init];
        }
    });
    return mgr;
}

- (CGSize)sizeWithUrlString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
#ifdef dispatch_main_sync_safe
    // 先从内存中取，如果取不到就去磁盘中取
    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:url.absoluteString]) {
        // imageFromMemoryCacheForKey:这个方法只会从内存中取
        UIImage* image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url.absoluteString];
        if(!image) {
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:url.absoluteString];
#pragma clang diagnostic pop
            
            image = [UIImage imageWithData:data];
        }
        if (image) {
            return image.size;
        }
    }
#endif
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString* pathExtendsion = [url.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    } else if([pathExtendsion isEqual:@"gif"]) {
        size =  [self getGIFImageSizeWithRequest:request];
    } else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    
    if(CGSizeEqualToSize(CGSizeZero, size)) {
        
        // 如果获取文件头信息失败,发送同步请求请求原图
        NSData* data = [self sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:nil error:nil];
        
        UIImage* image = [UIImage imageWithData:data];
        
        if(image) {
            
            // 如果未使用SDWebImage，则忽略；缓存该图片
#ifdef dispatch_main_sync_safe
            // 缓存
            [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:data forKey:url.absoluteString toDisk:YES];
#endif
        }
        return image.size;

    }
    return size;
}

- (CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request {
    
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    
    NSData* data = [self sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if(data.length == 8) {
        
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        
        return CGSizeMake(w, h);
        
    }
    
    return CGSizeZero;
    
}


- (CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request {
    
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    
    NSData* data = [self sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if(data.length == 4) {
        
        short w1 = 0, w2 = 0;
        
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        
        short w = w1 + (w2 << 8);
        
        short h1 = 0, h2 = 0;
        
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        
        short h = h1 + (h2 << 8);
        
        return CGSizeMake(w, h);
        
    }
    
    return CGSizeZero;
    
}


-(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request {
    
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    
    NSData* data = [self sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        
        return CGSizeZero;
        
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        
        short w1 = 0, w2 = 0;
        
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        
        short w = (w1 << 8) + w2;
        
        short h1 = 0, h2 = 0;
        
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        
        short h = (h1 << 8) + h2;
        
        return CGSizeMake(w, h);
        
    } else {
        
        short word = 0x0;
        
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        
        if (word == 0xdb) {
            
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            
            if (word == 0xdb) {// 两个DQT字段
                
                short w1 = 0, w2 = 0;
                
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                
                short w = (w1 << 8) + w2;
                
                short h1 = 0, h2 = 0;
                
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                
                short h = (h1 << 8) + h2;
                
                return CGSizeMake(w, h);
                
            } else {// 一个DQT字段
                
                short w1 = 0, w2 = 0;
                
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                
                short w = (w1 << 8) + w2;
                
                short h1 = 0, h2 = 0;
                
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                
                short h = (h1 << 8) + h2;
                
                return CGSizeMake(w, h);
                
            }
            
        } else {
            
            return CGSizeZero;
        }
        
    }
}

- (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse * _Nullable * _Nullable)response error:(NSError **)error  {
    
    __block NSData *myData;
    
    //创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        myData = data;
        
        //发送
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
        
    // 等待(阻塞线程)
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return myData;
    
}


@end
