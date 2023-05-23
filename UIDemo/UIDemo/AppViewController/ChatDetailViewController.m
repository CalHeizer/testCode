//
//  ChatDetailViewController.m
//  UIDemo
//
//  Created by lyq on 2023/5/21.
//

#import "ChatDetailViewController.h"
#import "../Message.h"

static NSString *CellIdentifier=@"CellIdentifier";


@interface ChatDetailCell : UITableViewCell

@property (strong, nonatomic) UIImageView *headImageView;

@property (strong, nonatomic) UIButton *isMineDialogMessageButton;

@property (assign, nonatomic) CGFloat buttonHeight;

@property (assign, nonatomic) CGFloat buttonWidth;

@property (strong, nonatomic) NSString *name;

@property (assign, nonatomic) BOOL isMine;

@end



@implementation ChatDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        self.headImageView = [[UIImageView alloc] init];
        [self.headImageView setImage:[UIImage imageNamed:@"小强"]];
        self.name = @"小强";
        self.isMine = YES;
        
        UIImage* normalImage = [UIImage imageNamed:@"mychat_normal"];
        UIImage* highlightedImage = [UIImage imageNamed:@"mychat_focused"];
        
        self.isMineDialogMessageButton = [[UIButton alloc] init];
        [self.isMineDialogMessageButton setContentEdgeInsets:UIEdgeInsetsMake(10, 25, 15, 10)];
        [self.isMineDialogMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.isMineDialogMessageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        normalImage = [normalImage stretchableImageWithLeftCapWidth:normalImage.size.width*0.5 topCapHeight:normalImage.size.height*0.6];//设置图片拉伸区域
        highlightedImage = [highlightedImage stretchableImageWithLeftCapWidth:highlightedImage.size.width*0.5 topCapHeight:highlightedImage.size.height*0.6];//设置图片拉伸区域
        [self.isMineDialogMessageButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        [self.isMineDialogMessageButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        
        self.isMineDialogMessageButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.isMineDialogMessageButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.isMineDialogMessageButton.titleLabel.numberOfLines = 0;
    }
    return self;
}

- (CGSize) getSize:(NSString *)text {
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize maxSize = CGSizeMake(0.5 * self.contentView.frame.size.width, 1000);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{
        NSFontAttributeName: font,
        NSParagraphStyleAttributeName: paragraphStyle
    };
    CGSize size = [text boundingRectWithSize:maxSize
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil].size;
    return size;
}

- (void)updateData:(Message *)msg ofName:(NSString *)name {
    if (![self.name isEqualToString:name]) {
        [self.headImageView setImage:[UIImage imageNamed:name]];
        self.name = name;
    }
    if (msg.isMine != self.isMine) {
        UIImage *normalImage, *highlightedImage;
        if(msg.isMine){
            normalImage = [UIImage imageNamed:@"mychat_normal"];
            highlightedImage = [UIImage imageNamed:@"mychat_focused"];
            [self.isMineDialogMessageButton setContentEdgeInsets:UIEdgeInsetsMake(10, 25, 15, 10)];
            [self.isMineDialogMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        } else {
            normalImage = [UIImage imageNamed:@"matechat_normal"];
            highlightedImage = [UIImage imageNamed:@"matechat_focused"];
            [self.isMineDialogMessageButton setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 15, 25)];
            [self.isMineDialogMessageButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        }
        normalImage = [normalImage stretchableImageWithLeftCapWidth:normalImage.size.width*0.5 topCapHeight:normalImage.size.height*0.6];//设置图片拉伸区域
        highlightedImage = [highlightedImage stretchableImageWithLeftCapWidth:highlightedImage.size.width*0.5 topCapHeight:highlightedImage.size.height*0.6];//设置图片拉伸区域
        [self.isMineDialogMessageButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        [self.isMineDialogMessageButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    }
    self.isMine = msg.isMine;
    NSMutableString *buttonName = [[NSMutableString alloc] initWithFormat:@"%@",msg.message];
    [self.isMineDialogMessageButton setTitle:buttonName forState:UIControlStateNormal];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"[yql] layoutSubviews: %@", NSStringFromCGRect(self.contentView.frame));
    CGSize size = [self getSize: self.isMineDialogMessageButton.titleLabel.text];
    self.buttonWidth = size.width + 35;
    if(size.height + 25 < 50) {
        self.buttonHeight = 50;
    } else {
        self.buttonHeight = size.height + 25;
    }
    if (self.isMine) {
        [self.headImageView setFrame:CGRectMake(5, 5, 50, 50)];
        [self.isMineDialogMessageButton setFrame:CGRectMake(55, 5, self.buttonWidth, self.buttonHeight)];
    } else {
        [self.headImageView setFrame:CGRectMake(self.contentView.frame.size.width - 55, 5, 50, 50)];
        [self.isMineDialogMessageButton setFrame:CGRectMake(self.contentView.frame.size.width - self.buttonWidth - 55, 5, self.buttonWidth, self.buttonHeight)];
    }
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.isMineDialogMessageButton];
    
    
}

@end

@interface ChatDetailViewController ()

@property (assign, nonatomic) CGRect lastFrame;

@end

@implementation ChatDetailViewController

- (void)loadTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60 - self.view.safeAreaInsets.bottom)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:ChatDetailCell.class forCellReuseIdentifier:CellIdentifier];
}


