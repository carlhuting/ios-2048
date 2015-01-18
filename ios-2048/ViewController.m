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
#import "LTCard.h"
#import "LTEmptyCellModel.h"

const NSInteger dimension=4;

@interface ViewController ()
{
    NSMutableArray *matrix;
}

@property (weak, nonatomic) IBOutlet LTGamePanel *gamePanel;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) NSMutableArray *scores;
@property (nonatomic, strong) NSMutableArray *dataModel;
@property (nonatomic, strong) LTEmptyCellModel *emptyModel;


@end

@implementation ViewController

- (instancetype)init {
    self=[super init];
    if (self) {
        [self initDataModel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self initDataModel];
    }
    return self;
}

- (void)initDataModel {
    
    self.cells=[[NSMutableArray alloc] initWithCapacity:dimension*dimension];
    matrix=[[NSMutableArray alloc] initWithCapacity:16];
    self.emptyModel=[[LTEmptyCellModel alloc]initWithDimension:dimension];
    
    for (NSUInteger i=0; i<16; i++) {
        [matrix addObject:[NSNull null]];
        
    }
}


- (NSUInteger)newscore {
     NSUInteger score=arc4random_uniform(10);
    if (score<8) {
        return 2;
    }
    return 4;
}

- (void)newGame {

    NSInteger first=[self.emptyModel emptyCell];
    [self showScore:first score:[self newscore]];
}

- (void)showScore:(NSInteger) index score:(NSUInteger) score {
    
    LTCard *card=[LTCard new];
    UIView *bgView=self.cells[index];
    
    UIButton *button=[[UIButton alloc] init];
    button.backgroundColor=[UIColor purpleColor];
    [button setTitle:@(score).stringValue forState:UIControlStateNormal];
    card.view=button;
    card.score=score;
    matrix[index]=card;
    card.view.frame=bgView.frame;
    [self.gamePanel addSubview:card.view];
    
}

- (UIButton *)cardwithscore:(NSUInteger) score {
    UIButton *button=[[UIButton alloc] init];
    button.backgroundColor=[UIColor purpleColor];
    [button setTitle:@(score).stringValue forState:UIControlStateNormal];
    return button;
}

- (IBAction)newgame:(id)sender {
    [self newGame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildBoard2];
    
    
    UISwipeGestureRecognizer * uswip=[[UISwipeGestureRecognizer alloc] init];
    [uswip setDirection:UISwipeGestureRecognizerDirectionUp];
    [uswip addTarget:self action:@selector(upswip:)];
    [self.gamePanel addGestureRecognizer:uswip];
    
    UISwipeGestureRecognizer * dswip=[[UISwipeGestureRecognizer alloc] init];
    [dswip setDirection:UISwipeGestureRecognizerDirectionDown];
    [dswip addTarget:self action:@selector(downswip:)];
    [self.gamePanel addGestureRecognizer:dswip];
    
    UISwipeGestureRecognizer * lswip=[[UISwipeGestureRecognizer alloc] init];
    [lswip setDirection:UISwipeGestureRecognizerDirectionLeft];
    [lswip addTarget:self action:@selector(leftswip:)];
    [self.gamePanel addGestureRecognizer:lswip];
    
    UISwipeGestureRecognizer * rswip=[[UISwipeGestureRecognizer alloc] init];
    [rswip setDirection:UISwipeGestureRecognizerDirectionRight];
    [rswip addTarget:self action:@selector(rightswip:)];
    [self.gamePanel addGestureRecognizer:rswip];

}

