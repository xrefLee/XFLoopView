//
//  XFCache.m
//  XFLoopView
//
//  Created by lxf on 16/6/23.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import "XFCache.h"

@interface XFCache ()

//@property (nonatomic, strong) NSString *customSavePath;


@end

#define kCustomSavePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:savePath]

static NSString *customSavePath;

@implementation XFCache

+ (void)saveInPlistWithObject:(NSDictionary *)dic{
    NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (!imageDic) {
        return;
    }
//    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    customSavePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:savePath];
    
    for (NSString *url in dic.allKeys) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:imageDic[url]];
        [imageDic setObject:data forKey:url];
    }
    
    [imageDic writeToFile:kCustomSavePath atomically:YES];
    
    
}


+ (BOOL)isContentImgUrl:(NSString *)url{
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:kCustomSavePath];
    if ([dic.allKeys containsObject:url]) {
        return YES;
    }else{
        return NO;
    }

}

+ (UIImage *)imageWithUrl:(NSString *)url{
    if ([self isContentImgUrl:url]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:kCustomSavePath];
        UIImage *image = [NSKeyedUnarchiver unarchiveObjectWithData:dic[url]];
        return image;
        
        
    }else{
        return nil;
    }
    
}




@end
