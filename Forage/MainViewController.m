//
//  MainViewController.m
//  Forage
//
//  Created by Ariel Camperi on 11/7/14.
//  Copyright (c) 2014 Forage. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"

@implementation MainViewController
{
    UIActivityIndicatorView *activityIndicator;
    CLLocationManager *locationManager;
    AFHTTPRequestOperationManager *requestOperationManager;
    NSArray *restaurants;
    UIScrollView *restaurantCardScrollView;
    RestaurantCard *currentCard;
    RestaurantCard *nextCard;
    int currentRestaurantIndex;
    int nextRestaurantIndex;
    UIImageView *forageHeading;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor whiteColor];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:activityIndicator];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = 1.;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.delegate = self;
    
    requestOperationManager = [AFHTTPRequestOperationManager manager];
    
    CGRect restaurantCardScrollViewFrame = self.view.bounds;
    restaurantCardScrollView = [[UIScrollView alloc] initWithFrame:restaurantCardScrollViewFrame];
    restaurantCardScrollView.contentSize = CGSizeMake(restaurantCardScrollViewFrame.size.width * 2., restaurantCardScrollViewFrame.size.height);
    restaurantCardScrollView.showsHorizontalScrollIndicator = NO;
    restaurantCardScrollView.pagingEnabled = YES;
    restaurantCardScrollView.bounces = NO;
    restaurantCardScrollView.scrollEnabled = NO;
    restaurantCardScrollView.delegate = self;
    [self.view addSubview:restaurantCardScrollView];
    
    forageHeading = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forage_logo"]];
    forageHeading.frame = CGRectMake(0, 30, self.view.bounds.size.width, 50);
    forageHeading.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:forageHeading];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [locationManager startUpdatingLocation];
    [activityIndicator startAnimating];
    
    CLLocation *currentLocation = [locationManager location];
    NSDictionary *locationParameters = @{@"lat" : @(currentLocation.coordinate.latitude),
                                         @"lon" : @(currentLocation.coordinate.longitude)};
    [requestOperationManager GET:@"http://forage2.herokuapp.com/locate" parameters:locationParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [activityIndicator stopAnimating];
        [self processRestaurantsJson:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sample_data" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    [activityIndicator stopAnimating];
//    [self processRestaurantsJson:json];
}

- (void)processRestaurantsJson:(NSArray *)json
{
    NSMutableArray *restaurantObjects = [NSMutableArray array];
    for (NSDictionary *restaurantJson in json) {
        Restaurant *restaurant = [Restaurant parseFromJson:restaurantJson];
        [restaurantObjects addObject:restaurant];
    }
    restaurants = restaurantObjects;
    [self createRestaurantCards];
}

- (void)createRestaurantCards
{
    currentCard = [[RestaurantCard alloc] initWithFrame:restaurantCardScrollView.bounds delegate:self];
    currentCard.restaurant = restaurants[0];
    nextCard = [[RestaurantCard alloc] initWithFrame:CGRectOffset(currentCard.frame, currentCard.frame.size.width, 0.) delegate:self];
    nextCard.restaurant = restaurants[1];
    currentRestaurantIndex = 0;
    nextRestaurantIndex = 1;
    [restaurantCardScrollView addSubview:currentCard];
    [restaurantCardScrollView addSubview:nextCard];
    restaurantCardScrollView.scrollEnabled = YES;
    forageHeading.image = [UIImage imageNamed:@"forage_logo_white"];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (restaurants && abs(restaurantCardScrollView.contentOffset.x - restaurantCardScrollView.bounds.size.width) < 0.001) {
        restaurantCardScrollView.scrollEnabled = NO;
        [currentCard removeFromSuperview];
        currentCard = nextCard;
        currentRestaurantIndex = nextRestaurantIndex;
        nextRestaurantIndex = currentRestaurantIndex == restaurants.count - 1 ? 0 : currentRestaurantIndex + 1;
        currentCard.center = restaurantCardScrollView.center;
        restaurantCardScrollView.contentOffset = CGPointZero;
        nextCard = [[RestaurantCard alloc] initWithFrame:CGRectOffset(currentCard.frame, currentCard.frame.size.width, 0.) delegate:self];
        nextCard.restaurant = restaurants[nextRestaurantIndex];
        [restaurantCardScrollView addSubview:nextCard];
        restaurantCardScrollView.scrollEnabled = YES;
    }
}

- (void)startNavigationForRestaurantCard:(RestaurantCard *)restaurantCard
{
    NavigationViewController *navigationViewController = [[NavigationViewController alloc] init];
    navigationViewController.restaurant = restaurantCard.restaurant;
    navigationViewController.delegate = self;
    [self presentViewController:navigationViewController animated:YES completion:nil];
}

- (void)navigationViewControllerDidFinish:(NavigationViewController *)controller
{
    restaurants = nil;
    restaurantCardScrollView.scrollEnabled = NO;
    [currentCard removeFromSuperview];
    [nextCard removeFromSuperview];
    forageHeading.image = [UIImage imageNamed:@"forage_logo"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
