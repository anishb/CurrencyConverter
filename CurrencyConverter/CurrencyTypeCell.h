//
//  CurrencyTypeCell.h
//  CurrencyConverter
//
//  Created by Anish Basu on 1/30/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyTypeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *flagImageView;
@property (nonatomic, weak) IBOutlet UILabel *currencyCodeLabel;
@property (nonatomic, weak) IBOutlet UILabel *currencyNameLabel;

@end
