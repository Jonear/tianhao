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

#define DEFAULTSPAN 1000

@interface THDiscoverViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation THDiscoverViewController
{
    CalloutMapAnnotation *_calloutAnnotation;
    NSArray *_addressArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"附近";
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

- (void)fetchAddress
{
    [THAddressModel fetchAddress:0
                         success:^(NSArray *array) {
                             NSLog(@"%@", array.description);
                             [self loadPinInMap:array];
                         } failure:^(NSError *error) {
                             
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
        
//        _calloutAnnotation.title = view.annotation.title;
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
        
        CallOutAnnotationView *annotationView = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView) {
            annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
            JingDianMapCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"JingDianMapCell" owner:self options:nil] objectAtIndex:0];
            [annotationView.contentView addSubview:cell];
            
            [annotationView setUserInteractionEnabled:YES];
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


@end
