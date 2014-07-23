//
//  THDiscoverViewController.m
//  tianhao
//
//  Created by Jonear on 14-6-4.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import "THDiscoverViewController.h"
#import "THAddressModel.h"
#import "MapKit/MapKit.h"
#import "CallOutAnnotationView.h"
#import "CalloutMapAnnotation.h"
#import "JingDianMapCell.h"
#import "BasicMapAnnotation.h"
#import "THAddress.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "THCommonTableViewCell.h"

#define DEFAULTSPAN 1000

@interface THDiscoverViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation THDiscoverViewController
{
    CalloutMapAnnotation *_calloutAnnotation;
    NSArray *_addressArray;
    UIButton *_moreButton;
    UIBarButtonItem *_rightItem;
    int _showModel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"地址";
        _showModel = 0;
        _addressArray = [[NSArray alloc] init];
        
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_discover_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_discover"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self fetchAddress];
    
    _mapView.delegate = self;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setHidden:YES];
    
    _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [_moreButton setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:@"icon_product_selected"] forState:UIControlStateHighlighted];
    [_moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [_moreButton addTarget:self action:@selector(changeAddressModel) forControlEvents:UIControlEventTouchUpInside];
    _rightItem = [[UIBarButtonItem alloc] initWithCustomView:_moreButton];
    
    [self.tabBarController.navigationItem.rightBarButtonItem setEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.title = self.title;
    self.tabBarController.navigationItem.rightBarButtonItem = _rightItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchAddress
{
    [THAddressModel fetchAddressWithSuccess:^(NSArray *array) {
                                [self loadPinInMap:array];
                            } Failure:^(NSError *error) {
                             
                            }];
}

- (void)loadPinInMap:(NSArray *)array
{
    _addressArray = array;
    
    int i=0;
    NSMutableArray *annArray = [[NSMutableArray alloc] init];
    for(THAddress *address in array) {
        CLLocationCoordinate2D newCoord = {address.lat, address.lot};
        BasicMapAnnotation *pin = [[BasicMapAnnotation alloc] init];
        pin.coordinate = newCoord;
        pin.index = i++;
        [annArray addObject:pin];
    }
    
    if (array.count > 0) {
        CLLocationCoordinate2D location=CLLocationCoordinate2DMake([[array firstObject] lat], [[array firstObject] lot]);
        
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location, DEFAULTSPAN ,DEFAULTSPAN );
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
        [_mapView setRegion:adjustedRegion animated:YES];
    }
    
    [_mapView addAnnotations:annArray];
    
    //打开列表可选模式
    [self.tabBarController.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (void)changeAddressModel
{
    if (_showModel == 0) {
        _showModel = 1;
        [_mapView setHidden:YES];
        [_tableView reloadData];
        [_tableView setHidden:NO];
    } else {
        _showModel = 0;
        [_mapView setHidden:NO];
        [_tableView setHidden:YES];
    }
}

- (void)callTo:(NSString *)phone
{
    if (phone) {
        
        NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",phone];
        
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)callButtonClick:(UIButton *)button
{
    [self callTo:button.titleLabel.text];
}

#pragma mark -MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	if ([view.annotation isKindOfClass:[BasicMapAnnotation class]]) {
        if (_calloutAnnotation && _calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
        _calloutAnnotation = [[CalloutMapAnnotation alloc]
                              initWithLatitude:view.annotation.coordinate.latitude
                              andLongitude:view.annotation.coordinate.longitude];
        
        BasicMapAnnotation *ann = (BasicMapAnnotation *)view.annotation;
        THAddress *add = [_addressArray objectAtIndex:ann.index];
        _calloutAnnotation.title = add.name;
        _calloutAnnotation.subtitle = add.address;
        _calloutAnnotation.iconUrl = add.iconUrl;
        _calloutAnnotation.telephone = add.telephone;
        [mapView addAnnotation:_calloutAnnotation];
	}
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (_calloutAnnotation && ![view isKindOfClass:[CallOutAnnotationView class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            
            CalloutMapAnnotation *oldAnnotation = _calloutAnnotation;
            _calloutAnnotation = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                [mapView removeAnnotation:oldAnnotation];
            });
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation class] == MKUserLocation.class) {
        return nil;
    }
    
	if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        CalloutMapAnnotation *ann = (CalloutMapAnnotation *)annotation;
        CallOutAnnotationView *annotationView = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView) {
            annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
            JingDianMapCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"JingDianMapCell" owner:self options:nil] objectAtIndex:0];
            cell.tag = 10086;
            [annotationView.contentView addSubview:cell];
            
            [annotationView setUserInteractionEnabled:YES];
        }
        JingDianMapCell *cell = (JingDianMapCell *)[annotationView viewWithTag:10086];
        if (cell) {
            NSString *urlstr = [NSString stringWithFormat:@"%@/%@", THImageUrl, ann.iconUrl];
            [cell.imageView setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
            [cell.lbTitle setText:ann.title];
            [cell.lbDetail setText:ann.subtitle];
            [cell.callButton setTitle:ann.telephone forState:UIControlStateNormal];
            [cell.callButton addTarget:self action:@selector(callButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return annotationView;
        
	} else if ([annotation isKindOfClass:[BasicMapAnnotation class]]) {
        
        MKAnnotationView *annotationView =[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:@"CustomAnnotation"];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"pin.png"];
        }
		
		return annotationView;
    }
    return nil;
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addressArray.count;
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
    
    THAddress *address = [_addressArray objectAtIndex:indexPath.row];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@", THImageUrl, address.iconUrl];
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"DefaultImage"] options:SDWebImageRetryFailed];
    [cell.titleLabel setText:address.name];
    [cell.contentLabel setText:address.address];
    [cell.dateTimeLabel setText:@""];
 
    
    return cell;
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    THAddress *address = [_addressArray objectAtIndex:indexPath.row];
    
    if (address) {
        [self callTo:address.telephone];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.f;
}

@end
