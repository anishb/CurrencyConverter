//
//  ViewController.m
//  CurrencyConverter
//
//  Created by Anish Basu on 1/27/14.
//  Copyright (c) 2014 Anish Basu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	NSString *url = @"http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.xchange where pair in (\"USDMXN\", \"USDCHF\")&format=json&env=store://datatables.org/alltableswithkeys";
	NSLog(@"URL = %@", url);
	NSLog(@"Encoded URL = %@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
