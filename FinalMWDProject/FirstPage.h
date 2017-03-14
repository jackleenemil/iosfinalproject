//
//  FirstPage.h
//  FinalMWDProject
//
//  Created by JETS on 3/10/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstPage : UIViewController

@property IBOutlet UITextField *userName;

@property IBOutlet UITextField *password;

-(IBAction)loginAction:(id)sender;

-(IBAction)register:(id)sender;


@end
