//
//  ExchangeRate.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/29/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "ExchangeRate.h"

@implementation ExchangeRate

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
	return (1.0 / [[self.rates objectForKey:baseCurrencyCode] doubleValue]) *
		[[self.rates objectForKey:targetCurrencyCode] doubleValue];
}

@end
