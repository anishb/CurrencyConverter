//
//  CurrencyTableViewCell.h
//  CurrencyConverter
//
//  Created by Anish Basu on 1/28/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *flagImageView;
@property (nonatomic, weak) IBOutlet UILabel *currencyCode;
@property (nonatomic, weak) IBOutlet UILabel *currencyName;
@property (nonatomic, weak) IBOutlet UILabel *currencyAmount;

@end
