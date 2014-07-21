//
//  THProductViewController.m
//  tianhao
//
//  Created by Jonear on 14-6-4.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import "THProductViewController.h"

@interface THProductViewController ()

@end

@implementation THProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"产品";
        
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_product_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_product"]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.title = self.title;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
