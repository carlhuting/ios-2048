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

const NSInteger dimension = 4;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet LTGamePanel *gamePanel;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) NSMutableArray *scores;
@property (nonatomic, strong) NSMutableArray *dataModel;
@property (nonatomic, strong) LTEmptyCellModel *emptyModel;
@property (nonatomic, strong) NSMutableArray *matrix;

@end

@implementation ViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDataModel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initDataModel];
    }
    return self;
}

- (void)initDataModel {
    
    self.cells = [[NSMutableArray alloc] initWithCapacity:dimension*dimension];
    _matrix = [[NSMutableArray alloc] initWithCapacity:16];
    self.emptyModel = [[LTEmptyCellModel alloc]initWithDimension:dimension];
    
    for (NSUInteger i = 0; i < 16; i++) {
        [_matrix addObject:[NSNull null]];
    }
}

- (NSUInteger)newscore {
     NSUInteger score = arc4random_uniform(10);
    if (score<8) {
        return 2;
    }
    return 4;
}

- (void)newGame {
    NSInteger first = [self.emptyModel emptyCell];
    [self showScore:first score:[self newscore]];
}

- (void)showScore:(NSInteger)index score:(NSUInteger)score {
    LTCard *card = [LTCard new];
    UIView *bgView = self.cells[index];
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor purpleColor];
    [button setTitle:@(score).stringValue forState:UIControlStateNormal];
    card.view = button;
    card.score = score;
    _matrix[index] = card;
    card.view.frame = bgView.frame;
    [self.gamePanel addSubview:card.view];
}

- (UIButton *)cardwithscore:(NSUInteger) score {
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor purpleColor];
    [button setTitle:@(score).stringValue forState:UIControlStateNormal];
    return button;
}

