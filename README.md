IOS SDK开发包 版本号 1.3.0 日期 20160808

安装

微印sdk只支持ios7.0以上版本

当您下载了WeiYin IOS SDK 的 zip 包后，进行以下步骤:(oc项目需先看完步骤,swift项目顺序执行即可)

1.把WYSdk拖到你工程的适当目录(如根目录),松手后会弹出选择框,选择 copy items if needed,Create groups,add to targets 然后finish

2.在根目录的Podfile加入以下依赖(以下为1.0.1pod样例)

    source 'https://github.com/CocoaPods/Specs.git'
    platform :ios, '7.0'

    target '项目target' do
    #线程库 阻塞线程的
    pod 'Bolts'

    #支付的sdk
    pod 'Pingpp/Alipay'
    pod 'Pingpp/Wx'

    end


3.在命令行进入你的工程根目录 然后pod update

4.swift工程都需要创建一个 项目名-Bridging-Header.h, 在文件写入#import "Pingpp.h" #import "Bolts.h",然后打开工程以demo为例子:选择wysdkdemo 再选择 
TARGETS的wysdkdemo 选择 Build Settings 找到 Objective-C Bridging Header 最后填上刚才.h的路径 如:wysdkdemo/wysdkdemo-Bridging-Header.h

5.oc项目 如果是第一次导入swift 先自己创建一个swift类,会提示创建 项目名-Bridging-Header.h,再执行第四步的步骤,然后把sdk拖入项目,然后打开工程以demo为
例子:选择wysdkdemo 再选择 TARGETS的wysdkdemo 选择 Build Settings 找到 Packaging > Defines Module 该为YES 最后就可以 #import "项目名-Swift.h",以后
的代码和swift一样,自行转成oc即可

初始化

    //openid每个合作方的每个用户的唯一标识 建议写法 前缀+唯一标识 如 WY_xxxxxx
    WYSdk.getInstance().setSDK("52HJR62BDS6SDD21", accessSecret: "VlYmY2ZjBmOWFmZTJlZTk3NzdhN2M0ODM0MjE3", openId: "openid")


编辑页

    支持数据筛选,长按图片或文字修改文本
    //数据编辑面页 默认是打开的 关闭直接就跳去排版页
    private func edit(){
    //打开二次编辑面页 默认是开的
    WYSdk.getInstance().isShowSelectDataViewController(true)

    //上啦加载更多,默认是关闭的
    WYSdk.getInstance().openLoadMore(true)
    WYSdk.getInstance().setWyLoadMoreDelegate {
        //WYSdk.getInstance().getTextBlock //创建文本
        //WYSdk.getInstance().getChapterBlock //创建章节

        ThreadUtils.threadOnAfterMain(1000, block: {
            let photoUrl1 = "http://img1.3lian.com/2015/w7/90/d/1.jpg"//1289 x 806
            let block = WYSdk.getInstance().getPhotoBlock("图片1", url: photoUrl1, lowPixelUrl: photoUrl1, originalTime: TimeUtils.getCurrentTime(), width: 1289, height: 806)

            let arr = NSMutableArray()
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            WYSdk.getInstance().addLoadMoreData(arr)
        })
    }
    }


合作方支付

    //设置是否合作方的app支付,默认是false
    //如果是用微印支付或合作方的pingxx支付不需要设置这些
    private func myAppPay(){
        WYSdk.getInstance().setMyAppPay(true)
        WYSdk.getInstance().setWyPayOrderDelegate { (orderId, price, randomStr) in
            //处理支付
            //合作方需要 orderId randomStr 来通知微印服务器
            //支付成功后,合作方服务器调微印的服务器更新支付结果,文档在联调时索取
        }
    }
    //刷新支结果,用来ui显示的 {@link WYSdk.PAY_SUCCESS,WYSdk.PAY_FAIL,WYSdk.PAY_CANCEL,WYSdk.PAY_INVALID}
    WYSdk.getInstance().refreshPayState(result:String)


    默认微印支付宝或合作方的pingxx支付 回调设置

    项目TARGETS -> info -> URL Type -> URL Schemes 增加 weiyin

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return Pingpp.handleOpenURL(url, withCompletion: nil)
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return Pingpp.handleOpenURL(url, withCompletion: nil)
    }


购物车

    //这个是打开购物车页,需要的时候可以调用
    WYSdk.getInstance().showShopCart(self);


订单页

    //这个是打开订单页,需要的时候可以调用
    WYSdk.getInstance().showOrderList(self);
    //这个是刷新订单状态的,在订单页才生效
    WYSdk.getInstance().refreshOrderState()


了解纸质画册

    //这个是打开纸质画册,需要的时候可以调用
    WYSdk.getInstance().showPaper(self);


