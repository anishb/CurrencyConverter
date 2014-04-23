//
//  TargetCurrencyViewController.m
//  CurrencyConverter
//
//  Created by Anish Basu on 2/10/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "TargetCurrencyViewController.h"
#import "CurrencyTableViewCell.h"
#import "CurrencyManager.h"
#import "YahooCurrencyClient.h"
#import "CurrencyPickerViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"

#define DEFAULTS_KEY_TARGET_CURRENCIES @"targetCurrencies"

@interface TargetCurrencyViewController () <CurrencyPickerViewControllerDelegate>
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *targetCurrencies;
@property (nonatomic, strong) ExchangeRate *rates;
@property (nonatomic) BOOL updating;
@property (nonatomic, strong) UIActivityIndicatorView *loadingSpinner;
@end

@implementation TargetCurrencyViewController

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
	
	// Set table view background color
	self.tableView.backgroundColor = BACKGROUND_COLOR;
	
	// Setup target currencies
	self.targetCurrencies = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_KEY_TARGET_CURRENCIES];
	if (!self.targetCurrencies) {
		self.targetCurrencies = [[NSMutableArray alloc] init];
	}
	
	// Add pull to refresh
	self.refreshControl = [[UIRefreshControl alloc] init];
	self.refreshControl.tintColor = [UIColor whiteColor];
	[self.refreshControl addTarget:self
							action:@selector(updateExchangeRates)
				  forControlEvents:UIControlEventValueChanged];

	// Update currency exchange rates
	[self updateExchangeRates];
	
	// Show spinner until rates are retrieved for the first time
	[self showSpinner];
}

- (void)showSpinner
{
	self.loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

	self.loadingSpinner.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 50,
										   50,
										   100,
										   100);
	[self.view addSubview:self.loadingSpinner];
	[self.loadingSpinner startAnimating];
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)hideSpinner
{
	[self.loadingSpinner removeFromSuperview];
	self.loadingSpinner = nil;
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSourceCurrency:(NSString *)sourceCurrency
{
	_sourceCurrency = sourceCurrency;
	[self.tableView reloadData];
}

- (void)setSourceAmount:(double)sourceAmount
{
	_sourceAmount = sourceAmount;
	[self.tableView reloadData];
}

- (void)persistTargetCurrencies
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:self.targetCurrencies forKey:DEFAULTS_KEY_TARGET_CURRENCIES];
	[defaults synchronize];
}

- (void)addTargetCurrency
{
	NSMutableArray *currencies = [[NSMutableArray alloc] init];
	[currencies addObjectsFromArray:[[CurrencyManager default] allCurrencyCodes]];
	[currencies removeObjectsInArray:self.targetCurrencies];
	[currencies removeObject:self.sourceCurrency];
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	CurrencyPickerViewController *pickerVC = (CurrencyPickerViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"CurrencyPickerView"];
	pickerVC.delegate = self;
	pickerVC.currencies = currencies;
	
	[self presentViewController:pickerVC animated:YES completion:nil];
}

- (void)updateExchangeRates
{
	if (!self.updating) {
		self.updating = YES;
		__weak TargetCurrencyViewController *weakSelf = self;
		[[YahooCurrencyClient client] exchangeRatesFrom:@"USD"
													 to:[[CurrencyManager default] allCurrencyCodes]
										   withResponse:^(ExchangeRate *rates, BOOL fromCache, NSError *error) {
											   if (error) {
												   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Exchange rate retreival failed"
																									   message:[error localizedDescription]
																									  delegate:nil
																							 cancelButtonTitle:@"OK"
																							 otherButtonTitles:nil];
												   [alertView show];
											   }
											   if (weakSelf.refreshControl.refreshing) {
												   [weakSelf.refreshControl endRefreshing];
											   }
											   ViewController *parentController = (ViewController *)self.parentViewController;
											   if (rates) {
												   weakSelf.rates = rates;
												   [parentController updateLastUpdatedLabel:rates.lastUpdated
																				   animated:!fromCache];
												   [weakSelf.tableView reloadData];
											   } else {
												   [parentController updateLastUpdatedLabel:nil
																				   animated:YES];
											   }
											   weakSelf.updating = NO;
											   if (self.loadingSpinner) {
												   [weakSelf hideSpinner];
												}
											}];
	}
}

#pragma mark - Table view data source

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
	cell.backgroundColor = BACKGROUND_COLOR;
	cell.currencyName.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:14.0];
	
	CurrencyManager *manager = [CurrencyManager default];
	NSString *countryCode = [self.targetCurrencies objectAtIndex:indexPath.row];
	cell.currencyCode.text = countryCode;
	cell.flagImageView.image = [manager imageForCountry:countryCode];
	cell.currencyName.text = [manager nameForCurrency:countryCode];
	double exchangeRate = [self.rates rateFrom:self.sourceCurrency to:countryCode];
	double sourceAmount = [self sourceAmount];
	double targetAmount = sourceAmount * exchangeRate;
	cell.currencyAmount.text = [NSString stringWithFormat:@"%@ %.02f", [manager symbolForCurrency:countryCode], targetAmount];
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Remove target currency
		[self.targetCurrencies removeObjectAtIndex:indexPath.row];
		[self persistTargetCurrencies];
		[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - CurrencyPickerViewControllerDelegate

- (void)selectedCurrency:(NSString *)selectedCurrencyCode
{
	[self.targetCurrencies addObject:selectedCurrencyCode];
	[self persistTargetCurrencies];
	[self.tableView reloadData];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelled
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end
