//
//  ProductData.h
//  AddToCart
//
//  Created by fly on 16/1/13.
//  Copyright © 2016年 fly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, copy) NSString *productName;
@property (nonatomic, assign) NSInteger productPrice;

@end

@interface ProductData : NSObject

+ (NSArray *)fetchAllProduct;

@end
