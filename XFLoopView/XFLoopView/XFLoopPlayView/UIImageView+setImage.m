//
//  UIImageView+setImage.m
//  XFLoopView
//
//  Created by lxf on 16/6/27.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import "UIImageView+setImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIImageView (setImage)
const void *key1 = "myImage";

- (void)setMyImage:(id)myImage{
    if ([myImage isKindOfClass:[UIImage class]]) {
        self.image = myImage;
    }else if([myImage isKindOfClass:[NSString class]]){
        
        [self sd_setImageWithURL:[NSURL URLWithString:myImage] placeholderImage:nil];
    }else if ([myImage isKindOfClass:[NSURL class]]){
        [self sd_setImageWithURL:myImage placeholderImage:nil];
    }
    
    objc_setAssociatedObject(self, key1, myImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (id)myImage{
    return objc_getAssociatedObject(self, key1);
}

@end
