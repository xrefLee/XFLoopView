//
//  XFLoopPlayView.h
//  轮播图片
//
//  Created by lxf on 16/1/16.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  暂未使用
 */
@protocol XFLoopPlayViewDelegate <NSObject>

- (NSArray *)imagesForLoopPlayInXFLoopPlayView;
- (BOOL) isLoopPlay;

@end

typedef void(^actionBlock)(UIImage *image,NSString *urlStr);

@interface XFLoopPlayView : UIView
/**
 *  暂未使用
 */
@property (nonatomic ,assign) id<XFLoopPlayViewDelegate> delegate;
/**
 *  需要滚动的images
 */
@property (nonatomic ,strong) NSArray<UIImage *> *imageArr;
/**
 *  需要滚动的images 的 url
 */
@property (nonatomic, strong) NSArray<NSString *> *imageUrlArr;
/**
 *  滚动间隔时间
 */
@property (nonatomic ,assign) CGFloat intervalTime;
/**
 *  开始循环播放调用该方法
 */
- (void)start;
/**
 *  tap Action
 */
- (void)tapAction:(actionBlock)action;


@end
