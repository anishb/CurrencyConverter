//
//  YahooCurrencyClient.h
//  CurrencyConverter
//
//  Created by Anish Basu on 1/27/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void(^YahooCurrencyResponse)(NSDictionary *result, NSError *error);

@interface YahooCurrencyClient : AFHTTPSessionManager

+ (instancetype)client;
- (void)exchangeRatesFrom:(NSString *)sourceCurrency
					   to:(NSArray *)targetCurrencies
			 withResponse:(YahooCurrencyResponse)response;

@end
