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
@property (strong, nonatomic) Restaurant *restaurant;

- (IBAction)done:(id)sender;

@end
