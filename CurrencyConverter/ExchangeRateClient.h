//
//  ExchangeRateClient.h
//  CurrencyConverter
//
//  Created by Anish Basu on 1/29/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "ExchangeRate.h"

typedef void(^ExchangeRateResponse)(ExchangeRate *rates, NSError *error);

@interface ExchangeRateClient : NSObject

+ (instancetype)default;
- (void)fetchExchangeRatesWith:(ExchangeRateResponse)response;
- (RKObjectRequestOperation *)requestOperation;

@end
