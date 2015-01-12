//
//  ViewController.m
//  ios-2048
//
//  Created by carl on 15/1/9.
//  Copyright (c) 2015年 lemontree. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "LTGamePanel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet LTGamePanel *gamePanel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self buildBoard];
    
    UIButton *button=[UIButton new];
    button.backgroundColor=[UIColor orangeColor];
    [button setTitle:@"2" forState:UIControlStateNormal];
    [button setTitle:@"4" forState:UIControlStateHighlighted];
    UIView *subview=self.gamePanel.subviews[8];
    [subview addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
         make.top.equalTo(@0);
         make.trailing.equalTo(@0);
         make.bottom.equalTo(@0);
    }];
    
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)buildBoard {
   
    NSInteger rows=4;
    CGFloat span=6.0;
    CGFloat width=78;
    
    for (NSInteger row=0; row<rows; row++) {
        for (NSInteger column=0; column<rows; column++) {
            UIView * bgview=[UIView new];
            [self.gamePanel addSubview:bgview];
            bgview.backgroundColor=[UIColor purpleColor];
            
            [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
              //  make.centerX.equalTo(@(  (column-rows/2.0+0.5)*(span+width) ));
              //  make.centerY.equalTo(@(  (row-rows/2.0+0.5)*(span+width)  ));
                make.centerX.equalTo(self.gamePanel.mas_centerX).dividedBy(column+1);
                make.centerY.equalTo(self.gamePanel.mas_centerX).dividedBy(row+1);
                make.width.equalTo(self.gamePanel.mas_width).dividedBy(5);
                make.height.equalTo(self.gamePanel.mas_width).dividedBy(5);;
            }];
            bgview.layer.cornerRadius=6;
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
