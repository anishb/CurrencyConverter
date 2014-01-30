//
//  CurrencyPickerViewController.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/30/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "CurrencyPickerViewController.h"
#import "CurrencyTypeCell.h"
#import "CurrencyManager.h"

@interface CurrencyPickerViewController ()

@end

@implementation CurrencyPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.currencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CurrencyTypeCell";
    CurrencyTypeCell *cell = (CurrencyTypeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier
																				 forIndexPath:indexPath];
    CurrencyManager *manager = [CurrencyManager default];
	NSString *currencyCode = [self.currencies objectAtIndex:indexPath.row];
	cell.flagImageView.image = [manager imageForCountry:currencyCode];
	cell.currencyCodeLabel.text = currencyCode;
	cell.currencyNameLabel.text = [manager nameForCurrency:currencyCode];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *currencyCode = [self.currencies objectAtIndex:indexPath.row];
	if ([self.delegate respondsToSelector:@selector(selectedCurrency:)]) {
		[self.delegate selectedCurrency:currencyCode];
	}
}

@end
