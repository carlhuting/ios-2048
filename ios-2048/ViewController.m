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

const NSInteger dimension=4;

@interface ViewController ()
{
    NSMutableArray *matrix;
    NSMutableArray  *emptymatrix;
}

@property (weak, nonatomic) IBOutlet LTGamePanel *gamePanel;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) NSMutableArray *scores;
@property (nonatomic, strong) NSMutableArray *dataModel;


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
    
    self.cells=[[NSMutableArray alloc] initWithCapacity:16];
    matrix=[[NSMutableArray alloc] initWithCapacity:16];
    emptymatrix=[[NSMutableArray alloc] initWithCapacity:16];
    
    for (NSUInteger i=0; i<16; i++) {
        [matrix addObject:[NSNull null]];
        [emptymatrix addObject:@(i)];
    }
}

- (NSInteger)emptyCell {
    
    NSUInteger index=(NSUInteger)arc4random_uniform((u_int32_t)[emptymatrix count]);
    NSNumber *emptyNumber = [emptymatrix objectAtIndex:index];
    [emptymatrix removeObjectAtIndex:index];
    return emptyNumber.intValue;
}

- (NSUInteger)newscore {
     NSUInteger score=arc4random_uniform(10);
    if (score<8) {
        return 2;
    }
    return 4;
}

- (void)newGame {
    
    //[self initDataModel];
    NSInteger first=[self emptyCell];

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
    // Do any additional setup after loading the view, typically from a nib.
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

- (void)upswip:(id) sender {
    
    NSInteger lowerbound=0;
    NSInteger upperbound=dimension*dimension;
    
    for (NSInteger column=lowerbound; column<lowerbound+dimension; column++) {
        NSInteger from=column;
        NSInteger to=from+dimension;
        while (from<upperbound) {
            if (matrix[from]== [NSNull null]) {
                to=from+dimension;
                while (to<upperbound) {
                    if (matrix[to]!=[NSNull null]) {
                        [self movefrom:to to:from];
                        from+=dimension;
                        break;
                    }
                    to+=dimension;
                }
                if (to>=upperbound) {
                    break;
                }
            } else {
                to=from+dimension;
                while (to<upperbound) {
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
                if (to>=upperbound) {
                    break;
                }
            }
        }
    }

}

- (void)downswip:(id) sender {
    
    NSInteger upperbound=dimension*dimension;
    NSInteger lowerbound=dimension-dimension;
    
    for (NSInteger column=dimension*(dimension-1); column<dimension*dimension; column++) {
        
        NSInteger from=column;
        NSInteger to=from-dimension;
        upperbound=column;
        lowerbound=column-dimension*(dimension-1);
        
        while (from>=lowerbound ) {
            if (matrix[from]== [NSNull null]) {
                to=from-dimension;
                while (to>=lowerbound) {
                    if (matrix[to]!=[NSNull null]) {
                        [self movefrom:to to:from];
                        from-=dimension;
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
    
    NSInteger lowerbound=0;
    NSInteger upperbound=dimension*dimension;
    
    for (NSInteger column=lowerbound; column<=lowerbound+dimension*(dimension-1); column+=dimension) {
        upperbound=column+dimension;
        NSInteger from=column;
        NSInteger to=from+1;
        while (from<upperbound) {
            if (matrix[from]== [NSNull null]) {
                to=from+1;
                while (to<upperbound) {
                    if (matrix[to]!=[NSNull null]) {
                        [self movefrom:to to:from];
                        from+=1;
                        break;
                    }
                    to+=1;
                }
                if (to>=upperbound) {
                    break;
                }
            } else {
                to=from+1;
                while (to<upperbound) {
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
                if (to>=upperbound) {
                    break;
                }
            }
        }
    }

}

- (void)rightswip:(id) sender {
    
    NSInteger lowerbound=0;
    NSInteger upperbound=dimension*dimension;
    
    for (NSInteger column=dimension-1; column<=dimension*dimension-1; column+=dimension) {
        lowerbound=column-dimension;
        NSInteger from=column;
        NSInteger to=from-1;
        while (from>lowerbound) {
            if (matrix[from]== [NSNull null]) {
                to=from-1;
                while (to>lowerbound) {
                    if (matrix[to]!=[NSNull null]) {
                        [self movefrom:to to:from];
                        from-=1;
                        break;
                    }
                    to-=1;
                }
                if (to<=lowerbound) {
                    break;
                }
            } else {
                to=from-1;
                while (to>lowerbound) {
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
                if (to<=lowerbound) {
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
    
    [self removeempty:to];
    [emptymatrix addObject:@(from)];
    
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
    
    [emptymatrix addObject:@(from)];
    LTCard *dismisscard=matrix[from];
    [dismisscard.view removeFromSuperview];
    LTCard *card=matrix[to];
    [card twotimes];
    [UIView animateWithDuration:0.5 animations:^{
       
        
    } completion:^(BOOL finished) {
        matrix[from]=[NSNull null];
    }];
    
}

- (void)removeempty:(NSInteger) position {
    
    for (NSInteger i=0; i<[emptymatrix count]; i++) {
        if (position==[emptymatrix[i] intValue]) {
            [emptymatrix removeObjectAtIndex:i];
            NSLog(@"remove emptycell at %ld",position);
            return;
        }
    }
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
