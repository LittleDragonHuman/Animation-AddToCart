//
//  ViewController.m
//  AddToCart
//
//  Created by fly on 16/1/13.
//  Copyright © 2016年 fly. All rights reserved.
//

#import "ViewController.h"
#import "ProductData.h"
#import "ProductCell.h"

static NSInteger count = 0;

@interface BottomView : UIView

@property (nonatomic, strong) UILabel *numLabel;

- (void)updateNum:(NSInteger)totalNum;

@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.numLabel.backgroundColor = [UIColor redColor];
        self.numLabel.font = [UIFont systemFontOfSize:14];
        self.numLabel.textColor = [UIColor whiteColor];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.layer.cornerRadius = 5.0f;
        self.numLabel.clipsToBounds = YES;
        [self addSubview:self.numLabel];
    }
    return self;
}

- (void)updateNum:(NSInteger)totalNum
{
    self.numLabel.text = [NSString stringWithFormat:@"%@",@(totalNum)];
    [self.numLabel sizeToFit];
    self.numLabel.hidden = (totalNum == 0);
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.numLabel.frame.size.width + 5;
    CGFloat height = self.numLabel.frame.size.height + 5;
    self.numLabel.frame = CGRectMake(0, 0, width, height);
    self.numLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

@end


static NSString *cellIdentifier = @"productCell";
static CGFloat headerSpace = 60.0f;
static CGFloat bottomViewHeight = 60.0f;

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,ProductCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BottomView *bottomView;
@property (nonatomic, strong) UIView *redAnimationView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpCollectionView];
    [self setUpBottomView];
    [self setUpRedAnimationView];
    self.dataArray = [NSMutableArray arrayWithArray:[ProductData fetchAllProduct]];
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, 30);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    Product *product = self.dataArray[indexPath.row];
    [cell bindProduct:product];
    return cell;
}

- (void)addCart:(UIButton *)button product:(Product *)product
{
    CGPoint startPoint = [button.superview convertPoint:button.center toView:self.view];

    CGFloat width = button.frame.size.width;
    CGFloat height = button.frame.size.height;
    
    self.redAnimationView.frame = CGRectMake(0, 0, width, height);
    [self.view addSubview:self.redAnimationView];
    [self.view bringSubviewToFront:self.redAnimationView];
    self.redAnimationView.center = startPoint;
    
    CGPoint endPoint = [self.view convertPoint:self.bottomView.numLabel.center fromView:self.bottomView];
    
    //贝塞尔曲线
//    CAKeyframeAnimation *lineAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    lineAnimation.delegate = self;
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:startPoint];
//    [path addQuadCurveToPoint:endPoint controlPoint:CGPointMake(150, 30)];
//    lineAnimation.path = path.CGPath;
//    lineAnimation.duration = 1.0f;
//    [self.redAnimationView.layer addAnimation:lineAnimation forKey:@"runLine"];
    
    //缩放
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnimation.delegate = self;
//    scaleAnimation.duration = 1.0f;
//    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
//    scaleAnimation.toValue = [NSNumber numberWithFloat:0.25];
//    [self.redAnimationView.layer addAnimation:scaleAnimation forKey:@"scale"];
    
    //直线,暂不考虑循环引用
    [UIView animateWithDuration:1.0 animations:^{
        self.redAnimationView.frame = CGRectMake(0, 0, 5, 5);
        self.redAnimationView.layer.cornerRadius = self.redAnimationView.frame.size.height / 2;
        self.redAnimationView.center = endPoint;
    }completion:^(BOOL finished) {
        [self stopWork];
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [self stopWork];
    }
}

- (void)stopWork
{
    [self.redAnimationView removeFromSuperview];
    count ++;
    [self updateBottomInfo];
}

- (void)setUpCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGRect frame = CGRectMake(0, headerSpace, self.view.frame.size.width, self.view.frame.size.height - headerSpace - bottomViewHeight);
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame
                                             collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ProductCell class] forCellWithReuseIdentifier:cellIdentifier];
}

- (void)setUpBottomView
{
    self.bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), self.view.frame.size.width, bottomViewHeight)];
    [self.view addSubview:self.bottomView];
    [self updateBottomInfo];
}

- (void)setUpRedAnimationView
{
    self.redAnimationView = [[UIView alloc] initWithFrame:CGRectZero];
    self.redAnimationView.backgroundColor = [UIColor redColor];
}

- (void)updateBottomInfo
{
    [self.bottomView updateNum:count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
