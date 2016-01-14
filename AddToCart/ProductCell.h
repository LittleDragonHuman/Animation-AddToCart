//
//  productCell.h
//  AddToCart
//
//  Created by fly on 16/1/13.
//  Copyright © 2016年 fly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;

@protocol ProductCellDelegate <NSObject>

- (void)addCart:(UIButton *)button product:(Product *)product;

@end

@interface ProductCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *productPriceLabel;
@property (nonatomic, strong) UIButton *addToChartButton;
@property (nonatomic, assign) id <ProductCellDelegate>delegate;
@property (nonatomic, strong) Product *product;

- (void)bindProduct:(Product *)product;

@end
