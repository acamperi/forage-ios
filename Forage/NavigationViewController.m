//
//  NavigationViewController.m
//  Forage
//
//  Created by Ariel Camperi on 11/7/14.
//  Copyright (c) 2014 Forage. All rights reserved.
//

#import "NavigationViewController.h"

@implementation NavigationViewController
{
    Restaurant *restaurant;
    UIImageView *forageHeading;
    UIActivityIndicatorView *activityIndicator;
    UIImageView *pointerImage;
    CLLocationManager *locationManager;
    CLLocationDirection directionToRestaurant;
}

- (id)initWithRestaurant:(Restaurant *)restaurant_
{
    self = [super init];
    if (self) {
        restaurant = restaurant_;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithRed:0.71 green:0.522 blue:0.255 alpha:1];
    
    forageHeading = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forage_logo"]];
    forageHeading.frame = CGRectMake(0, 30, self.view.bounds.size.width, 50);
    forageHeading.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:forageHeading];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [self.view addSubview:activityIndicator];
    
    pointerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forage_icon_green"]];
    pointerImage.frame = CGRectInset(self.view.bounds, 80., 0.);
    pointerImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:pointerImage];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    
    CLLocation *location = [locationManager location];
    [self computeDirectionToRestaurantForUserCoordinates:location.coordinate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [activityIndicator startAnimating];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [self computeDirectionToRestaurantForUserCoordinates:location.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    pointerImage.transform = CGAffineTransformMakeRotation((directionToRestaurant - newHeading.magneticHeading) * M_PI / 180.);
}

- (void)computeDirectionToRestaurantForUserCoordinates:(CLLocationCoordinate2D)userCoordinates
{
    
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate navigationViewControllerDidFinish:self];
}

@end
