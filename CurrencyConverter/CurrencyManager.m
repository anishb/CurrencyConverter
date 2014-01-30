//
//  CurrencyManager.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/28/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "CurrencyManager.h"

@interface CurrencyManager()
@property (nonatomic, strong) NSDictionary *currencies;
@end

@implementation CurrencyManager

+ (instancetype)default
{
	static CurrencyManager *_manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_manager = [[CurrencyManager alloc] init];
	});
	return _manager;
}

- (id)init
{
	self = [super init];
	if (self) {
		NSString *plist = [[NSBundle mainBundle] pathForResource:@"Currencies" ofType:@"plist"];
		self.currencies = [NSDictionary dictionaryWithContentsOfFile:plist];
	}
	return self;
}

- (NSArray *)allCurrencyCodes
{
	return [self.currencies allKeys];
}

- (UIImage *)imageForCountry:(NSString *)currencyCode
{
	UIImage *flag;
	NSDictionary *info = [self.currencies objectForKey:currencyCode];
	NSString *imageName = [info objectForKey:@"flag"];
	if (imageName) {
		flag = [UIImage imageNamed:imageName];
	}
	return flag;
}

- (NSString *)nameForCurrency:(NSString *)currencyCode
{
	NSDictionary *info = [self.currencies objectForKey:currencyCode];
	return [info objectForKey:@"name"];
}

- (NSString *)symbolForCurrency:(NSString *)currencyCode
{
	NSDictionary *info = [self.currencies objectForKey:currencyCode];
	return [info objectForKey:@"symbol"];
}


@end
