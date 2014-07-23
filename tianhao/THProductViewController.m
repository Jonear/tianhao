//
//  THProductViewController.m
//  tianhao
//
//  Created by Jonear on 14-6-4.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import "THProductViewController.h"
#import "THCommonCollectionViewCell.h"
#import "THProductModel.h"
#import "THProduct.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIView+Sizes.h"
#import "THProductDetailViewController.h"

@interface THProductViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation THProductViewController
{
    NSMutableArray *_productData;
    int _minproductID;
    
    UIRefreshControl *_freshControl;
    UIButton *_bottomRefresh;
    UIActivityIndicatorView *_activityView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"产品";
        
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_product_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_product"]];
        
        _productData = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initCollectionView];
    [self addFreshView];
    [self addLoadMoreButton];
    [self fetchProduct:0];
}

- (void)initCollectionView
{
    //设置委托
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    
    [_collectionView registerNib:[UINib nibWithNibName:@"THCommonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"THCommonCollectionViewCell"];
    [_collectionView setAllowsMultipleSelection:YES];
    
    //设置布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 127)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.footerReferenceSize = CGSizeMake(300, 30);
    
    [_collectionView setCollectionViewLayout:flowLayout];
    [_collectionView setAlwaysBounceVertical:YES];

}

- (void)addFreshView
{
    
    _freshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, PHOTOHEIGHT, 0)];
    [_freshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    [_collectionView addSubview:_freshControl];
    
    [_freshControl performSelectorOnMainThread:@selector(beginRefreshing) withObject:nil waitUntilDone:YES];
    [_bottomRefresh setHidden:YES];
}

- (void)addLoadMoreButton
{
    /******自定义查看更多属性设置******/
    _bottomRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomRefresh setTitle:@"加载更多" forState:UIControlStateNormal];
    [_bottomRefresh setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_bottomRefresh setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    [_bottomRefresh addTarget:self action:@selector(upToRefresh) forControlEvents:UIControlEventTouchUpInside];
    _bottomRefresh.frame = CGRectMake(0, _collectionView.height-114-44, 320, 44);
    _activityView= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(90 , 3, 30, 30)];
    [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_activityView stopAnimating];
    [_bottomRefresh addSubview:_activityView];
    [_collectionView addSubview:_bottomRefresh];
    [_collectionView setShowsVerticalScrollIndicator:NO];
}

- (void)pullToRefresh
{
    [_activityView stopAnimating];
    [_bottomRefresh setTitle:@"加载更多" forState:UIControlStateNormal];
    [_bottomRefresh setEnabled:YES];
    [_productData removeAllObjects];
    [self fetchProduct:0];
}

- (void)upToRefresh
{
    [_activityView startAnimating];
    [_bottomRefresh setTitle:@"加载中..." forState:UIControlStateNormal];
    
    [self fetchProduct:_minproductID];
}


- (void)fetchProduct:(int)pid
{
    [THProductModel fetchProduct:pid
                         success:^(NSArray *Array) {
                             if (Array && Array.count>0) {
                                 [_productData addObjectsFromArray:Array];
                                 [_collectionView reloadData];
                                 THProduct *lObject = Array.lastObject;
                                 _minproductID = lObject.pid;
                             }
                             if (Array.count<15) {
                                 [_activityView stopAnimating];
                                 [_bottomRefresh setTitle:@"没有更多了" forState:UIControlStateNormal];
                                 [_bottomRefresh setEnabled:NO];
                             }
                             [_freshControl endRefreshing];
                             [_bottomRefresh setHidden:NO];
                             
                              _bottomRefresh.frame = CGRectMake(0, ((_productData.count-1)/3+1)*127+20, 320, 44);
                         } failure:^(NSError *error) {
                             [_freshControl endRefreshing];
                             [_bottomRefresh setHidden:YES];
                         }];
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _productData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"THCommonCollectionViewCell";
    
    THCommonCollectionViewCell *cell = (THCommonCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    THProduct *product = [_productData objectAtIndex:indexPath.row];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@", THImageUrl, product.iconUrl];
    [cell.imageView setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"DefaultImage"] options:SDWebImageRetryFailed];
//    [cell.titleLabel setText:[NSString stringWithFormat:@"%@ %@",product.name ,product.model]];
    [cell.titleLabel setText:product.model];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    THProduct *product = [_productData objectAtIndex:indexPath.row];
    THProductDetailViewController *productDetailViewController = [[THProductDetailViewController alloc] initWithNibName:@"THProductDetailViewController" bundle:nil];
    productDetailViewController.product = product;
    [self.navigationController pushViewController:productDetailViewController animated:YES];
}

@end
