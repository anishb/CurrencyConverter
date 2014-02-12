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
#import "AppDelegate.h"

@interface CurrencyPickerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@end

@implementation CurrencyPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// To remove hairline
	self.toolbar.clipsToBounds = YES;
	
	// Set colors
	self.toolbar.backgroundColor = ORANGE_COLOR;
	self.view.backgroundColor = ORANGE_COLOR;
	self.tableView.backgroundColor = ORANGE_COLOR;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelPressed:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(cancelled)]) {
		[self.delegate cancelled];
	}
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
	cell.backgroundColor = ORANGE_COLOR;
	cell.currencyNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:14.0];
	
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
