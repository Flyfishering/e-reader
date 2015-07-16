//
//  SCSBookViewController.m
//  e-reader
//
//  Created by 张鹏 on 15/7/7.
//  Copyright © 2015年 smallCobblerStudio. All rights reserved.
//

#import "SCSBookViewController.h"

@interface SCSBookViewController ()

@property(nonatomic,strong) UITextView *bookView;
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,assign) NSInteger allPage;
@property(nonatomic,assign) double offsetY;


@end

@implementation SCSBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bookView.editable = NO;
    self.bookView.userInteractionEnabled = NO;
    
    self.fontSize = 18;
    
    
    [self loadTXT];
    
    [self addGestureRecognizer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加载TXT文件
- (void)loadTXT {
    
    self.bookName = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zuishuxidemoshengren" ofType:@"txt"]   encoding:NSUTF8StringEncoding error:nil ];
    
    self.bookView.text = self.bookName;
    
    self.bookView.font = [UIFont systemFontOfSize:self.fontSize];
    
    self.allPage = [self allPageWithTXT];

}


//由于ios7以上UItextView自动计算contentOffset的height有问题,故手动进行计算返回TXT所有页数.
- (NSInteger)allPageWithTXT {
    
    //UITextView的实际高度
    NSInteger newSizeH;
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 7.0 ) {
        
        float fPadding = 0.0; // 0.0px x 2
        
        CGSize constraint = CGSizeMake(self.bookView.contentSize.width - fPadding, CGFLOAT_MAX);
        
        CGSize size = [self.bookView.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]} context:nil].size;
        
        newSizeH = size.height + fPadding;
        
    } else {
        
        newSizeH = self.bookView.contentSize.height;
    }

    return newSizeH / [UIScreen mainScreen].bounds.size.height;
   
}


//添加手势操作
- (void)addGestureRecognizer {
    
    UISwipeGestureRecognizer *rightPageGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(turnToNewPage:)];
    
    rightPageGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *leftPageGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(turnToNewPage:)];
    
    leftPageGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:rightPageGesture];
    
    [self.view addGestureRecognizer:leftPageGesture];
    
}

//左右滑动翻页
- (void)turnToNewPage:(UISwipeGestureRecognizer *)swipGesture {
    
    //左滑
    if (swipGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        [self leftPage];
       
    //右滑
    } else if (swipGesture.direction == UISwipeGestureRecognizerDirectionRight) {
        
        [self rightPage];

    }
   
}

//左翻页
- (void)leftPage {
    
    if (self.currentPage == self.allPage) {
        return;
    }
    
    self.offsetY = self.bookView.contentOffset.y;
    
    self.currentPage++;
    
    self.bookView.contentOffset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height * self.currentPage);
    
    if (self.bookView.contentOffset.y == self.offsetY) {
        
        self.currentPage--;
    }
    
}

//右翻页
- (void)rightPage {
    
    if (self.currentPage == 0) {
        return;
    }
    
    self.offsetY = self.bookView.contentOffset.y;
    
    self.currentPage--;
    
    self.bookView.contentOffset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height * self.currentPage);
    
    if (self.bookView.contentOffset.y == self.offsetY) {
        
        self.currentPage++;
    }
    
}


//tap翻页
- (void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    
    if ([touch locationInView:self.view].x > [UIScreen mainScreen].bounds.size.width / 2 && ([touch locationInView:self.view].y > [UIScreen mainScreen].bounds.size.height / 2 + 50)) {
        
        [self leftPage];
        
    } else if ([touch locationInView:self.view].x < [UIScreen mainScreen].bounds.size.width / 2 && ([touch locationInView:self.view].y > [UIScreen mainScreen].bounds.size.height / 2 + 50)) {
        
        [self rightPage];
        
    } else if ([touch locationInView:self.view].y > [UIScreen mainScreen].bounds.size.height / 2 - 50 && [touch locationInView:self.view].y < [UIScreen mainScreen].bounds.size.height / 2 + 50) {
        
        NSLog(@"这里需要弹出设置界面");
        
    }
}


//bookView的懒加载
- (UITextView *)bookView {
    
    if (_bookView == nil) {
        
        _bookView = [[UITextView alloc] initWithFrame:self.view.frame];
        
        [self.view addSubview:_bookView];
        
    }
    return _bookView;
}


//隐藏读书界面的状态栏
-(BOOL)prefersStatusBarHidden {
    
    return YES;
}

@end
