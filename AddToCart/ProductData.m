//
//  ProductData.m
//  AddToCart
//
//  Created by fly on 16/1/13.
//  Copyright © 2016年 fly. All rights reserved.
//

#import "ProductData.h"

@implementation Product
@end

@implementation ProductData

+ (NSArray *)fetchAllProduct
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < 20; i++) {
        Product *product = [Product new];
        product.productName = [NSString stringWithFormat:@"商品%@",@(i)];
        product.productPrice = i;
        [array addObject:product];
    }
    return [NSArray arrayWithArray:array];
}

@end