排版页

    //设置好上述相关数据后调用 postPrintData() 即可预览排版页
    WYSdk.getInstance().postPrintData(self,start,success,falied)


其他设置

    // 设置主题颜色 16进制的颜色 如: f56971
    WYSdk.getInstance().setThemeColor("f56971")


SDK使用注意事项

照片页和文本页是可以从属在章节页下的，add时候的顺序要注意

如果想某个图片或文本要从属在某个章节页下，就先要addChapterBlock再add照片页或文本页

当然如果不想放在某个章节下面就直接add照片和文本即可

这些add都是有先后顺序区分的，排版页看到的顺序是add先到后



swift例子

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

    //openid每个合作方的每个用户的唯一标识 建议写法 前缀+唯一标识 如 WY_xxxxxx
    WYSdk.getInstance().setSDK("52HJR62BDS6SDD21", accessSecret: "VlYmY2ZjBmOWFmZTJlZTk3NzdhN2M0ODM0MjE3", openId: "openid")
    }

    class ViewController: UIViewController {

    private var loadingIndicator = LoadingView()

    override func viewDidLoad() {
    self.navigationController?.navigationBarHidden  = false
    self.navigationItem.title = "demo"

    let mSubmitDataButton =  UIButton(frame: CGRectMake(0,0,200,200))
    mSubmitDataButton.setTitle("提交数据", forState: UIControlState.Normal)
    mSubmitDataButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    mSubmitDataButton.addTarget(self, action: #selector(ViewController.submitData), forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(mSubmitDataButton)
    self.view.addSubview(loadingIndicator)

    //编辑页设置
    //edit()

    //这个是打开订单页,需要的时候可以调用
    //WYSdk.getInstance().showOrderList(self)
    //这个是刷新订单状态的,在订单页才生效
    //WYSdk.getInstance().refreshOrderState()

    //myAppPay()
    }
    private func edit(){
    //打开二次编辑面页 默认是开的
    WYSdk.getInstance().isShowSelectDataViewController(true)

    //上啦加载更多,默认是关闭的
    WYSdk.getInstance().openLoadMore(true)
    WYSdk.getInstance().setWyLoadMoreDelegate {
        //WYSdk.getInstance().getTextBlock //创建文本
        //WYSdk.getInstance().getChapterBlock //创建章节

        ThreadUtils.threadOnAfterMain(1000, block: {
            let photoUrl1 = "http://img1.3lian.com/2015/w7/90/d/1.jpg"//1289 x 806
            let block = WYSdk.getInstance().getPhotoBlock("图片1", url: photoUrl1, lowPixelUrl: photoUrl1, originalTime: TimeUtils.getCurrentTime(), width: 1289, height: 806)

            let arr = NSMutableArray()
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            arr.addObject(block)
            WYSdk.getInstance().addLoadMoreData(arr)
        })
    }
    }

    //设置合作方的app支付 默认是false
    private func myAppPay(){
        WYSdk.getInstance().setMyAppPay(true)
        WYSdk.getInstance().setWyPayOrderDelegate { (orderId, price, randomStr) in
            //处理支付
            //合作方需要 orderId randomStr 来通知微印服务器
            //支付成功后,合作方服务器调微印的服务器更新支付结果,文档在联调时索取
        }
    }

    private func addData() {
        //图片素材 必须是网络路径 宽高也是必要的
        let frontCoverUrl = "http://img1.3lian.com/2015/w7/98/d/22.jpg"//1210 x 681
        let flyleafHeadUrl = "http://img21.mtime.cn/mg/2011/05/18/161045.63077415.jpg"//251 x 251
        let backCoverUrl = "http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg"//1358 x 765

        let photoUrl1 = "http://img1.3lian.com/2015/w7/90/d/1.jpg"//1289 x 806
        let photoUrl2 = "http://img2.3lian.com/img2007/23/08/025.jpg"//1001 x 751
        let photoUrl3 = "http://img1.goepe.com/201303/1362711681_6600.jpg"//988 x 738
        let photoUrl4 = "http://pic1.ooopic.com/00/87/39/27b1OOOPICf7.jpg"//813 x 592
        let photoUrl5 = "http://www.ctps.cn/PhotoNet/Profiles2011/20110503/20115302844162622467.jpg"//1208 x 806
        let photoUrl6 = "http://img2.3lian.com/2014/f2/110/d/57.jpg"//626 x 468

        //拍摄时间,由于是网络图片就自定义了一个时间
        let originalTime = TimeUtils.getCurrentTime()

        WYSdk.getInstance().setFrontCover("封面也就是书名", subTitle: "封面副标题", url: frontCoverUrl, lowPixelUrl: frontCoverUrl, originalTime: originalTime, width: 1210, height: 681)
        WYSdk.getInstance().setFlyleaf("头像", url: flyleafHeadUrl, lowPixelUrl: flyleafHeadUrl, originalTime: originalTime, width: 251, height: 251)
        WYSdk.getInstance().setPreface("这是序言")
        WYSdk.getInstance().setCopyright("这是作者名称", bookName: "这个是书名")
        WYSdk.getInstance().setBackCover(backCoverUrl, lowPixelUrl: backCoverUrl, originalTime: originalTime, width: 1358, height: 765)

        WYSdk.getInstance().addPhotoBlock("图片1", url: photoUrl1, lowPixelUrl: photoUrl1, originalTime: originalTime, width: 1289, height: 806)
        WYSdk.getInstance().addTextBlock("这是一段大文本1哦,我没跟在章节后面的哦")
        WYSdk.getInstance().addPhotoBlock("这个是照片2的描述哦,我也没跟在章节后面呢", url: photoUrl2, lowPixelUrl: photoUrl2, originalTime:originalTime, width: 1001, height: 751)

        WYSdk.getInstance().addChapterBlock("我是一个章节占一页哦", des: "我是章节的描述好吧")
        WYSdk.getInstance().addPhotoBlock("这个是照片3的描述哦,我也跟在章节后面呢", url: photoUrl3, lowPixelUrl: photoUrl3, originalTime: originalTime, width: 988, height: 738)
        WYSdk.getInstance().addPhotoBlock("这个是照片4的描述哦,我也跟在章节后面呢", url: photoUrl4, lowPixelUrl: photoUrl4, originalTime: originalTime, width: 813, height: 592)
        WYSdk.getInstance().addTextBlock("我是一个跟章节后面的文本2")

        WYSdk.getInstance().addChapterBlock("我是章节2", des: "我是章节的描述好吧")
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl5, lowPixelUrl: photoUrl5, originalTime: originalTime, width: 1208, height: 806)
        WYSdk.getInstance().addPhotoBlock("这个是照片6的描述哦,我也跟在章节后面呢", url: photoUrl6, lowPixelUrl: photoUrl6, originalTime: originalTime, width: 626, height: 468)
        WYSdk.getInstance().addTextBlock("我是跟章节2后面的文本哦")
    }

    private func postData() {
        WYSdk.getInstance().postPrintData(self, start: { 

        self.loadingIndicator.start()

        }, success: { (result) in

            self.loadingIndicator.stop()

        }) { (msg) in

            self.loadingIndicator.stop()

        }
    }

    func submitData(){
        addData()
        postData()
    }
    }



