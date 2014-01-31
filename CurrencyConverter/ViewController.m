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
#import "ExchangeRateClient.h"
#import "CurrencyPickerViewController.h"

#define MAX_CHARACTERS 15

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,
							UIGestureRecognizerDelegate, CurrencyPickerViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UIView *sourceCurrencyView;
@property (nonatomic, weak) IBOutlet UILabel *sourceCurrencyCodeLabel;
@property (nonatomic, weak) IBOutlet UILabel *sourceCurrencyNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *sourceCurrencyFlagView;
@property (nonatomic, weak) IBOutlet UITextField *sourceCurrencyAmountField;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *sourceCurrency;
@property (nonatomic, strong) NSMutableArray *targetCurrencies;
@property (nonatomic, strong) ExchangeRate *rates;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
	
	// Do any additional setup after loading the view, typically from a nib.
	self.sourceCurrencyAmountField.keyboardType = UIKeyboardTypeDecimalPad;
	
	// Add tap gesture recognizer to source currency
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
																				 action:@selector(sourceCurrencyTapped:)];
	[self.sourceCurrencyFlagView addGestureRecognizer:tapGesture];
	UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self
																				  action:@selector(sourceCurrencyTapped:)];
	[self.sourceCurrencyCodeLabel addGestureRecognizer:tapGesture2];
	UITapGestureRecognizer *tapRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self
																				 action:@selector(editSourceCurrency:)];
	[self.sourceCurrencyView addGestureRecognizer:tapRecognizer3];
	
	
	// Setup source currency - Default to USD. Later retrieve from NSUserDefaults
	[self setupSourceCurrency:@"USD"];
	
	// Setup target currencies
	//TODO: Use NSUserDefaults to remember target currencies set
	self.targetCurrencies = [[NSMutableArray alloc] init];
	
	// Add + sign to nav bar
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTargetCurrency)];
	self.navigationItem.rightBarButtonItem = barButtonItem;
	
	[self updateExchangeRates];
}

- (void)setupSourceCurrency:(NSString *)currencyCode
{
	self.sourceCurrency = currencyCode;
	CurrencyManager *manager = [CurrencyManager default];
	self.sourceCurrencyCodeLabel.text = self.sourceCurrency;
	self.sourceCurrencyNameLabel.text = [manager nameForCurrency:self.sourceCurrency];
	self.sourceCurrencyFlagView.image = [manager imageForCountry:self.sourceCurrency];
	self.sourceCurrencyAmountField.text = [NSString stringWithFormat:@"%@ 0", [manager symbolForCurrency:self.sourceCurrency]];
	[self.tableView reloadData];
}

- (void)updateExchangeRates
{
	__weak ViewController *weakSelf = self;
	[[ExchangeRateClient default] fetchExchangeRatesWith:^(ExchangeRate *rates, NSError *error) {
		if (error) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Exchange rate retreival failed"
																message:[error localizedDescription]
															   delegate:nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
			[alertView show];
		} else {
			weakSelf.rates = rates;
			[self.tableView reloadData];
		}
	}];
}

- (double)sourceAmount
{
	NSMutableString *strippedString = [NSMutableString
									   stringWithCapacity:self.sourceCurrencyAmountField.text.length];
	NSScanner *scanner = [NSScanner scannerWithString:self.sourceCurrencyAmountField.text];
	NSCharacterSet *numbers = [NSCharacterSet
							   characterSetWithCharactersInString:@"0123456789."];
	while (![scanner isAtEnd]) {
		NSString *buffer;
		if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
			[strippedString appendString:buffer];
		} else {
			[scanner setScanLocation:([scanner scanLocation] + 1)];
		}
	}
	
	return [strippedString doubleValue];
}

- (IBAction)sourceChanged:(id)sender
{
	NSMutableString *filtered = [[NSMutableString alloc] init];
	[filtered appendString:self.sourceCurrencyAmountField.text];
	
	// If length is less than 3, set to 0
	if ([filtered length] == 2) {
		[filtered appendString:@"0"];
	}
	
	// Remove 0 if it is the fourth character and there is no decimal
	if ([filtered length] == 4 && [filtered characterAtIndex:2] == '0' &&
		[filtered rangeOfString:@"."].location == NSNotFound) {
		[filtered deleteCharactersInRange:NSMakeRange(2, 1)];
	}
	
	// If last character is a decimal and decimal already exists, remove it
	if ([filtered characterAtIndex:([filtered length] - 1)] == '.' &&
		[filtered rangeOfString:@"."].location != ([filtered length] - 1)) {
		[filtered deleteCharactersInRange:NSMakeRange([filtered length] - 1, 1)];
	}
	
	// If max number of characters hit, remove last character entered
	if ([filtered length] > MAX_CHARACTERS) {
		[filtered deleteCharactersInRange:NSMakeRange([filtered length] - 1, 1)];
	}
	
	self.sourceCurrencyAmountField.text = filtered;
	
	[self.tableView reloadData];
}

- (void)sourceCurrencyTapped:(UIGestureRecognizer *)gesture
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	CurrencyPickerViewController *pickerVC = (CurrencyPickerViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"CurrencyPickerView"];
	pickerVC.delegate = self;
	pickerVC.currencies = [[CurrencyManager default] allCurrencyCodes];
	pickerVC.type = CurrencyTypeSource;
	[self presentViewController:pickerVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewTapped:(UIGestureRecognizer *)gesture
{
	[self.view removeGestureRecognizer:gesture];
	[self.view endEditing:NO];
}

- (void)editSourceCurrency:(UIGestureRecognizer *)gesture
{
	[self.sourceCurrencyAmountField becomeFirstResponder];
}

- (void)addTargetCurrency
{
	NSMutableArray *currencies = [[NSMutableArray alloc] init];
	[currencies addObjectsFromArray:[[CurrencyManager default] allCurrencyCodes]];
	[currencies removeObjectsInArray:self.targetCurrencies];
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	CurrencyPickerViewController *pickerVC = (CurrencyPickerViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"CurrencyPickerView"];
	pickerVC.delegate = self;
	pickerVC.currencies = currencies;
	pickerVC.type = CurrencyTypeTarget;

	[self presentViewController:pickerVC animated:YES completion:nil];
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
		[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDelegate



#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
																				 action:@selector(viewTapped:)];
	tapGesture.delegate = self;
	[self.view addGestureRecognizer:tapGesture];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	
}

#pragma mark - CurrencyPickerViewControllerDelegate

- (void)selectedCurrency:(NSString *)selectedCurrencyCode forType:(CurrencyType)type
{
	if (type == CurrencyTypeSource) {
		[self setupSourceCurrency:selectedCurrencyCode];
	} else {
		[self.targetCurrencies addObject:selectedCurrencyCode];
		[self.tableView reloadData];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelled
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end
