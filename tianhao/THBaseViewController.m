//
//  THBaseViewController.m
//  tianhao
//
//  Created by Jonear on 14-6-4.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import "THBaseViewController.h"

@interface THBaseViewController ()

@end

@implementation THBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor whiteColor], UITextAttributeTextColor,
                                                 color_with_rgb(37, 43, 52), UITextAttributeTextShadowColor,
                                                 [NSValue valueWithCGSize:CGSizeMake(1, 1)],UITextAttributeTextShadowOffset,
                                                 nil] forState:UIControlStateSelected];
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 color_with_rgb(115, 131, 147), UITextAttributeTextColor,
                                                 color_with_rgb(37, 43, 52), UITextAttributeTextShadowColor,
                                                 [NSValue valueWithCGSize:CGSizeMake(1, 1)],UITextAttributeTextShadowOffset,
                                                 nil] forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
