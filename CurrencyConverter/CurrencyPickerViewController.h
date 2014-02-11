//
//  CurrencyPickerViewController.h
//  CurrencyConverter
//
//  Created by Anish Basu on 1/30/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CurrencyPickerViewControllerDelegate <NSObject>
- (void)selectedCurrency:(NSString *)selectedCurrencyCode;
- (void)cancelled;
@end

@interface CurrencyPickerViewController : UIViewController

/** Array of NSString currency codes */
@property (nonatomic, strong) NSArray *currencies;
/** Delegate */
@property (nonatomic, weak) id<CurrencyPickerViewControllerDelegate> delegate;

@end
