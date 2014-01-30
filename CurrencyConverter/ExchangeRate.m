//
//  ExchangeRate.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/29/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "ExchangeRate.h"

@implementation ExchangeRate

- (NSDate *)lastUpdated
{
	return [NSDate dateWithTimeIntervalSince1970:[self.timestamp doubleValue]];
}

- (double)rateFrom:(NSString *)baseCurrencyCode
				to:(NSString *)targetCurrencyCode
{
	// If base and target currencies are the same, return 1
	if ([baseCurrencyCode isEqualToString:targetCurrencyCode]) {
		return 1;
	}
	
	// If base currency is USD, no conversions have to be done
	if ([baseCurrencyCode isEqualToString:@"USD"]) {
		return [[self.rates objectForKey:targetCurrencyCode] doubleValue];
	}
	
	// Otherwise get USD to base rate and then multipy by target to USD rate
	NSLog(@"In terms of dollars = %f", 1.0 / [[self.rates objectForKey:baseCurrencyCode] doubleValue]);
	NSLog(@"Target currency rate = %f", [[self.rates objectForKey:targetCurrencyCode] doubleValue]);
	return (1.0 / [[self.rates objectForKey:baseCurrencyCode] doubleValue]) *
		[[self.rates objectForKey:targetCurrencyCode] doubleValue];
}

@end
