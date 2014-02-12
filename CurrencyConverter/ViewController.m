//
//  ViewController.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/27/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "ViewController.h"
#import "CurrencyManager.h"
#import "CurrencyPickerViewController.h"
#import "TargetCurrencyViewController.h"
#import "AppDelegate.h"

#define MAX_CHARACTERS 15
#define DEFAULTS_KEY_SOURCE_CURRENCY @"sourceCurrency"

@interface ViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate,
								CurrencyPickerViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UIView *sourceCurrencyView;
@property (nonatomic, weak) IBOutlet UILabel *sourceCurrencyCodeLabel;
@property (nonatomic, weak) IBOutlet UILabel *sourceCurrencyNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *sourceCurrencyFlagView;
@property (nonatomic, weak) IBOutlet UITextField *sourceCurrencyAmountField;
@property (nonatomic, strong) NSString *sourceCurrency;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
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
	
	// Set colors
	self.sourceCurrencyNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:14.0];
	self.view.backgroundColor = BACKGROUND_COLOR;
	self.sourceCurrencyView.backgroundColor = BACKGROUND_COLOR;
	self.navigationController.navigationBar.barTintColor = BACKGROUND_COLOR;
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	self.navigationController.navigationBar.translucent = NO;
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
												 forBarPosition:UIBarPositionAny
													 barMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar setShadowImage:[UIImage new]];
	self.sourceCurrencyAmountField.textColor = [UIColor whiteColor];
	
	
	// Setup source currency - Default to USD. Later retrieve from NSUserDefaults
	NSString *sourceCurrency = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_KEY_SOURCE_CURRENCY];
	if (sourceCurrency) {
		[self setupSourceCurrency:sourceCurrency];
	} else {
		[self setupSourceCurrency:@"USD"];
	}
	
	// Add + sign to nav bar
	TargetCurrencyViewController *tvc = (TargetCurrencyViewController *)[self.childViewControllers lastObject];
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																				   target:tvc
																				   action:@selector(addTargetCurrency)];
	self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)setupSourceCurrency:(NSString *)currencyCode
{
	// Save to preferences
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:currencyCode forKey:DEFAULTS_KEY_SOURCE_CURRENCY];
	[defaults synchronize];
	
	self.sourceCurrency = currencyCode;
	CurrencyManager *manager = [CurrencyManager default];
	self.sourceCurrencyCodeLabel.text = self.sourceCurrency;
	self.sourceCurrencyNameLabel.text = [manager nameForCurrency:self.sourceCurrency];
	self.sourceCurrencyFlagView.image = [manager imageForCountry:self.sourceCurrency];
	self.sourceCurrencyAmountField.text = [NSString stringWithFormat:@"%@ 0", [manager symbolForCurrency:self.sourceCurrency]];
	
	TargetCurrencyViewController *tvc = (TargetCurrencyViewController *)[self.childViewControllers lastObject];
	tvc.sourceCurrency = currencyCode;
	tvc.sourceAmount = 0;
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
	NSString *symbol = [[CurrencyManager default] symbolForCurrency:self.sourceCurrency];
	NSUInteger offset = [symbol length] + 2;
	NSMutableString *filtered = [[NSMutableString alloc] init];
	[filtered appendString:self.sourceCurrencyAmountField.text];
	
	// If length is less than offset, i.e., first digit was deleted, add back a 0
	if ([filtered length] == offset - 1) {
		[filtered appendString:@"0"];
	}
	
	// Remove 0 if it is the first character after offset and there is no decimal
	if ([filtered length] == (offset + 1) && [filtered characterAtIndex:offset - 1] == '0' &&
		[filtered rangeOfString:@"."].location == NSNotFound) {
		[filtered deleteCharactersInRange:NSMakeRange(offset - 1, 1)];
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
	
	TargetCurrencyViewController *tvc = (TargetCurrencyViewController *)[self.childViewControllers lastObject];
	tvc.sourceAmount = [self sourceAmount];
}

- (void)sourceCurrencyTapped:(UIGestureRecognizer *)gesture
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	CurrencyPickerViewController *pickerVC = (CurrencyPickerViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"CurrencyPickerView"];
	pickerVC.delegate = self;
	pickerVC.currencies = [[CurrencyManager default] allCurrencyCodes];
	[self presentViewController:pickerVC animated:YES completion:nil];
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

- (void)selectedCurrency:(NSString *)selectedCurrencyCode
{
	[self setupSourceCurrency:selectedCurrencyCode];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelled
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end
