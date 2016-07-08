//
//  ViewControllerClient.h
//  AD-HMI
//
//  Created by assam alzookery on 4/13/16.
//  Copyright © 2016 assam alzookery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tcpSocketChat.h"

@interface ViewControllerClient : UIViewController <NSStreamDelegate,tcpSocketChatDelegate ,UITextFieldDelegate>
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSMutableArray *messages;
    
    
}
@property (nonatomic,assign) IBOutlet UITextView* logView;
@property (nonatomic,assign) IBOutlet UITextField* chatBox;
@property (nonatomic,assign) IBOutlet UIButton* btnDisconnect;

@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;
- (IBAction)connectToServer:(id)sender;



- (IBAction)disconnect:(id)sender;

@end
