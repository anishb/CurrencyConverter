//
//  ExchangeRate.h
//  CurrencyConverter
//
//  Created by Anish Basu on 1/29/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeRate : NSObject

@property (nonatomic, copy) NSString *baseCurrencyCode;
@property (nonatomic, copy) NSNumber *timestamp;
@property (nonatomic, copy) NSDictionary *rates;

- (NSDate *)lastUpdated;
- (double)rateFrom:(NSString *)baseCurrencyCode
				to:(NSString *)targetCurrencyCode;

@end
