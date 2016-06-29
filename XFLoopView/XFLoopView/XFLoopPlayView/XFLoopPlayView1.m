//
//  XFLoopPlayView.m
//  轮播图片
//
//  Created by lxf on 16/1/16.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import "XFLoopPlayView1.h"
#import "XFCache.h"
#import "UIImageView+setImage.h"

#define kWidth self.bounds.size.width
#define kHeight self.bounds.size.height
#define kValue arc4random_uniform(256)/255.0
#define kImageCount self.imageArr.count
#define kIntervalTime 2.0f

@interface XFLoopPlayView1 ()<UIScrollViewDelegate>
@property (nonatomic,assign) NSInteger index;
@property (nonatomic ,strong) NSTimer *timer;
/**
 *  是否循环播放
 */
@property (nonatomic ,assign) BOOL isLoopPlay;
// 是否正在下载
@property (nonatomic, assign) BOOL isDownLoad;

// 布局界面需要的 view
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic ,strong) UIImageView *leftImageView;
@property (nonatomic ,strong) UIImageView *centerImageView;
@property (nonatomic ,strong) UIImageView *rightImageView;

// tmp block
@property (nonatomic, strong) actionBlock block;

// failUrl
@property (nonatomic, strong) NSMutableSet *failUrl;
/**
 *  当外界传进来的是 url 的时候  此 imageAndUrlDic 用于存放 url 和对应的 image
 */
@property (nonatomic, strong) NSMutableDictionary *imageAndUrlDic;

@end

@implementation XFLoopPlayView1

@synthesize intervalTime = _intervalTime;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        
    }
    return self;
}

- (void)setUpView{
    
    
    // 生成并设置scollview
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.contentSize = CGSizeMake(3*kWidth, 0);
    self.scrollView.contentOffset = CGPointMake(kWidth, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    // 生成3个imageView 供循环播放用
    self.leftImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight)];
    self.centerImageView.backgroundColor = [UIColor orangeColor];
    
    self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*2, 0, kWidth, kHeight)];
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.centerImageView];
    [self.scrollView addSubview:self.rightImageView];

    
    // 默认播放间隔时间为1s
    self.intervalTime = kIntervalTime;
    self.index = 0;
    // 默认不循环播放
    self.isLoopPlay = NO;
    self.isDownLoad = NO;

}

- (void)createPageControl{
    self.leftImageView.image = self.imageArr[kImageCount - 1];
    self.centerImageView.image = self.imageArr[0];
    self.rightImageView.image = self.imageArr[1];
    if (!self.pageControl) {
        [self.pageControl removeFromSuperview];
    }
    // 生成并设置pageControl
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(kWidth/2 ,kHeight - 30, kWidth/2 - 10, 20)];
    
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.alpha = 0.7;
    self.pageControl.userInteractionEnabled = NO;
    
    [self addSubview:self.pageControl];
    self.pageControl.numberOfPages = _imageArr.count;
    
    

}

// 开始滚动
- (void)start{
    self.isLoopPlay = YES;

    [self timer];
    
}

/**
 *  tap Action
 */
- (void)tapAction:(actionBlock)action{
    self.block = action;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myTapAction:)];
    self.centerImageView.userInteractionEnabled = YES;
    [self.centerImageView addGestureRecognizer:tap];
    
    
}

- (void)myTapAction:(UITapGestureRecognizer *)tap{
    if (!self.imageUrlArr) {
        self.block(self.centerImageView.image,nil);
    }else{
//        NSString *imageStr = [NSString stringWithFormat:@"%@",self.centerImageView.image];
        
        for (NSString *url in self.imageAndUrlDic.allKeys) {
            if (self.centerImageView.image == self.imageAndUrlDic[url]) {
                self.block(nil,url);
                return;
            }
        }
        
        
    }
    
    
}

#pragma mark ---------------- UIScrollViewDelegate --------------------

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateScrollWithIndex:1];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.isLoopPlay) {
        [self.timer invalidate];
        
        self.timer = nil;
    }

}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if(self.isLoopPlay){
       [self timer];
    }

    
}

#pragma mark ---------------- 懒加载 --------------------

// imageArr
- (void)setImageArr:(NSArray *)imageArr{
    if (_imageArr != imageArr) {
        _imageArr = [NSArray arrayWithArray:imageArr];
        if (self.imageUrlArr.count > 0) {
            if (_imageArr.count != self.imageUrlArr.count) {
                return;
            }
        }
       
        [self createPageControl];
    }

}

// imageUrlArr
- (void)setImageUrlArr:(NSArray *)imageUrlArr{
    if (!_imageUrlArr) {
        _imageUrlArr = [NSArray arrayWithArray:imageUrlArr];
        if (_imageUrlArr.count > 0) {
            [self requestImageWithUrl:_imageUrlArr];
        }
    }

}

// failUrl
- (NSMutableSet *)failUrl{
    if (!_failUrl) {
        _failUrl = [NSMutableSet set];
    }
    return _failUrl;
}

