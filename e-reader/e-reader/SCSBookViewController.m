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
@property(nonatomic,assign) int currentPage;
@property(nonatomic,assign) int allPage;

@end

@implementation SCSBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.bookView.scrollEnabled = NO;
    self.bookView.editable = NO;
    self.bookView.textContainerInset = UIEdgeInsetsMake(20, 0, 20, 0);
    
    
    
    self.bookName = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zuishuxidemoshengren" ofType:@"txt"]   encoding:NSUTF8StringEncoding error:nil ];
    
    self.bookView.text = self.bookName;
    
    self.allPage = self.bookView.contentSize.height / self.bookView.frame.size.height;
    
    NSLog(@"%d",self.allPage);
    
    
    UIPanGestureRecognizer *turnPageGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(turnToNewPage)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)turnToNewPage {
    
    
    
}


//bookView的懒加载
- (UITextView *)bookView {
    
    if (_bookView == nil) {
        
        UITextView *bookView = [[UITextView alloc] initWithFrame:self.view.frame];
        
        _bookView = bookView;
        
        [self.view addSubview:bookView];
        
    }
    return _bookView;
}


//隐藏读书界面的状态栏
-(BOOL)prefersStatusBarHidden {
    
    return YES;
}

@end
