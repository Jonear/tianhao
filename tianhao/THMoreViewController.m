//
//  THMoreViewController.m
//  tianhao
//
//  Created by Jonear on 14-6-4.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import "THMoreViewController.h"
#import "THAboutViewController.h"
#import "THAboutTianhaoViewController.h"
#import "THAboutFilterViewController.h"

@interface THMoreViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation THMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"更多";
        
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_more_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_more"]];
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

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableViewCellIdentify = @"tableViewCellIdentify";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentify];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentify];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
    }
    
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"关于"];
    } else if (indexPath.row == 1) {
        [cell.textLabel setText:@"关于我们"];
    } else if (indexPath.row == 2) {
        [cell.textLabel setText:@"关于滤清器"];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    return cell;
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        THAboutViewController *aboutViewController = [[THAboutViewController alloc] initWithNibName:@"THAboutViewController" bundle:nil];
        [self.navigationController pushViewController:aboutViewController animated:YES];
    } else if (indexPath.row == 1) {
        THAboutTianhaoViewController *aboutTianhaoViewController = [[THAboutTianhaoViewController alloc] initWithNibName:@"THAboutTianhaoViewController" bundle:nil];
        [self.navigationController pushViewController:aboutTianhaoViewController animated:YES];
    } else if (indexPath.row == 2) {
        THAboutFilterViewController *aboutFilterViewController = [[THAboutFilterViewController alloc] initWithNibName:@"THAboutFilterViewController" bundle:nil];
        [self.navigationController pushViewController:aboutFilterViewController animated:YES];
    }
}

@end
