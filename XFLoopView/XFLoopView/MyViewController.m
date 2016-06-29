//
//  MyViewController.m
//  轮播图片
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import "MyViewController.h"
#import "XFLoopPlayView.h"

@interface MyViewController ()

@property (nonatomic ,strong) XFLoopPlayView *loopPlayView;
@property (nonatomic ,strong) NSMutableArray *imageArr;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *urlArr = @[@"http://p1.qqyou.com/pic/UploadPic/2013-3/19/2013031923222781617.jpg",
                        @"http://cdn.duitang.com/uploads/item/201409/27/20140927192649_NxVKT.thumb.700_0.png",
                        @"http://img4.duitang.com/uploads/item/201409/27/20140927192458_GcRxV.jpeg",
                        @"http://cdn.duitang.com/uploads/item/201304/20/20130420192413_TeRRP.thumb.700_0.jpeg"];
    self.loopPlayView = [[XFLoopPlayView alloc]initWithFrame:CGRectMake(20, 100, 335, 200)];
    [self.view addSubview:self.loopPlayView];
    self.loopPlayView.imageArr = urlArr;
////    self.loopPlayView.imageArr = self.imageArr;
    self.loopPlayView.intervalTime = 2.0;
    [self.loopPlayView start];
    [self.loopPlayView tapAction:^(UIImage *image,NSString *urlStr) {
        NSLog(@"%@",image);
        NSLog(@"%@",urlStr);
        
    }];
    
    
}


- (NSMutableArray *)imageArr{
    
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];

        for (int i = 0; i < 4; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i + 1]];
            
            [_imageArr addObject:image];
            
        }
        
    }
    
    return _imageArr;
}








//- (NSArray *)imagesForLoopPlayInXFLoopPlayView{
//    NSLog(@"1");
//    return self.imageArr1;
//    
//}
//
//- (BOOL)isLoopPlay{
//    return YES;
//}
//

@end
