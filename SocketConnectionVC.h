//
//  SocketConnectionVC.h
//  AD-HMI
//
//  Created by assam alzookery on 4/15/16.
//  Copyright © 2016 assam alzookery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tcpSocketChat.h"

@interface SocketConnectionVC : UIViewController<NSStreamDelegate,tcpSocketChatDelegate>{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSMutableArray *messages;
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;
@property (weak, nonatomic) IBOutlet UITextField *ipAddressText;
@property (weak, nonatomic) IBOutlet UITextField *portText;
@property (weak, nonatomic) IBOutlet UITextField *dataToSendText;
- (IBAction)send:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *dataRecievedTextView;
- (IBAction)connectServer:(id)sender;
@end
