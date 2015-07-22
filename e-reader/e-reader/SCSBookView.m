//
//  SCSBookView.m
//  e-reader
//
//  Created by 张鹏 on 15/7/20.
//  Copyright © 2015年 smallCobblerStudio. All rights reserved.
//

#import "SCSBookView.h"

@interface SCSBookView ()

@property (nonatomic,strong) UITextView *bookView;
@property (nonatomic,assign) NSInteger  currentPage;
@property (nonatomic,assign) NSInteger  allPage;
@property (nonatomic,assign) double     offsetY;
@property (nonatomic,strong) CALayer    *imgLayer;
@property (nonatomic,strong) UIView     *txtView;

@end

@implementation SCSBookView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    
    self.bookView.editable = NO;
    self.bookView.userInteractionEnabled = NO;
    
    self.fontSize = 18;
    
    
    [self loadTXT];
    
//    [self addGestureRecognizer];
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
    
    [self addGestureRecognizer:rightPageGesture];
    
    [self addGestureRecognizer:leftPageGesture];
    
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
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //    [UIView setAnimationRepeatAutoreverses:enableAnimation.isOn];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self cache:YES];
    [UIView commitAnimations];
    
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
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //    [UIView setAnimationRepeatAutoreverses:enableAnimation.isOn];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self cache:YES];
    [UIView commitAnimations];
}

//tap翻页
- (void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {

    UITouch *touch = touches.anyObject;

    if ([touch locationInView:self].x > [UIScreen mainScreen].bounds.size.width / 2 && ([touch locationInView:self].y > [UIScreen mainScreen].bounds.size.height / 2 + 50)) {

    [self leftPage];
        
    } else if ([touch locationInView:self].x < [UIScreen mainScreen].bounds.size.width / 2 && ([touch locationInView:self].y > [UIScreen mainScreen].bounds.size.height / 2 + 50)) {

    [self rightPage];
        
    } else if ([touch locationInView:self].y > [UIScreen mainScreen].bounds.size.height / 2 - 50 && [touch locationInView:self].y < [UIScreen mainScreen].bounds.size.height / 2 + 50) {
        
        NSLog(@"这里需要弹出设置界面");
    }
}

//- (void)touchesMoved:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    
//    UITouch *touch = touches.anyObject;
//    
//    CGFloat x = [touch locationInView:self].x;
//    
//    [self movePageWithX:x];
//}
//
//
//- (void)movePageWithX:(float)x {
//    
//    
//
//    
//    
//
//}

- (UIImage *)getImageCtx {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

//bookView的懒加载
- (UITextView *)bookView {

    if (_bookView == nil) {
        
        _bookView = [[UITextView alloc] initWithFrame:self.frame];
        
        NSLog(@"%f",_bookView.frame.size.width);
        
        [self addSubview:_bookView];
        
    }
    return _bookView;
}

- (CALayer *)imgLayer {
    
    if (_imgLayer == nil) {
        
        _imgLayer = [[CALayer alloc] init];
        
        _imgLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        
        _imgLayer.contents = (__bridge id __nullable)([self getImageCtx].CGImage);
        
        [self.layer addSublayer:_imgLayer];
        
    }
    return _imgLayer;
}

@end