- (void)loadToolbar {
    self.myToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 60 - self.view.safeAreaInsets.bottom, self.view.frame.size.width, 60)];
    
    self.myTextField = [[UITextField alloc] init];
    self.myTextField.frame = CGRectMake(0, 0, self.myToolbar.frame.size.width*0.85, 40);
    self.myTextField.delegate = self;
    self.myTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//垂直居中
    self.myTextField.placeholder = @"请输入内容";//内容为空时默认文字
    self.myTextField.returnKeyType = UIReturnKeyDone;//设置放回按钮的样式
    self.myTextField.keyboardType = UIKeyboardTypeDefault;//设置键盘样式为默认
    
    UIBarButtonItem *textfieldButtonItem =[[UIBarButtonItem alloc]initWithCustomView:self.myTextField];
    UIBarButtonItem *sendMessageButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendMessage)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    

    NSArray *textfieldArray=[[NSArray alloc]initWithObjects:textfieldButtonItem, flexibleSpace, sendMessageButtonItem,nil];
    [self.myToolbar setItems:textfieldArray];
}

- (void)reViewLoad {
    CGFloat toolbarHeight = 60;
    CGFloat viewHeight = self.view.frame.size.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom;
    CGFloat viewWidth = self.view.frame.size.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right;
    
    self.tableView.frame = CGRectMake(self.view.safeAreaInsets.left, self.view.safeAreaInsets.top, viewWidth, viewHeight - toolbarHeight);
    self.myToolbar.frame = CGRectMake(self.view.safeAreaInsets.left, self.tableView.frame.origin.y + self.tableView.frame.size.height, viewWidth, toolbarHeight);
    self.myTextField.frame = CGRectMake(0, 0, self.myToolbar.frame.size.width * 0.85, 40);
}

- (instancetype)init {
    if ( self = [super init] ) {
        
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.dialogMessages) {
        self.dialogMessages = [[NSMutableArray alloc]init];
    }
    const NSString *MsgKey = @"msg";
    const NSString *MineKey = @"ismine";
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Chat" ofType:@"plist"];
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *dataArray = dataDict[self.name];
    
    [dataArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        Message *message = [[Message alloc] init];
        message.message = dict[MsgKey];
        message.isMine = [dict[MineKey] boolValue];
        [self.dialogMessages addObject:message];
    }];//读取字典中的数据
    [self loadTableView];
    [self loadToolbar];
        
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.myToolbar];
    //注册键盘出现与隐藏时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    [self keyboardWillHide:nil];
    [self.view endEditing:YES];
}

- (void)sendMessage{//完成输入响应函数
    Message *newMessage = [[Message alloc]init];
    newMessage.message = [[NSString alloc]initWithString:self.myTextField.text];
    newMessage.isMine =YES;
    [self.dialogMessages addObject:newMessage];
    [self.tableView reloadData];
    NSUInteger rowCount = [self.tableView numberOfRowsInSection:0];//设置滚动到底部
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:rowCount-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath
                        atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//    [self.myTextField resignFirstResponder];
    self.myTextField.text =@"";
    
}

//键盘出现时候调用的事件
- (void) keyboardWillShow:(NSNotification *)note{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘的frame
    CGFloat toolBarHeight = 60;
    
    self.myToolbar.frame = CGRectMake(0, self.view.frame.size.height - toolBarHeight - keyboardSize.height, self.view.frame.size.width, toolBarHeight);
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.myToolbar.frame.origin.y);
    
    NSUInteger rowCount = [self.tableView numberOfRowsInSection:0];//设置滚动到底部
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:rowCount-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath
                        atScrollPosition:UITableViewScrollPositionBottom animated:NO];
 
}
//键盘消失时候调用的事件
- (void)keyboardWillHide:(NSNotification *)note{
    [self reViewLoad];
}
//隐藏键盘方法
- (void)hideKeyboard{
    [self.myTextField resignFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"[yql] viewDidLayoutSubviews: %@", NSStringFromCGRect(self.view.frame));
    
    
}



- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"[yql] viewWillLayoutSubviews: %@", NSStringFromCGRect(self.view.frame));
    if (!CGRectEqualToRect(self.view.frame, self.lastFrame)) {
        [self reViewLoad];
        self.lastFrame = self.view.frame;
    }
//    [self reViewLoad];
}


#pragma mark-
#pragma mark UITabelViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dialogMessages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *msg = self.dialogMessages[indexPath.row];
    CGSize size = [self getSize:msg.message];
    if (size.height + 25 < 55) {//判断对话框的高度，如果比头像矮就设置为头像高度，否则就设置为对话框的文本高度加上间隔
        return 55;
    } else{
        return size.height+25;//与边线的间隔加上文本的上下缩进
    }
}

- (CGSize) getSize:(NSString *)text {
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize maxSize = CGSizeMake(0.5 * self.view.frame.size.width, 1000);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{
        NSFontAttributeName: font,
        NSParagraphStyleAttributeName: paragraphStyle
    };
    CGSize size = [text boundingRectWithSize:maxSize
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil].size;
    return size;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ChatDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//消去边线
    
    Message *msg = self.dialogMessages[indexPath.row];
    NSString *strName = [[NSString alloc] init];
    if (msg.isMine == YES) strName = @"小强";
    else strName = self.name;
    
    [cell updateData:msg ofName:strName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.myTextField resignFirstResponder];
}

#pragma mark -
#pragma mark UITextFieldDelegate
//开始编辑：
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}


//点击return按钮所做的动作：
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//取消第一响应
    return YES;
}

//编辑完成：
- (void)textFieldDidEndEditing:(UITextField *)textField{
}

@end
