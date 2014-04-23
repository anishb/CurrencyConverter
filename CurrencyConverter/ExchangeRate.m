//
//  ExchangeRate.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/29/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "ExchangeRate.h"

int const kExchangeRateTTL = 60; // 60s or 1min
NSString *const kKeyBaseCurencyCode = @"baseCurrencyCode";
NSString *const kKeyRates = @"rates";
NSString *const kKeyLastUpdated = @"lastUpdated";

@implementation ExchangeRate

+ (ExchangeRate *)load;
{
	ExchangeRate *rate = [NSKeyedUnarchiver unarchiveObjectWithFile:[ExchangeRate filePath]];
	return rate;
}

- (BOOL)save
{
	BOOL result = [NSKeyedArchiver archiveRootObject:self toFile:[ExchangeRate filePath]];
	return result;
}

+ (NSString *)filePath
{
	NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [docsPath stringByAppendingPathComponent:@"rates"];
	return filePath;
}

- (BOOL)isStale
{
	if (nil == self.lastUpdated) {
		return YES;
	}
	NSTimeInterval lapsedTime = fabs([self.lastUpdated timeIntervalSinceNow]);
	if (lapsedTime > kExchangeRateTTL) {
		return YES;
	}
	
	return NO;
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
	return (1.0 / [[self.rates objectForKey:baseCurrencyCode] doubleValue]) *
		[[self.rates objectForKey:targetCurrencyCode] doubleValue];
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self) {
		self.baseCurrencyCode = [aDecoder decodeObjectForKey:kKeyBaseCurencyCode];
		self.rates = [aDecoder decodeObjectForKey:kKeyRates];
		self.lastUpdated = [aDecoder decodeObjectForKey:kKeyLastUpdated];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.baseCurrencyCode forKey:kKeyBaseCurencyCode];
	[aCoder encodeObject:self.rates forKey:kKeyRates];
	[aCoder encodeObject:self.lastUpdated forKey:kKeyLastUpdated];
}

@end