// imageAndUrlDic
- (NSMutableDictionary *)imageAndUrlDic{
    if (!_imageAndUrlDic) {
        _imageAndUrlDic = [NSMutableDictionary dictionary];
    }
    return _imageAndUrlDic;
}

#pragma mark -  网络请求图片
- (NSArray *)requestImageWithUrl:(NSArray *)urlArr{
    self.isDownLoad = YES;
    dispatch_group_t downLoadGroup = dispatch_group_create();
    
    
   __block NSMutableArray *arr = [NSMutableArray array];
    for (NSString *urlStr in urlArr) {
        NSURL *url ;
        if ([urlStr isKindOfClass:NSString.class]) {
            url = [NSURL URLWithString:(NSString *)urlStr];
        }
        
        if (![url isKindOfClass:NSURL.class]) {
            [self.failUrl addObject:url];
            url = nil;
        }
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@",url];
        if ([XFCache isContentImgUrl:urlStr]) {
            UIImage *image =[XFCache imageWithUrl:urlStr];
            [self.imageAndUrlDic setObject:image forKey:[NSString stringWithFormat:@"%@",url]];
            [arr addObject:image];
            continue;
        }
        
        
        dispatch_group_async(downLoadGroup, dispatch_get_global_queue(0, 0), ^{
            NSError *error;
            NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
            UIImage *image = [UIImage imageWithData:data];
            if (!error) {
                if (image) {
                    [self.imageAndUrlDic setObject:image forKey:[NSString stringWithFormat:@"%@",url]];
                    [arr addObject:image];

                }
            }else{
                [self.failUrl addObject:url];
                NSLog(@"%@---->failUrl%@",error,self.failUrl);
            }

            /*
            NSURLSessionDataTask *tast = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        [self.imageAndUrlDic setObject:[NSString stringWithFormat:@"%@",url] forKey:[NSString stringWithFormat:@"%@",image]];
                        [arr addObject:image];
//                        if (arr.count == self.imageUrlArr.count) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                self.imageArr = arr;
//                            });
//                        }
                    }else{
                        [self.failUrl addObject:url];
                        NSLog(@"%@---->failUrl%@",error,self.failUrl);
                    }
                    
                }else{
                    [self.failUrl addObject:url];
                    NSLog(@"%@---->failUrl%@",error,self.failUrl);
                }
                
                
            }];
            
            [tast resume];
            */
        });
    }
    dispatch_group_notify(downLoadGroup, dispatch_get_main_queue(), ^{
        NSLog(@"%ld",arr.count);
        self.imageArr = arr;
        self.isDownLoad = NO;
        [XFCache saveInPlistWithObject:self.imageAndUrlDic];
    });
    return arr;
}

// 定时器
- (NSTimer *)timer{
    if (!_timer && self.isLoopPlay) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.intervalTime target:self selector:@selector(startLoopPlay) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark ---------------- 视图滚动实现 --------------------

- (void)startLoopPlay{
    if (self.isDownLoad) {
        return;
    }
    if (self.imageArr.count < 3) {
        return;
    }
    [self updateScrollWithIndex:-1];
}

- (void)updateScrollWithIndex:(NSInteger)idx{
    if (idx == -1) {
        [UIView animateWithDuration:0.5f animations:^{
            self.scrollView.contentOffset = CGPointMake(2 * kWidth, 0);
            if (self.scrollView.contentOffset.x > 1.5 * kWidth) {
                self.pageControl.currentPage = (self.pageControl.currentPage + 1)%self.pageControl.numberOfPages;
            }
            
        }];
        
//        [self.scrollView setContentOffset:CGPointMake(2 * kWidth, 0) animated:YES];
        
        
        
        self.leftImageView.image = self.imageArr[self.index % kImageCount];
        self.centerImageView.image = self.imageArr[(self.index + 1) % kImageCount];
        self.rightImageView.image = self.imageArr[(self.index + 2) % kImageCount];
        
     
        self.index = (self.index + 1) % kImageCount;
        
        self.scrollView.contentOffset = CGPointMake(kWidth, 0);
        
        self.pageControl.currentPage = self.index;
        
    }
    
    if (idx != -1) {
        CGFloat offx = self.scrollView.contentOffset.x;
        if (offx  > kWidth) {
            
            self.leftImageView.image = self.imageArr[self.index % kImageCount];
            self.centerImageView.image = self.imageArr[(self.index + 1) % kImageCount];
            self.rightImageView.image = self.imageArr[(self.index + 2) % kImageCount];
            self.index = (self.index + 1) % kImageCount;
        }
        if (offx < kWidth) {
            self.leftImageView.image = self.imageArr[(self.index + kImageCount - 2) % kImageCount];
            self.centerImageView.image = self.imageArr[(self.index + kImageCount - 1) % kImageCount];
            self.rightImageView.image = self.imageArr[self.index];
            
            self.index = (self.index + kImageCount - 1) % kImageCount;
            
        }
        
        self.scrollView.contentOffset = CGPointMake(kWidth, 0);
        
        self.pageControl.currentPage = self.index;
    }
}







@end
