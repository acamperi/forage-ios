//
//  MainViewController.h
//  Forage
//
//  Created by Ariel Camperi on 11/7/14.
//  Copyright (c) 2014 Forage. All rights reserved.
//

#import "NavigationViewController.h"
#import "RestaurantCard.h"

@interface MainViewController : UIViewController <NavigationViewControllerDelegate, CLLocationManagerDelegate, UIScrollViewDelegate, RestaurantCardDelegate>

@end
