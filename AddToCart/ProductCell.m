//
//  productCell.m
//  AddToCart
//
//  Created by fly on 16/1/13.
//  Copyright © 2016年 fly. All rights reserved.
//

#import "ProductCell.h"
#import "ProductData.h"

@implementation ProductCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    [self.contentView addSubview:self.productNameLabel];
    
    self.productPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.productNameLabel.frame), 5, 100, 20)];
    [self.contentView addSubview:self.productPriceLabel];
    
    self.addToChartButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 100, 20)];
    [self.addToChartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self.addToChartButton setBackgroundColor:[UIColor greenColor]];
    [self.addToChartButton addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.addToChartButton];
}

- (void)bindProduct:(Product *)product
{
    self.product = product;
    self.productNameLabel.text = product.productName;
    self.productPriceLabel.text = [NSString stringWithFormat:@"%@",@(product.productPrice)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect buttonFrame = CGRectMake(self.contentView.frame.size.width - self.addToChartButton.frame.size.width - 10, 5, 100, 20);
    self.addToChartButton.frame = buttonFrame ;
}

- (void)addToCart:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addCart:product:)]) {
        [self.delegate addCart:sender product:self.product];
    }
}

@end
