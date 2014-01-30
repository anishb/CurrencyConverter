//
//  ViewController.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/27/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "ViewController.h"
#import "CurrencyManager.h"
#import "CurrencyTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel *sourceCurrencyCodeLabel;
@property (nonatomic, weak) IBOutlet UILabel *sourceCurrencyNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *sourceCurrencyFlagView;
@property (nonatomic, weak) IBOutlet UITextField *sourceCurrencyAmountField;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *sourceCurrency;
@property (nonatomic, strong) NSMutableArray *targetCurrencies;
@property (nonatomic, strong) NSDictionary *targetAmounts;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	// Setup source currency
	//TODO: Check NSUserDefaults here
	[self setupSourceCurrency:@"USD"];
	
	// Setup target currencies
	//TODO: Use NSUserDefaults to remember target currencies set
	//		If key not present in NSUserDefaults set a random currency
	self.targetCurrencies = [NSMutableArray arrayWithArray:[[CurrencyManager default] allCurrencySymbols]];
}

- (void)setupSourceCurrency:(NSString *)currencyCode
{
	self.sourceCurrency = @"USD";
	CurrencyManager *manager = [CurrencyManager default];
	self.sourceCurrencyCodeLabel.text = self.sourceCurrency;
	self.sourceCurrencyNameLabel.text = [manager nameForCurrency:self.sourceCurrency];
	self.sourceCurrencyFlagView.image = [manager imageForCountry:self.sourceCurrency];
	self.sourceCurrencyAmountField.text = [NSString stringWithFormat:@"%@0",
										   [manager symbolForCurrency:self.sourceCurrency]];
	[self updateExchangeRates];
}

- (void)updateExchangeRates
{
	__weak ViewController *weakSelf = self;
	/*
	[[YahooCurrencyClient client] exchangeRatesFrom:self.sourceCurrency
												 to:[[CurrencyManager default] allCurrencySymbols]
													 withResponse:^(NSDictionary *result, NSError *error) {
		if (error) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Exchange rate retreival failed"
																message:[error localizedDescription]
															   delegate:nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
			[alertView show];
		} else {
			weakSelf.targetAmounts = result;
			[weakSelf.tableView reloadData];
		}
	}];
	 */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return [self.targetCurrencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"CurrencyCell";
	CurrencyTableViewCell *cell = (CurrencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier
																						   forIndexPath:indexPath];
	if (cell == nil) {
		cell = [[CurrencyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
											reuseIdentifier:cellIdentifier];
	}

	CurrencyManager *manager = [CurrencyManager default];
	NSString *countryCode = [self.targetCurrencies objectAtIndex:indexPath.row];
	cell.currencyCode.text = countryCode;
	cell.flagImageView.image = [manager imageForCountry:countryCode];
	cell.currencyName.text = [manager nameForCurrency:countryCode];
	NSString *amount;
	
	//cell.currencyAmount.text =

	return cell;
}




#pragma mark - UITableViewDelegate

@end