#pragma -mark swap
- (void)upswip:(id) sender {
    
    NSInteger lowerbound;
    NSInteger upperbound;
    NSInteger from;
    NSInteger to;
    
    for (NSInteger column=0; column<dimension; column++) {
        lowerbound=column;
        upperbound=column+dimension*(dimension-1);
        from=column;
        to=from+dimension;
        while (from<=upperbound) {
            if (matrix[from]== [NSNull null]) {
                to=from+dimension;
                while (to<=upperbound) {
                    if (matrix[to]!=[NSNull null]) {
                        [self movefrom:to to:from];
                        //from+=dimension;
                        break;
                    }
                    to+=dimension;
                }
                if (to>upperbound) {
                    break;
                }
            } else {
                to=from+dimension;
                while (to<=upperbound) {
                    if (matrix[to]!=[NSNull null]) {
                        if ([matrix[to] score]==[matrix[from] score]) {
                            [self mergefrom:to to:from];
                            from+=dimension;
                            break;
                        } else {
                            from+=dimension;
                            break;
                        }
                    }
                    to+=dimension;
                }
                if (to>upperbound) {
                    break;
                }
            }
        }
    }

}

- (void)downswip:(id) sender {
    NSInteger upperbound;
    NSInteger lowerbound;
    NSInteger from;
    NSInteger to;
    
    for (NSInteger column=dimension*(dimension-1); column<dimension*dimension; column++) {
        
        from=column;
        to=from-dimension;
        upperbound=column;
        lowerbound=column-dimension*(dimension-1);
        
        while (from>=lowerbound ) {
            if (matrix[from]== [NSNull null]) {
                to=from-dimension;
                while (to>=lowerbound) {
                    if (matrix[to]!=[NSNull null]) {
                        [self movefrom:to to:from];
                        //from-=dimension;
                        break;
                    }
                    to-=dimension;
                }
                if (to<lowerbound) {
                    break;
                }
            } else {
                to=from-dimension;
                while (to>=lowerbound) {
                    if (matrix[to]!=[NSNull null]) {
                        if ([matrix[to] score]==[matrix[from] score]) {
                            [self mergefrom:to to:from];
                            from-=dimension;
                            break;
                        } else {
                            from-=dimension;
                            break;
                        }
                    }
                    to-=dimension;
                }
                if (to<lowerbound) {
                    break;
                }
            }
        }
    }
    
}

- (void)leftswip:(id) sender {
    NSInteger lowerbound;
    NSInteger upperbound;
    NSInteger from;
    NSInteger to;
    
    for (NSInteger column=0; column<=dimension*(dimension-1); column+=dimension) {
        lowerbound=column;
        upperbound=column+dimension-1;
        from=column;
        to=from+1;
        while (from<=upperbound) {
            if (matrix[from]== [NSNull null]) {
                to=from+1;
                while (to<=upperbound) {
                    if (matrix[to]!=[NSNull null]) {
                        [self movefrom:to to:from];
                        //from+=1;
                        break;
                    }
                    to+=1;
                }
                if (to>upperbound) {
                    break;
                }
            } else {
                to=from+1;
                while (to<=upperbound) {
                    if (matrix[to]!=[NSNull null]) {
                        if ([matrix[to] score]==[matrix[from] score]) {
                            [self mergefrom:to to:from];
                            from+=1;
                            break;
                        } else {
                            from+=1;
                            break;
                        }
                    }
                    to+=1;
                }
                if (to>upperbound) {
                    break;
                }
            }
        }
    }
}

- (void)rightswip:(id) sender {
    NSInteger lowerbound;
    NSInteger upperbound;
    NSInteger from;
    NSInteger to;
    
    for (NSInteger column=dimension-1; column<=dimension*dimension-1; column+=dimension) {
        upperbound=column;
        lowerbound=column-dimension+1;
        from=column;
        to=from-1;
        while (from>=lowerbound) {
            if (matrix[from]== [NSNull null]) {
                to=from-1;
                while (to>=lowerbound) {
                    if (matrix[to]!=[NSNull null]) {
                        [self movefrom:to to:from];
                        //from-=1;
                        break;
                    }
                    to-=1;
                }
                if (to<lowerbound) {
                    break;
                }
            } else {
                to=from-1;
                while (to>=lowerbound) {
                    if (matrix[to]!=[NSNull null]) {
                        if ([matrix[to] score]==[matrix[from] score]) {
                            [self mergefrom:to to:from];
                            from-=1;
                            break;
                        } else {
                            from-=1;
                            break;
                        }
                    }
                    to-=1;
                }
                if (to<lowerbound) {
                    break;
                }
            }
        }
    }

}

