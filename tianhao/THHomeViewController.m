//
//  THHomeViewController.m
//  tianhao
//
//  Created by Jonear on 14-6-4.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import "THHomeViewController.h"

#import "UIView+Sizes.h"
#import "THCommonTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

#import "THAnnouncementModel.h"
#import "THAnnouncement.h"
#import "THProductModel.h"
#import "THProduct.h"

#import "THAnnouncementViewController.h"
#import "THProductDetailViewController.h"

#import "SVSegmentedControl.h"

@interface THHomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation THHomeViewController
{
    NSMutableArray *_announcementData;
    int _minAnnouncementID;
    
    NSMutableArray *_recommendData;
    int _minRecommendID;
    
    NSMutableArray *_newData;
    int _minNewID;
    
    int _pageIndex;
    
    //加载控件
    UIRefreshControl *_freshControl;
    UIButton *_bottomRefresh;
    UIActivityIndicatorView *_activityView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"首页";
        
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_home_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_home"]];
        
        
        _announcementData = [[NSMutableArray alloc] init];
        _minAnnouncementID = 0;
        
        _recommendData = [[NSMutableArray alloc] init];
        _minRecommendID = 0;
        
        _newData = [[NSMutableArray alloc] init];
        _minNewID = 0;
        
        _pageIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //增加Segmented
    if (is_ios7) {
        [self addSegmentedView];
    } else {
        [self addSegmentedViewForIOS6];
    }

    //增加加载更多按钮
    [self addLoadMoreButton];
    //首次加载
    [self fetchAnnouncement:0];
    //增加下拉刷新视图
    [self addFreshView];
}

- (void)addFreshView
{
    _freshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, PHOTOHEIGHT, 0)];
    [_freshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_freshControl];
    
    [_freshControl performSelectorOnMainThread:@selector(beginRefreshing) withObject:nil waitUntilDone:YES];
    [_bottomRefresh setHidden:YES];
}

- (void)addLoadMoreButton
{
    /******自定义查看更多属性设置******/
    _bottomRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomRefresh setTitle:@"加载更多" forState:UIControlStateNormal];
    [_bottomRefresh setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_bottomRefresh setContentEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    [_bottomRefresh addTarget:self action:@selector(upToRefresh) forControlEvents:UIControlEventTouchUpInside];
    _bottomRefresh.frame = CGRectMake(0, 0, 320, 44);
    _activityView= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(90 , 3, 30, 30)];
    [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_activityView stopAnimating];
    [_bottomRefresh addSubview:_activityView];
    [_tableView setTableFooterView:_bottomRefresh];
    [_tableView setShowsVerticalScrollIndicator:NO];
}

- (void)addSegmentedViewForIOS6
{
    UIView *segmentedview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHOTOWIDTH, 40)];
    [segmentedview setBackgroundColor:NAVBARCOLOR];
    
    SVSegmentedControl *redSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"公司公告", @"本月促销", @"新产品孵化", nil]];
    [redSC addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
	[redSC setFrame:CGRectMake(10, 5, PHOTOWIDTH-20, 25)];
	redSC.crossFadeLabelsOnDrag = YES;
    [redSC setTintColor:TABBARCOLOR];
	redSC.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
	redSC.selectedIndex = 0;
	[segmentedview addSubview:redSC];
    
	[self.view addSubview:segmentedview];
	
    _tableView.top += segmentedview.height;
    _tableView.height -= 44;
}

