//
//  THAboutTianhaoViewController.m
//  tianhao
//
//  Created by Jonear on 14-7-22.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import "THAboutTianhaoViewController.h"

@interface THAboutTianhaoViewController ()

@end

@implementation THAboutTianhaoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关于我们";
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
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)webButtonClick:(UIButton*)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:sender.titleLabel.text]];
}

@end
