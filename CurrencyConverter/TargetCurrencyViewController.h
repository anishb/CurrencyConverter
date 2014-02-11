//
//  TargetCurrencyViewController.h
//  CurrencyConverter
//
//  Created by Anish Basu on 2/10/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetCurrencyViewController : UITableViewController

@property (nonatomic, copy) NSString *sourceCurrency;
@property (nonatomic) double sourceAmount;

- (void)addTargetCurrency;

@end
