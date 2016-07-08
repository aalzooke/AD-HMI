//
//  TestController 2.m
//  AD-HMI
//
//  Created by assam alzookery on 4/22/16.
//  Copyright © 2016 assam alzookery. All rights reserved.
//

#import "TestController2.h"

@interface TestController_2 ()
@property (nonatomic,strong) tcpSocketChat* chatSocket;

@end

@implementation TestController_2
@synthesize logView = _logView;
@synthesize chatSocket = _chatSocket;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _chatSocket = [[tcpSocketChat alloc] initWithDelegate:self AndSocketHost:@"192.168.211.62" AndPort:123];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    self.chatSocket = nil;
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)disconnect:(id)sender {
    if([_chatSocket isConnected]) {
        [_chatSocket disconnect];
        
        self.logView.text = [self.logView.text stringByAppendingFormat:@"ME >> left the chat. Bye Bye!\n"];
      //  [self.chatBox resignFirstResponder];
        
    }
}

- (IBAction)connect:(id)sender {
    if([_chatSocket isDisconnected]) {
        [_chatSocket reconnect];
        
        self.logView.text = [self.logView.text stringByAppendingFormat:@"ME >> welcome!\n"];
       // [self.chatBox resignFirstResponder];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.chatSocket sendMessage:textField.text];
    
    self.logView.text = [self.logView.text stringByAppendingFormat:@"ME >> %@\n",textField.text];
    
    textField.text = @"";
    
    [self.logView scrollRangeToVisible:NSMakeRange([self.logView.text length], 0)];
    return YES;
}

#pragma mark - tcpSocketDelegate
-(void)receivedMessage:(NSString *)data
{
    self.logView.text = [self.logView.text stringByAppendingFormat:@"%@",data];
    [self.logView scrollRangeToVisible:NSMakeRange([self.logView.text length], 0)];
}
- (IBAction)go:(id)sender {
    NSString *response4  = @"Rainy \n  ";
    NSData *data4 = [[NSData alloc] initWithData:[response4 dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data4 bytes] maxLength:[data4 length]];
}
-(void)messageReceived:(NSString *)message{
    
    
    [messages addObject:message];
    
    _logView.text = message;
    NSLog(@"%@", message);
}
@end
