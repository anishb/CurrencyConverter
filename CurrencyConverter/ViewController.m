//
//  ViewController.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/27/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "ViewController.h"
#import "YahooCurrencyClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.	
	[[YahooCurrencyClient client] exchangeRatesFrom:@"USD"
												 to:@[@"INR", @"JPY"]
									   withResponse:^(NSDictionary *result, NSError *error) {
										   if (error) {
											   NSLog(@"%@", [error localizedDescription]);
										   }
									   }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