oc例子

    #import "ocsdkdemo-Swift.h"

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

        WYSdk *sdk = [WYSdk getInstance];
        //openid每个合作方的每个用户的唯一标识 建议写法 前缀+唯一标识 如 WY_xxxxxx
        [sdk setSDK:@"52HJR62BDS6SDD21" accessSecret:@"VlYmY2ZjBmOWFmZTJlZTk3NzdhN2M0ODM0MjE3" openId:@"openid"];
    }

    #import "ocsdkdemo-Swift.h"
    @implementation ViewController

    LoadingView *loading;
    WYSdk *sdk;

    - (void)viewDidLoad {
        [super viewDidLoad];
        loading = [LoadingView alloc];
        sdk = [WYSdk getInstance];

        //编辑页设置
        //[self edit];

        //合作方的支付设置
        //[self myAppPay];

        //这个是打开订单页,需要的时候可以调用
        //[sdk showOrderList:self];
        //这个是刷新订单状态的,在订单页才生效
        //[sdk refreshOrderState];
    }
    -(void) edit{
        //打开二次编辑面页 默认是开的
        [sdk isShowSelectDataViewController:YES];

        //上啦加载更多,默认是关闭的
        [sdk openLoadMore:YES];
        [sdk setLoadMoreDelegate:^{

        //[sdk getTextBlock]; //创建文本
        //[sdk getChapterBlock]; //创建章节
        [ThreadUtils threadOnAfterMain:1000 block:^{

            NSString*  photoUrl1 = @"http://img1.3lian.com/2015/w7/90/d/1.jpg";//1289 x 806
            NSDate* date = [[NSDate alloc] init];
            NSInteger originalTime =  round(date.timeIntervalSince1970);

            Block *block = [sdk getPhotoBlock:@"图片1"  url: photoUrl1  lowPixelUrl: photoUrl1  originalTime: originalTime  width: 1289  height: 806];

            NSMutableArray *arr = [NSMutableArray array];

            [arr addObject:block];
            [arr addObject:block];
            [arr addObject:block];
            [arr addObject:block];
            [arr addObject:block];

            [sdk addLoadMoreData:arr];
        }];
    }];
    }
    - (IBAction)postData:(id)sender {
        [self addData];
        [self postData];
    }

    //合作方的支付设置
    -(void) myAppPay{
        [sdk setMyAppPay:true];
        [sdk setPayOrderDelegate:^(NSString * orderId, float price , NSString * randomStr) {
            //处理支付
            //合作方需要 orderId randomStr 来通知微印服务器
            //支付成功后,合作方服务器调微印的服务器更新支付结果,文档在联调时索取
    }];
    }

    -(NSString*) md5:(NSString*) str
    {
        const char *cStr = [str UTF8String];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5( cStr, strlen(cStr), result );

        NSMutableString *hash = [NSMutableString string];
        for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
        {
            [hash appendFormat:@"%02X",result[i]];
        }
        return [hash lowercaseString];
    }
    - (void) addData{
        //图片素材 必须是网络路径 宽高也是必要的
        NSString*  frontCoverUrl = @"http://img1.3lian.com/2015/w7/98/d/22.jpg";//1210 x 681
        NSString*  flyleafHeadUrl = @"http://img21.mtime.cn/mg/2011/05/18/161045.63077415.jpg";//251 x 251
        NSString*  backCoverUrl = @"http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg";//1358 x 765

        NSString*  photoUrl1 = @"http://img1.3lian.com/2015/w7/90/d/1.jpg";//1289 x 806
        NSString*  photoUrl2 = @"http://img2.3lian.com/img2007/23/08/025.jpg";//1001 x 751
        NSString*  photoUrl3 = @"http://img1.goepe.com/201303/1362711681_6600.jpg";//988 x 738
        NSString*  photoUrl4 = @"http://pic1.ooopic.com/00/87/39/27b1OOOPICf7.jpg";//813 x 592
        NSString*  photoUrl5 = @"http://www.ctps.cn/PhotoNet/Profiles2011/20110503/20115302844162622467.jpg";//1208 x 806
        NSString*  photoUrl6 = @"http://img2.3lian.com/2014/f2/110/d/57.jpg";//626 x 468

        //拍摄时间 由于是网络图片就自定义了一个时间

        NSDate* date = [[NSDate alloc] init];
        NSInteger originalTime =  round(date.timeIntervalSince1970);

        [sdk setFrontCover:@"封面也就是书名" subTitle: @"封面副标题" url: frontCoverUrl lowPixelUrl: frontCoverUrl originalTime: originalTime  width:1210 height: 681];

        [sdk setFlyleaf:@"头像"  url: flyleafHeadUrl  lowPixelUrl: flyleafHeadUrl  originalTime: originalTime  width: 251  height: 251];
        [sdk setPreface:@"这是序言"];
        [sdk setCopyright:@"这是作者名称"  bookName: @"这个是书名"];
        [sdk setBackCover:backCoverUrl  lowPixelUrl: backCoverUrl  originalTime: originalTime  width: 1358  height: 765];

        [sdk addPhotoBlock:@"图片1"  url: photoUrl1  lowPixelUrl: photoUrl1  originalTime: originalTime  width: 1289  height: 806];
        [sdk addTextBlock:@"这是一段大文本1哦 我没跟在章节后面的哦"];
        [sdk addPhotoBlock:@"这个是照片2的描述哦 我也没跟在章节后面呢"  url: photoUrl2  lowPixelUrl: photoUrl2  originalTime: originalTime  width: 1001  height: 751];

        [sdk addChapterBlock:@"我是一个章节占一页哦"  des: @"我是章节的描述好吧"];
        [sdk addPhotoBlock:@"这个是照片3的描述哦 我也跟在章节后面呢"  url: photoUrl3  lowPixelUrl: photoUrl3  originalTime: originalTime  width: 988  height: 738];
        [sdk addPhotoBlock:@"这个是照片4的描述哦 我也跟在章节后面呢"  url: photoUrl4  lowPixelUrl: photoUrl4  originalTime: originalTime  width: 813  height: 592];
        [sdk addTextBlock:@"我是一个跟章节后面的文本2"];

        [sdk addChapterBlock:@"我是章节2"  des: @"我是章节的描述好吧"];
        [sdk addPhotoBlock:@""  url: photoUrl5  lowPixelUrl: photoUrl5  originalTime: originalTime  width: 1208  height: 806];
        [sdk addPhotoBlock:@"这个是照片6的描述哦 我也跟在章节后面呢"  url: photoUrl6  lowPixelUrl: photoUrl6  originalTime: originalTime  width: 626 height: 468];
        [sdk addTextBlock:@"我是跟章节2后面的文本哦"];
    }

    - (void) postData{

        [sdk postPrintData:self start:^{
            [loading start];
    } success:^(id result) {
            [loading stop];
    } failed:^(NSString * msg) {
            [loading stop];
    }];
    }
