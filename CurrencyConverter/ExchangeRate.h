//
//  ExchangeRate.h
//  CurrencyConverter
//
//  Created by Anish Basu on 1/29/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeRate : NSObject <NSCoding>

@property (nonatomic, copy) NSString *baseCurrencyCode;
@property (nonatomic, copy) NSDictionary *rates;
@property (nonatomic, copy) NSDate *lastUpdated;

+ (ExchangeRate *)load;
- (BOOL)save;
- (BOOL)isStale;
- (double)rateFrom:(NSString *)baseCurrencyCode
				to:(NSString *)targetCurrencyCode;


@end