- (void)movefrom:(NSInteger)from to:(NSInteger) to {
    if (from==to) {
        return ;
    }
    [self.emptyModel removeEmptyCell:to];
    [self.emptyModel addEmptyCell:from ];
    LTCard *card=matrix[from];
    matrix[from]=[NSNull null];
    matrix[to]=card;
    [UIView animateWithDuration:0.5 animations:^{
        card.view.frame=[self.cells[to] frame];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)mergefrom:(NSInteger)from to:(NSInteger) to {
    if (from==to) {
        return ;
    }
    
    [self.emptyModel addEmptyCell:from];
    LTCard *dismisscard=matrix[from];
    LTCard *card=matrix[to];
    [UIView animateWithDuration:0.5 animations:^{
        dismisscard.view.frame=card.view.frame;
        
    } completion:^(BOOL finished) {
        
    }];
     matrix[from]=[NSNull null];
    [dismisscard.view removeFromSuperview];
    [card twotimes];

    
}


- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)buildBoard2{
    NSUInteger rows=4;
    CGFloat span=5.0;
    
    [self.view layoutIfNeeded];
    CGFloat width=(self.gamePanel.frame.size.width-(4*10+(rows-1)*span))/rows;
    for (NSInteger i=0; i<rows; i++) {
        for (NSInteger j=0; j<rows; j++) {
            UIButton *view=[UIButton new];
            [view setTitle:[NSString stringWithFormat:@"%ld-%ld",i,j] forState:UIControlStateNormal];
            [self.cells addObject:view];
            view.backgroundColor=[UIColor orangeColor];
            
            [self.gamePanel addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(i*(width+span)+10));
                make.leading.equalTo(@(j*(width+span)+10));
                make.width.equalTo(@(width));
                make.height.equalTo(@(width));
            }];
        }
    }
    
}

- (void)buildBoard {
   
    NSUInteger rows=4;
    
    NSMutableArray *colarry=[[NSMutableArray alloc] initWithCapacity:rows];
    for (NSInteger row=0; row<rows; row++) {
        NSMutableArray *rowary=[[NSMutableArray alloc] initWithCapacity:rows];
        for (NSInteger column=0; column<rows; column++) {
            UIView *view=[UIView new];
            view.backgroundColor=[UIColor purpleColor];
            [self.cells addObject:view];
            [rowary addObject:view];
        }
        [colarry addObject:[self viewRow:rowary]];
    }
    [self viewColumn:colarry];
    
}

- (UIView *)viewRow:(NSArray *)cells  {
    
    UIView * rowView=[UIView new];
    UIView *leftview=rowView;
    
    for (UIView *view in cells) {
        [rowView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            if (leftview==rowView) {
                make.leading.equalTo(leftview.mas_leading);
                
            }
            else
            {
                make.leading.equalTo(leftview.mas_trailing);
            }
            make.bottom.equalTo(@0);
             // make.width.equalTo(rowView).dividedBy([cells count]);
            if (leftview!=rowView) {
                make.width.equalTo(leftview.mas_width);
            }
        }];
        leftview=view;
    }
    
    UIView *rightest=[cells lastObject];
    [rightest mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@0);
    }];
    return rowView;
}

- (UIView *)viewColumn:(NSArray *)cells  {
    
    UIView * rowView=self.gamePanel;
    UIView *leftview=rowView;
    
    for (UIView *view in cells) {
        [rowView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@0);
            if (leftview==rowView) {
                make.top.equalTo(leftview.mas_top);

            }
            else
            {
                make.top.equalTo(leftview.mas_bottom);
            }
            make.leading.equalTo(@0);
           // make.height.equalTo(rowView).dividedBy([cells count]);
            if (leftview!=rowView) {
                make.height.equalTo(leftview.mas_height);
                
            }
        }];
        leftview=view;
    }
   
    UIView *rightest=[cells lastObject];
    [rightest mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
    }];
    return rowView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
