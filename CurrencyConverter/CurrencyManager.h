//
//  CurrencyManager.h
//  CurrencyConverter
//
//  Created by Anish Basu on 1/28/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyManager : NSObject

/** Singleton */
+ (instancetype)default;

/** Returns array of all currency codes as NSStrings */
- (NSArray *)allCurrencySymbols;

- (UIImage *)imageForCountry:(NSString *)currencyCode;
- (NSString *)nameForCurrency:(NSString *)currencyCode;
- (NSString *)symbolForCurrency:(NSString *)currencyCode;

@end
