//
//  ExchangeRateClient.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/29/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "ExchangeRateClient.h"

#define APP_ID @"199670ca739e4bafa1393b0a65d167d0"
#define BASE_URL @"http://openexchangerates.org"

@interface ExchangeRateClient()
@property (nonatomic, strong) RKObjectManager *objectManager;
@end

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

- (id)init
{
	self = [super init];
	if (self) {
		_objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:BASE_URL]];
	}
	return self;
}

- (void)fetchExchangeRatesWith:(ExchangeRateResponse)response
{
	RKObjectRequestOperation *operation = [self requestOperation];
	[operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		ExchangeRate *rates = [[mappingResult array] firstObject];
		response(rates, nil);
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		response(nil, error);
	}];
	[self.objectManager enqueueObjectRequestOperation:operation];
}

- (RKObjectRequestOperation *)requestOperation
{
	// Create request
	NSString *urlString = [NSString stringWithFormat:@"%@/api/latest.json?app_id=%@", BASE_URL, APP_ID];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60];
	
	// Create response descriptors
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ExchangeRate class]];
	[mapping addAttributeMappingsFromDictionary:@{
												  @"timestamp": @"timestamp",
												  @"base": @"baseCurrencyCode",
												  @"rates": @"rates"
												  }];
	NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
																							method:RKRequestMethodGET
																					   pathPattern:@"/api/latest.json"
																						   keyPath:nil
																					   statusCodes:statusCodes];
	
	// Create operation
	RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
																		responseDescriptors:@[responseDescriptor]];
	return operation;
}

@end
