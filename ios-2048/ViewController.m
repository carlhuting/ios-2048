//
//  ViewController.m
//  iOS-2048
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
static NSString *const kMaxHistoryKey = @"kMaxHistoryScore";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *gameButton;
@property (weak, nonatomic) IBOutlet LTGamePanel *gamePanel;
@property (weak, nonatomic) IBOutlet UILabel *currentScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxScoreLabel;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) NSMutableArray *scores;
@property (nonatomic, strong) NSMutableArray *dataModel;
@property (nonatomic, assign) NSInteger currentScore;
@property (nonatomic, assign) NSInteger historyScore;
/**
 * it store all the empty cells
 */
@property (nonatomic, strong) LTEmptyCellModel *emptyModel;
/**
 *it store all the card
 */
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
    NSInteger capacity = dimension * dimension;
    _matrix = [[NSMutableArray alloc] initWithCapacity:capacity];
    for (NSInteger i = 0; i < capacity; i++) {
        [_matrix addObject:[NSNull null]];
    }
    self.emptyModel = [[LTEmptyCellModel alloc]initWithDimension:dimension];
}

- (NSInteger)newScore {
     NSInteger score = arc4random_uniform(10);
    if (score < 8) {
        return 2;
    }
    return 4;
}

- (void)newGame {
    for (NSInteger i = 0; i < dimension * dimension; i ++) {
        if (self.matrix[i] != [NSNull null]) {
            [[self.matrix[i] view] removeFromSuperview];
            self.matrix[i] = [NSNull null];
        }
    }
    if (self.currentScore > self.historyScore) {
        self.historyScore = self.currentScore;
        [[NSUserDefaults standardUserDefaults] setInteger:self.historyScore forKey:kMaxHistoryKey];
    }
    self.currentScore = 0;
    [self.emptyModel reset];
    [self addNewOne];
    [self addNewOne];
}

- (void)showScore:(NSInteger)index score:(NSInteger)score {
    LTCard *card = [[LTCard alloc] init];
    UIButton *button = [self cardwithscore:score];
    card.view = button;
    card.score = score;
    _matrix[index] = card;
    card.view.frame = [self getFrame:index];
    card.view.alpha = 0.4;
    card.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [self.gamePanel addSubview:card.view];
    [UIView animateWithDuration:0.23 animations:^{
        card.view.alpha = 1.0;
        card.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)addNewOne {
    if ([self.emptyModel isEmpty]) {
        return ;
    }
    NSInteger newOne = [self.emptyModel emptyCell];
    [self showScore:newOne score:[self newScore]];
    [self gameOver];
}

- (UIButton *)cardwithscore:(NSInteger) score {
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor purpleColor];
    [button setTitle:@(score).stringValue forState:UIControlStateNormal];
    return button;
}

- (void)newgame:(id)sender {
    [self newGame];
}

- (void)setCurrentScore:(NSInteger)currentScore {
    _currentScore = currentScore;
    self.currentScoreLabel.text = @(currentScore).stringValue;
}

- (void)setHistoryScore:(NSInteger)historyScore {
    _historyScore = historyScore;
    self.maxScoreLabel.text = @(historyScore).stringValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gamePanel.layer.cornerRadius = 2.0;
    self.gamePanel.layer.borderColor = [UIColor lt_background2].CGColor;
    self.gamePanel.layer.borderWidth = 4.0;
    self.gameButton.layer.cornerRadius = 4.0;
    [self.gameButton addTarget:self action:@selector(newgame:) forControlEvents:UIControlEventTouchUpInside];
    self.currentScore = 0;
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    self.historyScore = [accountDefaults integerForKey:kMaxHistoryKey];
    
    [self buildBoard];
    
    UISwipeGestureRecognizer *uswip = [[UISwipeGestureRecognizer alloc] init];
    [uswip setDirection:UISwipeGestureRecognizerDirectionUp];
    [uswip addTarget:self action:@selector(upswip:)];
    [self.gamePanel addGestureRecognizer:uswip];
    
    UISwipeGestureRecognizer *dswip = [[UISwipeGestureRecognizer alloc] init];
    [dswip setDirection:UISwipeGestureRecognizerDirectionDown];
    [dswip addTarget:self action:@selector(downswip:)];
    [self.gamePanel addGestureRecognizer:dswip];
    
    UISwipeGestureRecognizer *lswip = [[UISwipeGestureRecognizer alloc] init];
    [lswip setDirection:UISwipeGestureRecognizerDirectionLeft];
    [lswip addTarget:self action:@selector(leftswip:)];
    [self.gamePanel addGestureRecognizer:lswip];
    
    UISwipeGestureRecognizer *rswip = [[UISwipeGestureRecognizer alloc] init];
    [rswip setDirection:UISwipeGestureRecognizerDirectionRight];
    [rswip addTarget:self action:@selector(rightswip:)];
    [self.gamePanel addGestureRecognizer:rswip];
}


- (void)buildBoard {
    NSInteger capacity = dimension * dimension;
    self.cells = [[NSMutableArray alloc] initWithCapacity:capacity];
    for (NSInteger i = 0; i<dimension; i++) {
        for (NSInteger j = 0; j<dimension; j++) {
            UIView *view = [[UIView alloc] init];
            view.layer.cornerRadius = 2.0;
            view.layer.borderWidth = 2;
            view.layer.borderColor = [UIColor lt_background2].CGColor;
            
            [self.cells addObject:view];
            view.backgroundColor = [UIColor lt_blank];
            [self.gamePanel addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.gamePanel.mas_width).multipliedBy(1.0/dimension);
                make.height.equalTo(self.gamePanel.mas_height).multipliedBy(1.0/dimension);
                if (i > 0) {
                    UIView *topView = self.cells[(i - 1) * dimension + j];
                    make.top.equalTo(topView.mas_bottom);
                } else {
                    make.top.equalTo(@0);
                }
                if (j > 0) {
                    UIView *leftView = self.cells[i * dimension + j - 1];
                    make.leading.equalTo(leftView.mas_trailing);
                } else {
                    make.leading.equalTo(@0);
                }
            }];
        }
    }
}

