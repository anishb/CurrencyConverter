//
//  CurrencyPickerViewController.h
//  CurrencyConverter
//
//  Created by Anish Basu on 1/30/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	CurrencyTypeSource,
	CurrencyTypeTarget
} CurrencyType;

@protocol CurrencyPickerViewControllerDelegate <NSObject>
- (void)selectedCurrency:(NSString *)selectedCurrencyCode
				 forType:(CurrencyType)type;
@end

@interface CurrencyPickerViewController : UITableViewController

/** Array of NSString currency codes */
@property (nonatomic, strong) NSArray *currencies;

@property (nonatomic) CurrencyType type;
@property (nonatomic, weak) id<CurrencyPickerViewControllerDelegate> delegate;

@end
