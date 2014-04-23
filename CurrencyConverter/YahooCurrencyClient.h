//
//  YahooCurrencyClient.h
//  CurrencyConverter
//
//  Created by Anish Basu on 1/27/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "ExchangeRate.h"

typedef void(^YahooCurrencyResponse)(ExchangeRate *rates, BOOL fromCache, NSError *error);

@interface YahooCurrencyClient : AFHTTPSessionManager

+ (instancetype)client;
- (void)exchangeRatesFrom:(NSString *)sourceCurrency
					   to:(NSArray *)targetCurrencies
			 withResponse:(YahooCurrencyResponse)response;

@end
