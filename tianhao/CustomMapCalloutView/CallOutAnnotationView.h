//
//  CallOutAnnotationVifew.h
//  IYLM
//
//  Created by Jian-Ye on 12-11-8.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//
#import <MapKit/MapKit.h>

@interface CallOutAnnotationView : MKAnnotationView   <MKAnnotation>

@property (strong, nonatomic) UIView *contentView;

@end
