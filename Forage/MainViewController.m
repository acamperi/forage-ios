//
//  MainViewController.m
//  Forage
//
//  Created by Ariel Camperi on 11/7/14.
//  Copyright (c) 2014 Forage. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"

@interface MainViewController ()

@property (atomic) BOOL isWaitingForLocation;

@end

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
    
    self.isWaitingForLocation = NO;
    
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.isWaitingForLocation = YES;
    [locationManager startUpdatingLocation];
    [activityIndicator startAnimating];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (!self.isWaitingForLocation) {
        return;
    }
    self.isWaitingForLocation = NO;
//    CLLocation *currentLocation = [locations lastObject];
//    NSDictionary *locationParameters = @{@"lat" : @(currentLocation.coordinate.latitude),
//                                         @"lon" : @(currentLocation.coordinate.longitude)};
//    [requestOperationManager GET:@"REPLACE_WITH_URL" parameters:locationParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [activityIndicator stopAnimating];
//        [self processRestaurantsJson:responseObject];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error);
//    }];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sample_data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [activityIndicator stopAnimating];
    [self processRestaurantsJson:json];
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
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (abs(restaurantCardScrollView.contentOffset.x - restaurantCardScrollView.bounds.size.width) < 0.001) {
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
    NavigationViewController *navigationViewController = [[NavigationViewController alloc] initWithRestaurant:restaurantCard.restaurant];
    [self presentViewController:navigationViewController animated:YES completion:nil];
}

#pragma mark - Flipside View

- (void)navigationViewControllerDidFinish:(NavigationViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
