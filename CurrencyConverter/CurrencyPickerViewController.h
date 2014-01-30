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
@end

@interface CurrencyPickerViewController : UITableViewController

/** Array of NSString currency codes */
@property (nonatomic, strong) NSArray *currencies;

@property (nonatomic, weak) id<CurrencyPickerViewControllerDelegate> delegate;

@end
