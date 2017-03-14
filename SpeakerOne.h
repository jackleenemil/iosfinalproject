//
//  SpeakerOne.h
//  CocoapodDemo
//
//  Created by JETS on 2/28/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Speaker.h"
@interface SpeakerOne : UIViewController
//@property (weak, nonatomic) IBOutlet UILabel *labelm;

@property (weak, nonatomic) IBOutlet UITextView *textview;

//@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *labeln;

@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property Speaker *s;
@end
