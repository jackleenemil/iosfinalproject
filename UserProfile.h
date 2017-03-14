//  UserProfile.h
//  CocoapodDemo
//  Created by Rana on 2/22/17.

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserProfile : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *emailcode;
@property (weak, nonatomic) IBOutlet UILabel *fname;
- (IBAction)mycontact:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *secondview;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

//@property (weak, nonatomic) IBOutlet UILabel *lname;


//@property (strong, nonatomic) IBOutlet UILabel *code;
@property (strong, nonatomic) IBOutlet UILabel *email;

//@property (strong, nonatomic) IBOutlet UILabel *mname;

//@property (strong, nonatomic) IBOutlet UILabel *country;
//@property (strong, nonatomic) IBOutlet UILabel *gender;

@property (weak, nonatomic) IBOutlet UIImageView *codeimage;
@property (strong, nonatomic) IBOutlet UILabel *company;
@property (strong, nonatomic) IBOutlet UILabel *tit;

@property (strong, nonatomic) User *res;

@property (strong, nonatomic) IBOutlet UIImageView *im;



@end