- (void)addSegmentedView
{
    UIView *segmentedview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHOTOWIDTH, 30)];
    [segmentedview setBackgroundColor:NAVBARCOLOR];
    
    UISegmentedControl *segmentedController = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 0, PHOTOWIDTH-20, 25)];
    [segmentedController setBackgroundColor:NAVBARCOLOR];
    [segmentedController setTintColor:[UIColor whiteColor]];
    [segmentedController insertSegmentWithTitle:@"公司公告" atIndex:0 animated:NO];
    [segmentedController insertSegmentWithTitle:@"本月促销" atIndex:1 animated:NO];
    [segmentedController insertSegmentWithTitle:@"新产品孵化" atIndex:2 animated:NO];
    [segmentedController setSelectedSegmentIndex:0];
    [segmentedController addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [segmentedview addSubview:segmentedController];
    
    [self.view addSubview:segmentedview];
    
    _tableView.top += segmentedview.height;
    _tableView.height -= 80;
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_pageIndex == 0) {
        return _announcementData.count;
    } else if (_pageIndex == 1) {
        return _recommendData.count;
    } else if (_pageIndex == 2) {
        return _newData.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableViewCellIdentify = @"tableViewCellIdentify";
    
    THCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentify];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"THCommonTableViewCell" bundle:nil] forCellReuseIdentifier:tableViewCellIdentify];
        cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentify];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    if (_pageIndex == 0 && _announcementData.count > indexPath.row) {
        THAnnouncement *ann = [_announcementData objectAtIndex:indexPath.row];
        NSString *urlstr = [NSString stringWithFormat:@"%@/%@", THImageUrl, ann.iconUrl];
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"DefaultImage"] options:SDWebImageRetryFailed];
        [cell.titleLabel setText:ann.title];
        [cell.contentLabel setText:ann.content];
        [cell.dateTimeLabel setText:@""];
    } else if(_pageIndex == 1 && _recommendData.count > indexPath.row) {
        THProduct *product = [_recommendData objectAtIndex:indexPath.row];
        NSString *urlstr = [NSString stringWithFormat:@"%@/%@", THImageUrl, product.iconUrl];
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"DefaultImage"] options:SDWebImageRetryFailed];
        [cell.titleLabel setText:[NSString stringWithFormat:@"%@ %@",product.name ,product.model]];
        [cell.contentLabel setText:product.detail];
        [cell.dateTimeLabel setText:@""];
    } else if(_pageIndex == 2) {
        THProduct *product = [_newData objectAtIndex:indexPath.row];
        NSString *urlstr = [NSString stringWithFormat:@"%@/%@", THImageUrl, product.iconUrl];
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"DefaultImage"] options:SDWebImageRetryFailed];
        [cell.titleLabel setText:[NSString stringWithFormat:@"%@ %@",product.name ,product.model]];
        [cell.contentLabel setText:product.detail];
        [cell.dateTimeLabel setText:@""];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_pageIndex == 0) {
        THAnnouncement *ann = [_announcementData objectAtIndex:indexPath.row];
        THAnnouncementViewController *announcementViewController = [[THAnnouncementViewController alloc] initWithNibName:@"THAnnouncementViewController" bundle:nil];
        announcementViewController.announcement = ann;
        [self.navigationController pushViewController:announcementViewController animated:YES];
    } else if (_pageIndex == 1) {
        THProduct *product = [_recommendData objectAtIndex:indexPath.row];
        THProductDetailViewController *productViewController = [[THProductDetailViewController alloc] initWithNibName:@"THProductDetailViewController" bundle:nil];
        productViewController.product = product;
        [self.navigationController pushViewController:productViewController animated:YES];
    } else if (_pageIndex == 2) {
        THProduct *product = [_newData objectAtIndex:indexPath.row];
        THProductDetailViewController *productViewController = [[THProductDetailViewController alloc] initWithNibName:@"THProductDetailViewController" bundle:nil];
        productViewController.product = product;
        [self.navigationController pushViewController:productViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.f;
}

#pragma mark -
- (void)segmentChanged:(UISegmentedControl*)sender
{
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        _pageIndex = sender.selectedSegmentIndex;
    } else {
        SVSegmentedControl *svSender = (SVSegmentedControl *)sender;
        _pageIndex = svSender.selectedIndex;
    }

    [_tableView reloadData];
    
    if (_pageIndex == 0) {
        [_bottomRefresh setHidden:NO];
    } else if (_pageIndex == 1){
        if (_recommendData.count == 0) {
            [self fetchHotProduct];
        }
        [_bottomRefresh setHidden:YES];
    } else if (_pageIndex == 2){
        if (_newData.count == 0) {
            [self fetchNewProduct];
        }
        [_bottomRefresh setHidden:YES];
    }
}

- (void)pullToRefresh
{
    if (_pageIndex == 0) {
        [_activityView stopAnimating];
        [_bottomRefresh setTitle:@"加载更多" forState:UIControlStateNormal];
        [_bottomRefresh setEnabled:YES];
        [_announcementData removeAllObjects];
        [self fetchAnnouncement:0];
    } else if (_pageIndex == 1) {
        [self fetchHotProduct];
    } else if (_pageIndex == 2){
        [self fetchNewProduct];
    }
}

- (void)upToRefresh
{
    [_activityView startAnimating];
    [_bottomRefresh setTitle:@"加载中..." forState:UIControlStateNormal];
    
    [self fetchAnnouncement:_minAnnouncementID];
}

- (void)fetchAnnouncement:(int)aid
{
    [THAnnouncementModel fetchAnnouncement:aid
                                   success:^(NSArray *Array) {
                                       if (Array && Array.count>0) {
                                           [_announcementData addObjectsFromArray:Array];
                                           [_tableView reloadData];
                                           THAnnouncement *lObject = Array.lastObject;
                                           _minAnnouncementID = lObject.aid;
                                       }
                                       if (Array.count<20) {
                                           [_activityView stopAnimating];
                                           [_bottomRefresh setTitle:@"没有更多了" forState:UIControlStateNormal];
                                           [_bottomRefresh setEnabled:NO];
                                       }
                                       [_freshControl endRefreshing];
                                       [_bottomRefresh setHidden:NO];
                                   } failure:^(NSError *error) {
                                       [_freshControl endRefreshing];
                                       [_bottomRefresh setHidden:YES];
                                   }];
}

- (void)fetchHotProduct
{
    [THProductModel fetchHotProductWithSuccess:^(NSArray *Array) {
                                           [_recommendData setArray:Array];
                                           [_tableView reloadData];
                                           [_freshControl endRefreshing];
                                           [_bottomRefresh setHidden:YES];
                                        }
                                       Failure:^(NSError *error) {
                                           [_freshControl endRefreshing];
                                           [_bottomRefresh setHidden:YES];
                                        }];
}

- (void)fetchNewProduct
{
    [THProductModel fetchNewProductWithSuccess:^(NSArray *Array) {
                                           [_newData setArray:Array];
                                           [_tableView reloadData];
                                           [_freshControl endRefreshing];
                                           [_bottomRefresh setHidden:YES];
                                        }
                                       Failure:^(NSError *error) {
                                           [_freshControl endRefreshing];
                                           [_bottomRefresh setHidden:YES];
                                       }];
}


@end
