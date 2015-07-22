//
//  SCSBookViewController.m
//  e-reader
//
//  Created by 张鹏 on 15/7/7.
//  Copyright © 2015年 smallCobblerStudio. All rights reserved.
//

#import "SCSBookViewController.h"
#import "SCSBookView.h"

@interface SCSBookViewController ()

@end

@implementation SCSBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self loadBookView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadBookView {
    
    SCSBookView *bookView = [[SCSBookView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.view addSubview:bookView];
}



//隐藏读书界面的状态栏
-(BOOL)prefersStatusBarHidden {
    
    return YES;
}

@end