- (IBAction)newgame:(id)sender {
    [self newGame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildBoard];
    
    UISwipeGestureRecognizer * uswip = [[UISwipeGestureRecognizer alloc] init];
    [uswip setDirection:UISwipeGestureRecognizerDirectionUp];
    [uswip addTarget:self action:@selector(upswip:)];
    [self.gamePanel addGestureRecognizer:uswip];
    
    UISwipeGestureRecognizer * dswip = [[UISwipeGestureRecognizer alloc] init];
    [dswip setDirection:UISwipeGestureRecognizerDirectionDown];
    [dswip addTarget:self action:@selector(downswip:)];
    [self.gamePanel addGestureRecognizer:dswip];
    
    UISwipeGestureRecognizer * lswip = [[UISwipeGestureRecognizer alloc] init];
    [lswip setDirection:UISwipeGestureRecognizerDirectionLeft];
    [lswip addTarget:self action:@selector(leftswip:)];
    [self.gamePanel addGestureRecognizer:lswip];
    
    UISwipeGestureRecognizer * rswip = [[UISwipeGestureRecognizer alloc] init];
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
    
    for (NSInteger column = 0; column < dimension; column++) {
        lowerbound = column;
        upperbound = column + dimension * (dimension-1);
        from = column;
        to = from + dimension;
        while (from <= upperbound) {
            if (_matrix[from] == [NSNull null]) {
                to = from + dimension;
                while (to <= upperbound) {
                    if (_matrix[to]!=[NSNull null]) {
                        [self movefrom:to to:from];
                        break;
                    }
                    to += dimension;
                }
                if (to > upperbound) {
                    break;
                }
            } else {
                to = from + dimension;
                while (to <= upperbound) {
                    if (_matrix[to]!= [NSNull null]) {
                        if ([_matrix[to] score] == [_matrix[from] score]) {
                            [self mergefrom:to to:from];
                            from += dimension;
                            break;
                        } else {
                            from += dimension;
                            break;
                        }
                    }
                    to += dimension;
                }
                if (to > upperbound) {
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
    
    for (NSInteger column = dimension * (dimension-1); column < dimension * dimension; column++) {
        
        from = column;
        to = from - dimension;
        upperbound = column;
        lowerbound = column - dimension * (dimension - 1);
        
        while (from >= lowerbound ) {
            if (_matrix[from] == [NSNull null]) {
                to = from-dimension;
                while (to >= lowerbound) {
                    if (_matrix[to] != [NSNull null]) {
                        [self movefrom:to to:from];
                        //from-=dimension;
                        break;
                    }
                    to -= dimension;
                }
                if (to < lowerbound) {
                    break;
                }
            } else {
                to = from-dimension;
                while (to >= lowerbound) {
                    if (_matrix[to] != [NSNull null]) {
                        if ([_matrix[to] score] == [_matrix[from] score]) {
                            [self mergefrom:to to:from];
                            from -= dimension;
                            break;
                        } else {
                            from -= dimension;
                            break;
                        }
                    }
                    to -= dimension;
                }
                if (to < lowerbound) {
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
    
    for (NSInteger column = 0; column <= dimension * (dimension-1); column += dimension) {
        lowerbound = column;
        upperbound = column+dimension-1;
        from = column;
        to = from+1;
        while (from <= upperbound) {
            if (_matrix[from] == [NSNull null]) {
                to=from+1;
                while (to <= upperbound) {
                    if (_matrix[to]!= [NSNull null]) {
                        [self movefrom:to to:from];
                        //from+=1;
                        break;
                    }
                    to += 1;
                }
                if (to > upperbound) {
                    break;
                }
            } else {
                to = from+1;
                while (to <= upperbound) {
                    if (_matrix[to]!=[NSNull null]) {
                        if ([_matrix[to] score] == [_matrix[from] score]) {
                            [self mergefrom:to to:from];
                            from += 1;
                            break;
                        } else {
                            from += 1;
                            break;
                        }
                    }
                    to += 1;
                }
                if (to > upperbound) {
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
    
    for (NSInteger column = dimension-1; column<=dimension*dimension-1; column+=dimension) {
        upperbound = column;
        lowerbound = column - dimension + 1;
        from = column;
        to = from-1;
        while (from >= lowerbound) {
            if (_matrix[from] == [NSNull null]) {
                to = from-1;
                while (to>=lowerbound) {
                    if (_matrix[to]!=[NSNull null]) {
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
                    if (_matrix[to]!=[NSNull null]) {
                        if ([_matrix[to] score]==[_matrix[from] score]) {
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
    if (from == to) {
        return ;
    }
    [self.emptyModel removeEmptyCell:to];
    [self.emptyModel addEmptyCell:from ];
    LTCard *card = _matrix[from];
    _matrix[from] = [NSNull null];
    _matrix[to] = card;
    [UIView animateWithDuration:0.5 animations:^{
        card.view.frame = [self.cells[to] frame];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)mergefrom:(NSInteger)from to:(NSInteger) to {
    if (from==to) {
        return ;
    }
    [self.emptyModel addEmptyCell:from];
    LTCard *dismisscard=_matrix[from];
    LTCard *card = _matrix[to];
    [UIView animateWithDuration:0.5 animations:^{
        dismisscard.view.frame=card.view.frame;
        
    } completion:^(BOOL finished) {
    }];
     _matrix[from]=[NSNull null];
    [dismisscard.view removeFromSuperview];
    [card twotimes];
}

- (void)buildBoard {
    NSUInteger rows = dimension;
    CGFloat span = 5.0;
    
    [self.view layoutIfNeeded];
    CGFloat width = (self.gamePanel.frame.size.width-(4*10+(rows-1)*span))/rows;
    for (NSInteger i = 0; i<rows; i++) {
        for (NSInteger j = 0; j<rows; j++) {
            UIButton *view = [UIButton new];
            [view setTitle:[NSString stringWithFormat:@"%d-%d",i,j] forState:UIControlStateNormal];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
