//
//  XFCache.h
//  XFLoopView
//
//  Created by lxf on 16/6/23.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define savePath @"image.plist"

@interface XFCache : NSObject

+ (void)saveInPlistWithObject:(NSDictionary *)dic;

+ (BOOL)isContentImgUrl:(NSString *)url;

+ (UIImage *)imageWithUrl:(NSString *)url;

@end
