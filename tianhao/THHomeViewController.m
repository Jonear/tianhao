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
#import "THAnnouncementModel.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "THAnnouncement.h"

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
    [self addSegmentedview];
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
    
    [_tableView setContentOffset:CGPointMake(0, -50)];
    [_freshControl performSelector:@selector(beginRefreshing) withObject:nil afterDelay:0.f];
}

- (void)addLoadMoreButton
{
    /******自定义查看更多属性设置******/
    _bottomRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomRefresh setTitle:@"加载更多" forState:UIControlStateNormal];
    [_bottomRefresh setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bottomRefresh setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    [_bottomRefresh addTarget:self action:@selector(upToRefresh) forControlEvents:UIControlEventTouchUpInside];
    _bottomRefresh.frame = CGRectMake(0, 0, 320, 44);
    _activityView= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(90 , 3, 30, 30)];
    [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_activityView stopAnimating];
    [_bottomRefresh addSubview:_activityView];
    [_tableView setTableFooterView:_bottomRefresh];
    [_tableView setShowsVerticalScrollIndicator:NO];
}

- (void)addSegmentedview
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
    
    UIEdgeInsets edgeInsets = _tableView.contentInset;
    edgeInsets.top += segmentedController.height;
    edgeInsets.bottom = 114;
    [_tableView setContentInset:edgeInsets];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.title = self.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UITableViewDataSource

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
    
    if (_pageIndex == 0) {
        THAnnouncement *ann = [_announcementData objectAtIndex:indexPath.row];
        NSString *urlstr = [NSString stringWithFormat:@"%@/%@", THImageUrl, ann.iconurl];
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"DefaultImage"] options:SDWebImageRetryFailed];
        [cell.titleLabel setText:ann.title];
        [cell.contentLabel setText:ann.createDate];
        [cell.dateTimeLabel setText:@""];
    } else if(_pageIndex == 1) {
        
    } else if(_pageIndex == 2) {
        
    }
    
    return cell;
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.f;
}

#pragma mark -
- (void)segmentChanged:(UISegmentedControl*)sender
{
    _pageIndex = sender.selectedSegmentIndex;
    [_tableView reloadData];
}

- (void)pullToRefresh
{
    [_activityView stopAnimating];
    [_bottomRefresh setTitle:@"加载更多" forState:UIControlStateNormal];
    [_announcementData removeAllObjects];
    [self fetchAnnouncement:0];
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
                                       if (Array && Array.count<20) {
                                           [_activityView stopAnimating];
                                           [_bottomRefresh setTitle:@"没有更多了" forState:UIControlStateNormal];
                                           [_bottomRefresh setEnabled:NO];
                                       }
                                       [_freshControl endRefreshing];
                                   } failure:^(NSError *error) {
                                       [_freshControl endRefreshing];
                                       NSLog(@"error:%@", error.description);
                                   }];
}


@end