#pragma -mark swap

- (void)upswip:(id) sender {
    NSInteger lowerbound;
    NSInteger upperbound;
    NSInteger from;
    NSInteger to;
    NSInteger score = 0;
    BOOL flag = NO;
    
    for (NSInteger column = 0; column < dimension; column++) {
        lowerbound = column;
        upperbound = column + dimension * (dimension-1);
        from = column;
        to = from + dimension;
        while (from <= upperbound) {
            if (_matrix[from] == [NSNull null]) {
                to = from + dimension;
                while (to <= upperbound) {
                    if (_matrix[to]!= [NSNull null]) {
                        [self movefrom:to to:from];
                        flag = flag || YES;
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
                           score += [self mergefrom:to to:from];
                            flag = flag || YES;
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
    !flag?:[self valueDidChange:score];
}

- (void)downswip:(id) sender {
    NSInteger lowerbound;
    NSInteger upperbound;
    NSInteger from;
    NSInteger to;
    NSInteger score = 0;
    BOOL flag = NO;
    
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
                        flag = flag || YES;
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
                            score += [self mergefrom:to to:from];
                            flag = flag || YES;
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
    !flag?:[self valueDidChange:score];
}

- (void)leftswip:(id) sender {
    NSInteger lowerbound;
    NSInteger upperbound;
    NSInteger from;
    NSInteger to;
    NSInteger score = 0;
    BOOL flag = NO;
    
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
                        flag = flag || YES;
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
                           score += [self mergefrom:to to:from];
                            flag = flag || YES;
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
    !flag?:[self valueDidChange:score];
}

- (void)rightswip:(id) sender {
    NSInteger lowerbound;
    NSInteger upperbound;
    NSInteger from;
    NSInteger to;
    NSInteger score = 0;
    BOOL flag = NO;
    
    for (NSInteger column = dimension-1; column <= dimension * dimension - 1; column += dimension) {
        upperbound = column;
        lowerbound = column - dimension + 1;
        from = column;
        to = from-1;
        while (from >= lowerbound) {
            if (_matrix[from] == [NSNull null]) {
                to = from-1;
                while (to >= lowerbound) {
                    if (_matrix[to] != [NSNull null]) {
                        [self movefrom:to to:from];
                        flag = flag || YES;
                        break;
                    }
                    to -= 1;
                }
                if (to<lowerbound) {
                    break;
                }
            } else {
                to = from-1;
                while (to >= lowerbound) {
                    if (_matrix[to] != [NSNull null]) {
                        if ([_matrix[to] score] == [_matrix[from] score]) {
                           score += [self mergefrom:to to:from];
                            flag = flag || YES;
                            from -= 1;
                            break;
                        } else {
                            from -= 1;
                            break;
                        }
                    }
                    to -= 1;
                }
                if (to < lowerbound) {
                    break;
                }
            }
        }
    }
    !flag?:[self valueDidChange:score];
}

- (void)valueDidChange:(NSInteger) score {
    [self performSelector:@selector(addNewOne) withObject:nil afterDelay:0.4];
    self.currentScore += score;
}

- (BOOL)gameOver {
    if (![self.emptyModel isEmpty]) {
        return NO;
    }
    NSInteger row, column;
    for (row = 0 ;row < dimension; row ++) {
        for (column = 0; column < dimension; column ++) {
            if ((row+column) % 2 != 0) {
                continue;
            }
            NSInteger index = row * dimension + column;
            LTCard *card = _matrix[index];
            if (row > 0) {
                NSInteger top = index -dimension;
                LTCard *topCard = _matrix[top];
                if ([card score] == [topCard score]) {
                    return NO;
                }
            }
            if (column < (dimension -1)) {
                NSInteger right = index +1;
                LTCard *topCard = _matrix[right];
                if ([card score] == [topCard score]) {
                    return NO;
                }
            }
            if (row < (dimension - 1)) {
                NSInteger bottom = index + dimension;
                LTCard *topCard = _matrix[bottom];
                if ([card score] == [topCard score]) {
                    return NO;
                }
            }
            if (column > 0) {
                NSInteger left = index -1;
                LTCard *topCard = _matrix[left];
                if ([card score] == [topCard score]) {
                    return NO;
                }
            }
        }
    }
    UIAlertView *alertView = [[UIAlertView alloc]  initWithTitle:@"信息" message:@"Game Over" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    return YES;
}

- (CGRect)getFrame:(NSInteger) index {
    UIView *cell = self.cells[index];
    CGFloat x = CGRectGetMinX(cell.frame)+2;
    CGFloat y = CGRectGetMinY(cell.frame)+2;
    CGFloat width = CGRectGetWidth(cell.frame)-4;
    CGFloat height = CGRectGetHeight(cell.frame)-4;
    CGRect rect = CGRectMake(x, y, width, height);
    return rect;
}

- (void)movefrom:(NSInteger)from to:(NSInteger) to {
    if (from == to) {
        return ;
    }
    [self.emptyModel removeEmptyCell:to];
    [self.emptyModel addEmptyCell:from ];
    LTCard *card = _matrix[from];
    _matrix[from] = [NSNull null];
    NSAssert(_matrix[to] == [NSNull null], @"there is error about move");
    _matrix[to] = card;
    [UIView animateWithDuration:0.25 animations:^{
        card.view.frame = [self getFrame:to];
    } completion:^(BOOL finished) {
        
    }];
}

- (NSInteger)mergefrom:(NSInteger)from to:(NSInteger) to {
    if (from == to) {
        return 0;
    }
    [self.emptyModel addEmptyCell:from];
    LTCard *dismisscard = _matrix[from];
    LTCard *card = _matrix[to];
    [UIView animateWithDuration:0.25 animations:^{
        dismisscard.view.frame = card.view.frame;
        dismisscard.view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
    }];
     _matrix[from] = [NSNull null];
    [dismisscard.view removeFromSuperview];
    return [card twice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
