//
//  YahooCurrencyClient.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/27/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "YahooCurrencyClient.h"

#define BASE_URL @"http://query.yahooapis.com"

@implementation YahooCurrencyClient

+ (instancetype)client
{
	static YahooCurrencyClient *_client = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
		_client = [[YahooCurrencyClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]
										  sessionConfiguration:sessionConfig];
	});
	return _client;
}

- (void)exchangeRatesFrom:(NSString *)sourceCurrency
					   to:(NSArray *)targetCurrencies
			 withResponse:(YahooCurrencyResponse)response
{
	NSUInteger numTargets = [targetCurrencies count];
	NSMutableString *query = [[NSMutableString alloc] init];
	[query appendString:@"select * from yahoo.finance.xchange where pair in ("];
	for (int i = 0; i < numTargets; i++) {
		if (i == numTargets - 1) {
			[query appendFormat:@"\"%@%@\"", sourceCurrency, [targetCurrencies objectAtIndex:i]];
		} else {
			[query appendFormat:@"\"%@%@\",", sourceCurrency, [targetCurrencies objectAtIndex:i]];
		}
	}
	[query appendString:@")"];
	NSDictionary *params = @{@"q": query,
							 @"format": @"json",
							 @"env": @"store://datatables.org/alltableswithkeys"};
	[self GET:@"/v1/public/yql"
   parameters:params
	  success:^(NSURLSessionDataTask *task, id responseObject) {
		  NSDictionary *query = [responseObject objectForKey:@"query"];
		  NSDictionary *results = [query objectForKey:@"results"];
		  NSArray *rates = [results objectForKey:@"rate"];
		  NSMutableDictionary *exchanges = [[NSMutableDictionary alloc] initWithCapacity:[rates count]];
		  for (NSDictionary *rate in rates) {
			  NSString *name = [rate objectForKey:@"Name"];
			  NSString *currency = [[name componentsSeparatedByString:@" "] lastObject];
			  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			  [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
			  NSNumber *exchange = [formatter numberFromString:[rate objectForKey:@"Rate"]];
			  [exchanges setObject:exchange forKey:currency];
		  }
		  ExchangeRate *exchangeRate = [[ExchangeRate alloc] init];
		  exchangeRate.baseCurrencyCode = sourceCurrency;
		  exchangeRate.rates = exchanges;
		  response(exchangeRate, nil);
	  } failure:^(NSURLSessionDataTask *task, NSError *error) {
		  response(nil, error);
	  }];
}

@end
