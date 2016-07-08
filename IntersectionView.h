//
//  IntersectionView.h
//  AD-HMI
//
//  Created by assam alzookery on 4/20/16.
//  Copyright © 2016 assam alzookery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tcpSocketChat.h"
#import "ViewController.h"
//#import "ViewController.m"

@interface IntersectionView : UIViewController<NSStreamDelegate,tcpSocketChatDelegate,UITextFieldDelegate>{
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSMutableArray *messages;
}
- (IBAction)junction:(id)sender;
- (IBAction)connect:(id)sender;

@end
