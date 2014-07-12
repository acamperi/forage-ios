//
//  NavigationViewController.h
//  Forage
//
//  Created by Ariel Camperi on 11/7/14.
//  Copyright (c) 2014 Forage. All rights reserved.
//

#import "Restaurant.h"

@class NavigationViewController;

@protocol NavigationViewControllerDelegate
- (void)navigationViewControllerDidFinish:(NavigationViewController *)controller;
@end

@interface NavigationViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) id <NavigationViewControllerDelegate> delegate;

- (id)initWithRestaurant:(Restaurant *)restaurant_;
- (IBAction)done:(id)sender;

@end
