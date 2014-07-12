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
    UIImageView *forageHeading;
    UIImageView *exitIcon;
    UIImageView *pointerImage;
    UILabel *distanceToRestaurantLabel;
    MKDistanceFormatter *distanceFormatter;
    CLLocationManager *locationManager;
    CLLocationDirection directionToRestaurant;
    UILabel *restaurantNameLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithRed:0.71 green:0.522 blue:0.255 alpha:1];
    
    forageHeading = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forage_logo"]];
    forageHeading.frame = CGRectMake(0, 30, self.view.bounds.size.width - 60., 50);
    forageHeading.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:forageHeading];
    
    exitIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x-mark-512"]];
    exitIcon.frame = CGRectMake(CGRectGetMaxX(forageHeading.frame) + 5., 30., 40., 40.);
    exitIcon.contentMode = UIViewContentModeScaleAspectFit;
    [exitIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(done:)]];
    exitIcon.userInteractionEnabled = YES;
    [self.view addSubview:exitIcon];
    
    restaurantNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., CGRectGetMaxY(forageHeading.frame) + 10., self.view.bounds.size.width, 60.)];
    restaurantNameLabel.backgroundColor = [UIColor clearColor];
    restaurantNameLabel.textColor = [UIColor blackColor];
    restaurantNameLabel.textAlignment = NSTextAlignmentCenter;
    restaurantNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.];
    restaurantNameLabel.numberOfLines = 0;
    [self.view addSubview:restaurantNameLabel];
    
    pointerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forage_icon_green"]];
    pointerImage.frame = CGRectInset(self.view.bounds, 80., 100.);
    pointerImage.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(forageHeading.frame) + (self.view.bounds.size.height - CGRectGetMaxY(forageHeading.frame)) / 2.);
    pointerImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:pointerImage];
    
    distanceToRestaurantLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., CGRectGetMaxY(pointerImage.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(pointerImage.frame))];
    distanceToRestaurantLabel.backgroundColor = [UIColor clearColor];
    distanceToRestaurantLabel.textColor = [UIColor blackColor];
    distanceToRestaurantLabel.textAlignment = NSTextAlignmentCenter;
    distanceToRestaurantLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30.];
    distanceToRestaurantLabel.numberOfLines = 0;
    [self.view addSubview:distanceToRestaurantLabel];
    
    distanceFormatter = [[MKDistanceFormatter alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    
    [self computeDirectionToRestaurantForUserLocation:locationManager.location];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *userLocation = [locations lastObject];
    [self computeDirectionToRestaurantForUserLocation:userLocation];
    [self updateDistanceToRestaurantForUserLocation:userLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    pointerImage.transform = CGAffineTransformMakeRotation((directionToRestaurant - newHeading.magneticHeading) * M_PI / 180.);
}

- (void)computeDirectionToRestaurantForUserLocation:(CLLocation *)userLocation
{
    double lat1 = userLocation.coordinate.latitude * M_PI / 180.;
    double lon1 = userLocation.coordinate.longitude * M_PI / 180.;
    double lat2 = self.restaurant.latitude * M_PI / 180.;
    double lon2 = self.restaurant.longitude * M_PI / 180.;
    
    double directionRadians = atan2(sin(lon2 - lon1) * cos(lat2), cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1));
    directionToRestaurant = directionRadians * 180. / M_PI;
}

- (void)updateDistanceToRestaurantForUserLocation:(CLLocation *)userLocation
{
    CLLocation *restaurantLocation = [[CLLocation alloc] initWithLatitude:self.restaurant.latitude longitude:self.restaurant.longitude];
    CLLocationDistance distanceToRestaurant = [restaurantLocation distanceFromLocation:userLocation];
    distanceToRestaurantLabel.text = [NSString stringWithFormat:@"Distance: %@", [distanceFormatter stringFromDistance:distanceToRestaurant]];
    if (distanceToRestaurant < 50.) {
        restaurantNameLabel.text = [NSString stringWithFormat:@"Welcome to %@!", self.restaurant.name];
    }
    
//    double lat1 = userLocation.coordinate.latitude * M_PI / 180.;
//    double lon1 = userLocation.coordinate.longitude * M_PI / 180.;
//    double lat2 = restaurant.latitude * M_PI / 180.;
//    double lon2 = restaurant.longitude * M_PI / 180.;
//    
//    double dlon = lon2 - lon1;
//    double dlat = lat2 - lat1;
//    
//    double a = pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon/2), 2);
//    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//    double d = 6371. * c;
}

- (IBAction)done:(id)sender
{
    [self.delegate navigationViewControllerDidFinish:self];
}

@end
