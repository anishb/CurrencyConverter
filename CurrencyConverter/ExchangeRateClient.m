//
//  ExchangeRateClient.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/29/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "ExchangeRateClient.h"

#define APP_ID @"199670ca739e4bafa1393b0a65d167d0"

@implementation ExchangeRateClient

+ (instancetype)default
{
	static ExchangeRateClient *_manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_manager = [[ExchangeRateClient alloc] init];
	});
	
	return  _manager;
}

- (void)fetchExchangeRatesWith:(ExchangeRateResponse)response
{
	RKObjectRequestOperation *operation = [self requestOperation];
	[operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
		ExchangeRate *rates = [[result array] firstObject];
		response(rates, nil);
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		response(nil, error);
	}];
	[operation start];
}

- (RKObjectRequestOperation *)requestOperation
{
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ExchangeRate class]];
	[mapping addAttributeMappingsFromDictionary:@{
												  @"timestamp": @"timestamp",
												  @"base": @"baseCurrencyCode",
												  @"rates": @"rates"
												  }];
	NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
																							method:RKRequestMethodAny
																					   pathPattern:nil
																						   keyPath:nil
																					   statusCodes:statusCodes];
	NSString *urlString = [NSString stringWithFormat:@"https://openexchangerates.org/api/latest.json?app_id=%@", APP_ID];
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
																		responseDescriptors:@[responseDescriptor]];
	
	return operation;
}

@end
