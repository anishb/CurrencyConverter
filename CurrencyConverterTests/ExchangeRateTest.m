//
//  ExchangeRateTest.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/29/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ExchangeRate.h"

@interface ExchangeRateTest : XCTestCase
@property (nonatomic, strong) ExchangeRate *rates;
@end

@implementation ExchangeRateTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
	self.rates = [[ExchangeRate alloc] init];
	self.rates.baseCurrencyCode = @"USD";
	self.rates.rates = @{
						 @"AED": @"3.672754",
						 @"AFN": @"56.551375",
						 @"ALL": @"102.8772",
						 @"AMD": @"407.87",
						 @"ANG": @"1.78886",
						 @"AOA": @"97.612275",
						 @"ARS": @"7.995411"
						 };
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testExchangeRates
{
	// First test for case from USD to target currency
	XCTAssert([self.rates rateFrom:@"USD" to:@"AFN"] == 56.551375, @"Conversion from USD to AFN is not correct");
	// Now test going from non USD currency to another currency
	XCTAssert([self.rates rateFrom:@"ALL" to:@"AMD"] == 3.964629674991155, @"Conversion from ALL to AMD is not correct");
	// Finally test doing same currency
	XCTAssert([self.rates rateFrom:@"USD" to:@"USD"] == 1, @"Conversion to same currency should be 1");
}


@end
