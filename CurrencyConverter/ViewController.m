//
//  ViewController.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/27/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "ViewController.h"
#import "YahooCurrencyClient.h"
#import "CurrencyManager.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *sourceCurrency;
@property (nonatomic, strong) NSMutableArray *targetCurrencies;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.sourceCurrency = @"USD";
	self.targetCurrencies = [[NSMutableArray alloc] init];
	[self.targetCurrencies addObject:@"INR"];
	[self.targetCurrencies addObject:@"JPY"];
	
	[[YahooCurrencyClient client] exchangeRatesFrom:@"USD"
												 to:@[@"INR", @"JPY"]
									   withResponse:^(NSDictionary *result, NSError *error) {
										   if (error) {
											   NSLog(@"%@", [error localizedDescription]);
										   }
									   }];
	[CurrencyManager default];
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
	/*
	if (section == 0) {
		return 1;
	}
	 */
	return [self.targetCurrencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"CurrencyCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
															forIndexPath:indexPath];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									  reuseIdentifier:cellIdentifier];
	}
	//if (indexPath.section == 0) {
	//	cell.textLabel.text = @"USD";
	//} else {
		cell.textLabel.text = [self.targetCurrencies objectAtIndex:indexPath.row];
	//}

	return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Target currencies";
}





#pragma mark - UITableViewDelegate

@end
