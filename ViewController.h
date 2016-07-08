//
//  ViewController.h
//  AD-HMI
//
//  Created by assam alzookery on 3/16/16.
//  Copyright © 2016 assam alzookery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tcpSocketChat.h"
#import "IntersectionView.h"
//#import "IntersectionView.m"
@interface ViewController : UIViewController <NSStreamDelegate,tcpSocketChatDelegate ,UITextFieldDelegate>
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSMutableArray *messages;
}
@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;
- (IBAction)go1:(id)sender;
- (IBAction)Next:(id)sender;

- (IBAction)sunny:(id)sender;
- (IBAction)Cloudy:(id)sender;
- (IBAction)sunny_showers:(id)sender;
- (IBAction)Rainy:(id)sender;
- (IBAction)snow:(id)sender;
- (IBAction)Night:(id)sender;
- (IBAction)connectToServer:(id)sender;

@end

