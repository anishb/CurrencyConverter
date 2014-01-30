//
//  ExchangeAPITest.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/29/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ExchangeRateClient.h"

@interface ExchangeAPITest : XCTestCase

@end

@implementation ExchangeAPITest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testExchangeRateRequestOperation
{
	RKObjectRequestOperation *requestOperation = [[ExchangeRateClient default] requestOperation];
	[requestOperation start];
	[requestOperation waitUntilFinished];
	XCTAssert(requestOperation.HTTPRequestOperation.response.statusCode == 200, @"Expected 200 response");
	XCTAssert([requestOperation.mappingResult count] == 1, @"Expected to load one ExchangeRate object");
	ExchangeRate *exchangeRates = [[requestOperation.mappingResult array] firstObject];
	XCTAssert([exchangeRates.baseCurrencyCode isEqualToString:@"USD"], @"Base currency should be USD");
	XCTAssert([[exchangeRates.rates allKeys] count] > 0, @"Exchange rates not returned");
}

@end
