//
//  ViewController.h
//  MWDProject
//
//  Created by JETS on 2/22/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JETSNetworkDelegate.h"

@interface ViewController : UIViewController <JETSNetworkDelegate>

@property IBOutlet UITextField *userName;

@property IBOutlet UITextField *password;

-(IBAction)loginAction:(id)sender;

-(IBAction)register:(id)sender;

@end

