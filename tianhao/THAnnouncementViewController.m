//
//  THAnnouncementViewController.m
//  tianhao
//
//  Created by Jonear on 14-7-22.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import "THAnnouncementViewController.h"
#import "THAnnouncement.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIView+Sizes.h"

@interface THAnnouncementViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation THAnnouncementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = _announcement.title;
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@", THImageUrl, _announcement.iconUrl];
    [_imageView setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"DefaultImage"] options:SDWebImageRetryFailed];
    
    [_detailLabel setText:_announcement.content];
    [_detailLabel sizeToFit];
    
    [_dateTimeLabel setText:_announcement.createDate];
    
    [_scrollView setContentSize:CGSizeMake(320, _imageView.height+_detailLabel.height+_dateTimeLabel.height+50)];
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

@end
